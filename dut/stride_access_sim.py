import numpy as np
import math
import sys
import csv_manipulation
import os

# Pre-processor
DONT_CARE_MACRO = np.uint32(65535)

class permutationNetwork:
	def __init__(self):
		## Decoder configuration
		self.block_length = 7650
		self.Z=765
		self.q = 3  # 3-bit quantisation
		self.VN_DEGREE = 3
		self.CN_DEGREE = 10
		self.M = self.VN_DEGREE-1
		self.layer_num=3
		self.cardinality = pow(2, self.q) # by exploiting the symmetry of CNU, 3-Gbit input is enough
		self.Iter_max = 10
		## Permutation network configuration
		self.Pc=15
		self.bs_length=self.Pc
		self.rowSplit_factor=5
		self.parallel_col_num = math.ceil(self.CN_DEGREE / self.rowSplit_factor)
		self.BaseMatrix=np.array([
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			[0, 656, 76, 132, 184, 233, 216, 490, 714, 715],
			[0, 22, 650, 359, 587, 65, 463, 635, 91, 100]]
		)
		self.submatrix_row_num, self.submatrix_col_num = self.BaseMatrix.shape

		## The acutal shfit factors to instruct the corresponding barrel shifters
		self.bs_shift=np.zeros((self.layer_num, self.CN_DEGREE), dtype=np.uint32)
		
		## The access addresses for the corresponding devices and pages, where the 
		## 	a) each Pc-length BS input by Pc number of devices
		## 	b) each Pc-length BS output by Pc number of devices
		col_size=self.CN_DEGREE*self.Z
		self.bs_deviceAddr=np.empty((self.layer_num, col_size), dtype=np.uint32)
		self.bs_pageAddr=np.empty((self.layer_num, col_size), dtype=np.uint32)

		# To generate vector of permutation outputs
		self.bsOut_vec = np.empty((self.layer_num, self.CN_DEGREE, int(self.Z / self.Pc), self.Pc), dtype=np.uint32)
		self.pageAddr_out_vec = np.empty((self.layer_num, self.CN_DEGREE, int(self.Z / self.Pc), self.Pc), dtype=np.uint32)

		## Configuration of naive folded permutation
		self.naive_rowChunk_num=int(self.Z / self.Pc)

		## Configuration of stride-access folded permutation
		# Stride access decomposition
		self.stride_width=3
		self.stride_chunk_num = math.ceil(self.naive_rowChunk_num / self.stride_width)
		self.strideBs_Latency=int(self.Z/(self.Pc*self.stride_width)) # the total latency to complete permutation in a stride access manner

		#=========================================================================
		#Memory emulation
		#=========================================================================
		self.naive_fold_mailbox=np.empty((self.layer_num, self.CN_DEGREE, int(self.Z / self.Pc), self.Pc), dtype=np.uint32)
		#=========================================================================
		#End of memory emulation
		#=========================================================================
		# Shift control files exporting
		self.SHIFT_CTRL_FOLDER = "z" + str(self.Z) + \
							"_Pr" + str(self.bs_length) + \
							"_Ws" + str(self.stride_width)

		# End of "Shift control files exporting"
		# =========================================================================

	def permutation(self, vec_in, permutation_len, shift_factor):
		vec_out=np.empty(permutation_len, dtype=np.uint32)
		for i in range(0, permutation_len):
			shift_index=(i+shift_factor) % permutation_len
			vec_out[i]=vec_in[shift_index]
	
		return vec_out

	def permutation_implementation_test(self):
		vec_in=np.arange(self.Pc, dtype=np.uint32)
		for i in range(self.Pc):
			vec_out = self.permutation(vec_in=vec_in, permutation_len=self.Pc, shift_factor=i)
			print("Shift_run_%d" % (i), vec_out)

	def display(self):
		print("Base Matrix:\n", self.BaseMatrix)
		print("\n")
		print("DA:\n", self.bs_deviceAddr)
		print("\n")
		print("PA:\n", self.bs_pageAddr)

	# Index of shifted message in a segment (or called row chunk)
	def segment_pos(self, s, t, sub_size, seg_size):
		return int(((sub_size-s+t) % sub_size) % seg_size);

	# Address of segment (or called index of row chunk) for storing the shifted message
	def segment(self, s, t, sub_size, seg_size):
		return int(math.floor(((sub_size-s+t) % sub_size) / seg_size));

	def bs_addr_cal(self):
		for layer_id in range(self.layer_num):
			for sub_matrix_id in range(self.CN_DEGREE):
				layer_0_shift = int(self.BaseMatrix[layer_id][sub_matrix_id])
				layer_1_shift = int(self.BaseMatrix[(layer_id+1) % self.layer_num][sub_matrix_id])
				if(layer_1_shift==0):
					shift_acc=0;
					for acc_id in range(layer_id):
						shift_acc = shift_acc + self.bs_shift[acc_id][sub_matrix_id]
					interLayer_offset=self.Pc-int(shift_acc % self.Pc)
				else:
					interLayer_offset=abs(int((self.Z- layer_0_shift) % self.Pc)-int((self.Z- layer_1_shift) % self.Z))

				self.bs_shift[layer_id][sub_matrix_id]=interLayer_offset

				# To determine the device and page addresses
				row_chunk_cnt=0
				for col in range(self.Z):
					pcm_col=(sub_matrix_id*self.Z)+col
					self.bs_deviceAddr[layer_id][pcm_col]=self.segment_pos(layer_1_shift, (col+layer_0_shift) % self.Z, self.Z, self.Pc)
					self.bs_pageAddr[layer_id][pcm_col]=self.segment(layer_1_shift, (col+layer_0_shift) % self.Z, self.Z, self.Pc)
					#if(layer_id==0 and sub_matrix_id==1):
					#	print("[%d] -> PA: %d, DA: %d\n" % (col, self.bs_pageAddr[layer_id][pcm_col], self.bs_deviceAddr[layer_id][pcm_col]))

	def stride_unitAddr_cal(self, pcm_col, layer_id):
		stride_front=self.Z*pcm_col
		relative_stride_rear=0
		bsOut_vec=np.zeros(self.Z, dtype=np.uint32)
		pageAddr_out_vec=np.zeros(self.Z, dtype=np.uint32)
		for stride_iter in range(self.strideBs_Latency):
			for stride_id in range(self.stride_width):
				for bsIn_id in range(self.Pc):
					bsOut_vec[relative_stride_rear]=self.bs_deviceAddr[layer_id][stride_front+relative_stride_rear]
					pageAddr_out_vec[relative_stride_rear]=self.bs_pageAddr[layer_id][stride_front+relative_stride_rear]
					# After bs
					#if(layer_id==0 and pcm_col==1):
					#	print("Relative_stride_rear: %d, Pa: %d, Da: %d\n" % (relative_stride_rear, pageAddr_out_vec[relative_stride_rear], bsOut_vec[relative_stride_rear]))

					relative_stride_rear = relative_stride_rear + 1

		return bsOut_vec, pageAddr_out_vec

	def stride_addr_config(self):
		# To calculate the device and page addresses regardless of stride accesses
		self.bs_addr_cal()

		# To further fold the permutation in a stride access manner,
		# and calculate their corresponding addresses (aware of stride accesses)
		for layer_id in range(self.layer_num):
			#print("----------------------------------------------------------------------------------------------------------------------\n", "Layer_%d" % (layer_id))
			for pcm_col in range(self.CN_DEGREE):
				#print("Base Matrix Column_%d" % (pcm_col), "\n\n")
				da, pa = self.stride_unitAddr_cal(pcm_col=pcm_col, layer_id=layer_id)
				self.bsOut_vec[layer_id][pcm_col] = np.array(da).reshape(-1, self.Pc)
				self.pageAddr_out_vec[layer_id][pcm_col] = np.array(pa).reshape(-1, self.Pc)
				#print("Device addresses:\n", self.bsOut_vec[layer_id][pcm_col])
				#print("\n")
				#print("Page addresses:\n", self.pageAddr_out_vec[layer_id][pcm_col])
				#print("\n----------------------------------------------------------------------------------------------------------------------\n")

	def naive_fold_permutation(self, vec_in, row_chunk_id, pcm_col, layer_id):
		for i in range(self.Pc):
			device_addr=self.bsOut_vec[layer_id][pcm_col][row_chunk_id][i]
			page_addr=self.pageAddr_out_vec[layer_id][pcm_col][row_chunk_id][i]

			self.naive_fold_mailbox[layer_id][pcm_col][page_addr][device_addr]=vec_in[i]
			#if(layer_id==0 and pcm_col==1):
			#	print("page_addr: %d, device_addr: %d, vec_in[%d]: %d\n" % (page_addr, device_addr, i, vec_in[i]))

	def chunkGroup_diversity(self, common_intersection):
		# To collect every element's corresponding vote
		intersaction_strideIDs = np.empty(len(common_intersection), dtype=np.int32)
		for i in range(len(common_intersection)):
			intersaction_strideIDs[i] = int(common_intersection[i] / self.stride_width)

		candidates = np.unique(np.array(intersaction_strideIDs)) # To identify all distinct candidates for the following majority vote

		# To start voting
		# The number of candidates suppose to be two
		votes = np.zeros(2, dtype=np.int16)
		for candidate in intersaction_strideIDs:
			if candidate == candidates[0]:
				votes[0] = votes[0] + 1
			else:
				votes[1] = votes[1] + 1
		majorityID = np.argmax(votes)
		majority = candidates[majorityID]
		print("StrideID:", intersaction_strideIDs, "candidates:", candidates, "votes:", votes, "majorityID:", majorityID)
		# To keep the elements belonging to the major group
		isEnd = 0
		while isEnd == 0:
			for i in range(len(common_intersection)):
				print("Candidates:", candidates, "Majority:", majority, "StrideID:", intersaction_strideIDs, " Intersection:", common_intersection)
				if intersaction_strideIDs[i] != majority:
					common_intersection = np.delete(common_intersection, i)
					intersaction_strideIDs = np.delete(intersaction_strideIDs, i)
					break

				if i == len(common_intersection)-1 or len(common_intersection) == 0:
					isEnd = 1
		print(common_intersection)
		return common_intersection

	#
	def page_alignment_configGen(self, layer_id):
		#bs = permutationNetwork(permutation_length=self.Pc)
		# bs.permutation_implementation_test()

		# To generate vector of permutation inputs
		vec_in = np.arange(self.block_length * self.layer_num, dtype=np.uint32)
		self.stride_addr_config()

		submatrix_col_sets = np.arange((self.stride_width+1)*self.stride_chunk_num*self.submatrix_col_num).reshape(self.submatrix_col_num, self.stride_chunk_num, (self.stride_width+1))
		for submatrix_col_id in range(1, self.submatrix_col_num, 1):
			for row_chunk_id in range(self.stride_chunk_num):
				#print("/*--------------------------------------------*/")
				#print("// Pipeline stage ", row_chunk_id)
				#print("/*--------------------------------------------*/")
				for device_id in range(self.bs_length):
					for stride_id in range(self.stride_width):
						if (device_id == 0 and stride_id == 0):
							set_temp = self.pageAddr_out_vec[layer_id][submatrix_col_id][(row_chunk_id * self.stride_width) + stride_id][device_id]
						else:
							set_temp = np.union1d(set_temp, self.pageAddr_out_vec[layer_id][submatrix_col_id][(row_chunk_id * self.stride_width) + stride_id][device_id])
						#print(bs.pageAddr_out_vec[layer_id][submatrix_col_id][(row_chunk_id * bs.stride_width) + stride_id][device_id], end=",\t")
					#print("")

				#print("Submatrix_col_", submatrix_col_id, " -> Union set:", end=" ")
				#print(set_temp)

				# To avoid any mismatch of the union set size
				set_temp_size_gap = self.stride_width+1-len(set_temp)
				if set_temp_size_gap != 0:
					for zero_pad in range(set_temp_size_gap):
						set_temp = np.append(set_temp, DONT_CARE_MACRO)
				submatrix_col_sets[submatrix_col_id][row_chunk_id] = set_temp

		# To search for the largest intersection between a) each reference-column set element and b) those of the other column set elements
		for submatrix_col_id_0 in range(0, self.submatrix_col_num, 1):
			print("-----------------------------------------------------------------------")
			# target_rowChunks_nonChosen = np.arrange(self.stride_chunk_num)
			for ref_row_chunk_id in range(self.stride_chunk_num):
				# if submatrix_col_id_0 == 2 and submatrix_col_id_1 == 3:
				#	print("col_", submatrix_col_id_0, " & col_", submatrix_col_id_1, "\t->\t", stride_chunk_id_max, max_intersection_set)
				# if ref_row_chunk_id == (bs.stride_chunk_num-1):
				#	print("col_", submatrix_col_id_0, " & col_", submatrix_col_id_1, "\t->\t", stride_chunk_id_max, max_intersection_set, end="\t")
				#	print("Intersection size: ", len(max_intersection_set))
				print("(strideChunkID_", ref_row_chunk_id, ") col_", submatrix_col_id_0,
					  "\t->\t", submatrix_col_sets[submatrix_col_id_0][ref_row_chunk_id])
				Dict_pageAlign_info_ref = self.stride_shift_config(
					layer_id,
					ref_row_chunk_id,
					submatrix_col_id_0
				)
				# print(str(Dict_pageAlign_info_ref['aligned_pattern_id']).replace(str(DONT_CARE_MACRO), "DON'T CARE"), str(Dict_pageAlign_info_parallel_1['aligned_pattern_id']).replace(str(DONT_CARE_MACRO), "DON'T CARE"))
				print("Shift Factors: ", Dict_pageAlign_info_ref['shift_factor'])
				print('------------')


	# To decide the 2-level bs (or called 1-level page alignment)
	def stride_shift_config(self, layer_id, stride_chunk_id, sumbmatrix_col_id_0):
		Dict_pageAlign_info_ref = self.stride_shift_calc(isRef=1,
											  layer_id=layer_id,
											  stride_chunk_id=stride_chunk_id,
											  sumbmatrix_col_id=sumbmatrix_col_id_0)

		return Dict_pageAlign_info_ref

	def stride_shift_calc(self, isRef, layer_id, stride_chunk_id, sumbmatrix_col_id):
		aligned_pattern_id = np.empty((self.Pc, self.stride_width), dtype=np.uint32)
		shift_factors = np.empty(self.bs_length, dtype=np.uint32)
		Dict_pageAlign_info = {
			'shift_factor': shift_factors,
			'aligned_pattern_id': aligned_pattern_id
		}

		# To prepare each x_{i} in X, for i = 0, 1, ..., P_{r}-1
		X = np.zeros((self.bs_length, self.stride_width), dtype=np.uint32)
		for i in range(self.bs_length):
			for stride_id in range(self.stride_width):
					relative_deviceID = self.bsOut_vec[layer_id][sumbmatrix_col_id][(stride_chunk_id * self.stride_width) + stride_id][i]
					X[relative_deviceID][stride_id] = self.pageAddr_out_vec[layer_id][sumbmatrix_col_id][(stride_chunk_id * self.stride_width) + stride_id][i]

		# To determine the (circularly) right-shift factor for the reference sub-matrix column
		i=0;

		# To create and save a header to CSV file
		l1bs_relRowChunkID_list = [stride_chunk for stride_chunk in range(0, self.stride_width)] # header
		l1pa_relRowChunkID_list = [stride_chunk for stride_chunk in range(0, self.stride_width)]  # header
		for t in range(self.stride_width):
			l1bs_relRowChunkID_list[t] = 'relRowChunk_'+str(t)+'(L1BS)'
		for t in range(self.stride_width):
			l1pa_relRowChunkID_list[t] = 'relRowChunk_'+str(t)+'(L1PA)'

		# To export the page addresses for shifted messages by L1BS to .CSV file
		STRIDE_SHFIT_CTRL_FILENAME = 'col'+str(sumbmatrix_col_id)+'_strideUnit'+str(stride_chunk_id)+'_layer'+str(layer_id)+'.csv'
		csv_manipulation.csv_save(filename=STRIDE_SHFIT_CTRL_FILENAME, list_in=l1bs_relRowChunkID_list+l1pa_relRowChunkID_list+['L1PA_shiftCtrl'])

		for x_i in X:
			# To search the index of referenced list of which the referenced_list[cnt_ref] == max_list[cnt_max]
			for cnt_max in range(self.stride_width):
				for cnt_ref in range(self.stride_width):
					aligned_pattern_id[i][cnt_max] = cnt_ref
					if cnt_ref > self.stride_width:
						print("---------------", cnt_ref)
						pass
					break

			# To calculate the shift factor
			flag = 0
			first_index = 0
			cnt = 0
			while flag == 0:
				found_index = np.int32(aligned_pattern_id[i][cnt])
				if found_index == first_index:
					found_index = cnt
					flag = 1
				else:
					if cnt == self.stride_width-1:
						cnt = 0
						first_index = first_index + 1
					else:
						cnt = cnt + 1

			found_index = x_i[0] % self.stride_width
			l1pa_shift = found_index-first_index
			if l1pa_shift < 0:
				l1pa_shift = self.stride_width + l1pa_shift
			else:
				l1pa_shift = l1pa_shift

			Dict_pageAlign_info['shift_factor'][i] = l1pa_shift
			aligned_patterns = np.empty(self.stride_width, dtype=np.uint32)
			aligned_patterns_str = np.empty(self.stride_width, dtype=object)
			for pattern_id in range(self.stride_width):
				shifted_id = (pattern_id+l1pa_shift) % self.stride_width
				aligned_patterns[shifted_id] = x_i[pattern_id]
				# to identify whether the aligned elements is "Don't care value" or real value
				str_temp = str(aligned_patterns[shifted_id])
				aligned_patterns_str[shifted_id] = str_temp

			if isRef == 1:
				# To print out the aligned_pattern_id
				#print('x_i: ', x_i, ' with ', intersection_set, ' \t->\t', str(aligned_pattern_id[i]).replace(str(DONT_CARE_MACRO), "X"), "\t->\tThe stride shift factor is ", l1pa_shift)
				## To print out the aligned_patterns
				print('x_i (after 1-level circular shifted): ', x_i, ' (intent L1PA result)\t->\t', aligned_patterns_str, "\t->\tThe shift ctrl. for L1PA is ", l1pa_shift)
				#pass
				l1bsOut_l1paOut = np.append(x_i, aligned_patterns_str)
				l1bsOut_l1paOut_l1paShift = np.append(l1bsOut_l1paOut, l1pa_shift)
				csv_manipulation.csv_append(filename=STRIDE_SHFIT_CTRL_FILENAME, list_in=l1bsOut_l1paOut_l1paShift)
			else:
				# To print out the aligned_pattern_id
				#print('Y_l: ', x_i, ' with ', intersection_set, ' \t->\t', str(aligned_pattern_id[i]).replace(str(DONT_CARE_MACRO), "Y"), "\t->\tThe stride shift factor is ", l1pa_shift)
				# To print out the aligned_patterns
				#print('\tY_l (after 1-level circular shifted): ', x_i, ' with ', intersection_set, ' (expectation of 2-level circular shifted result) \t->\t', aligned_patterns_str, "\t->\tThe stride shift factor is ", l1pa_shift)
				pass

			i = i + 1

		Dict_pageAlign_info['aligned_pattern_id'] = aligned_pattern_id
		os.system("mv " + STRIDE_SHFIT_CTRL_FILENAME + " ./" + self.SHIFT_CTRL_FOLDER)
		return Dict_pageAlign_info

def main_page_align():
	permutation_newtork = permutationNetwork()
	isExist = os.path.exists("./" + permutation_newtork.SHIFT_CTRL_FOLDER)
	if isExist == True:
		os.system("rm -rf ./" + permutation_newtork.SHIFT_CTRL_FOLDER)
	os.mkdir("./" + permutation_newtork.SHIFT_CTRL_FOLDER)

	for layer_id in range(permutation_newtork.layer_num):
		print("-------------------------------------------------------------")
		print("Layer ", layer_id)
		print("-------------------------------------------------------------")
		permutation_newtork.page_alignment_configGen(layer_id=layer_id)

def permutation_emulation():
	if (len(sys.argv) != 2):
		print("Please give the Pc")
		sys.exit()
	bs = permutationNetwork()
	bs.permutation_length=int(sys.argv[1])
	# bs.permutation_implementation_test()

	# To generate vector of permutation inputs
	vec_in = np.arange(bs.block_length * bs.layer_num, dtype=np.uint32)
	bs.stride_addr_config()

	# To start the emulation of message passing across base matrix columns
	err_sum = 0
	for layer_id in range(bs.layer_num):
		for pcm_col in range(bs.CN_DEGREE):
			front = (pcm_col * bs.Z) + (layer_id * bs.block_length)
			rear = ((pcm_col + 1) * bs.Z - 1) + (layer_id * bs.block_length)

			# ================================================================
			# Emulation of naive fold permutation
			fold_vec_out_curLayer = bs.permutation(
				vec_in=vec_in[front: rear + 1],
				permutation_len=bs.Z,
				shift_factor=bs.BaseMatrix[layer_id][pcm_col]
			)
			for chunk_id in range(bs.naive_rowChunk_num):
				chunk_front = (chunk_id * bs.Pc)
				chunk_rear = (chunk_id + 1) * bs.Pc - 1
				bs.naive_fold_permutation(
					vec_in=fold_vec_out_curLayer[chunk_front:chunk_rear + 1],
					row_chunk_id=chunk_id,
					pcm_col=pcm_col,
					layer_id=layer_id
				)
			# End of emulation of naive fold permutation
			# ================================================================
			unfold_vec_out = bs.permutation(
				vec_in=vec_in[front: rear + 1],
				permutation_len=bs.Z,
				shift_factor=bs.BaseMatrix[(layer_id + 1) % bs.layer_num][pcm_col]
			)

			err_cnt = 0
			for dev_id in range(bs.Z):
				naive_unfold_pageAddr = math.floor(dev_id / bs.Pc)
				naive_unfold_deviceAddr = int(dev_id % bs.Pc)
				# To emulate the read operation of Msg-Pass MEMs
				mailbox_recv = bs.naive_fold_mailbox[layer_id][pcm_col][naive_unfold_pageAddr][naive_unfold_deviceAddr]
				if (unfold_vec_out[dev_id] == mailbox_recv):
					err_cnt = err_cnt + 1
					if (layer_id == 0 and pcm_col == 1):
						print("Layer_%d, Col_%d --  unfold_val: %d and naive_fold_val[page_%d][dev_%d]: %d\n" %
							  (
							  layer_id, pcm_col, unfold_vec_out[dev_id], naive_unfold_pageAddr, naive_unfold_deviceAddr,
							  mailbox_recv)
							  )

			err_sum = err_sum + err_cnt
	# print("Layer_%d, Col_%d, err_cnt: %d,\terr_sum: %d\n" % (layer_id, pcm_col, err_cnt, err_sum))

def main():
	#permutation_emulation()
	main_page_align()

if __name__ == "__main__":
	main()
