import numpy as np
import math
import itertools
import sys
import csv_manipulation

# Pre-processor
DONT_CARE_MACRO = np.uint32(65535)

SEED_0 = 173
SEED_1 = 6347
SEED_2 = 466

class shareIB_LUT_configurator:
	Y_in = []
	R_gp2 = []
	regFile = []

	def __init__(self, stride_width, subgroup2_num, subgroup2_bankBaseAddr):
		self.stride_width = stride_width
		self.N_gp2 = subgroup2_num
		self.Base_gp2 = subgroup2_bankBaseAddr
		self.maxSeq_size = self.shiftSequence_eval()
		self.feasible_shiftPattern_vec = np.arange(start=0, stop=self.stride_width, step=1)  # list of all feasible shift patterns

	def incomingMsg_load(self, incomingMsg_vec, subgroup2_rqstFlag_vec):
		self.Y_in = incomingMsg_vec
		self.R_gp2 = subgroup2_rqstFlag_vec

	def XNOR_2X1(self, operand_0, operand_1):
		res = ~(operand_0^operand_1)
		return (res & 1) # To mask out all bits except LSB

	def AND_2X1(self, operand_0, operand_1):
		res = operand_0 & operand_1
		return (res & 1) # To mask out all bits except LSB

	def NOT_1X1(self, operand_0):
		res = ~operand_0
		return (res & 1) # To mask out all bits except LSB

	# To create the new permuation of incoming messages by circularly right shifting S position
	# return indices and indexed values that represent the shifted messages
	def circular_permutation(self, vec_in, shift_factor):
		vec_out = np.empty(self.stride_width, dtype=np.uint32)
		vecIndex_out = np.arange(start=0, stop=self.stride_width, step=1) # initial msg indices = {0, 1, ..., stride_width-1}
		for i in range(self.stride_width):
			#shifted_index = (i+stride_width) % stride_width # left rotation
			shifted_index = (i+self.stride_width-shift_factor) % self.stride_width # right rotation
			vecIndex_out[i] = shifted_index
			vec_out[i] = vec_in[shifted_index]

		return vecIndex_out, vec_out

	def l1pa_shift_feasible_checker(self, msg_in, R_gp2_in, Base_gp2_in, shift_sequence_vec):
		row_size, col_size = shift_sequence_vec.shape
		isFeasible = np.zeros(row_size, dtype=np.uint32)
		feasible_shiftSeq_vec = []
		seq_cnt = 0;

		# Feasibility checking for every shift sequence
		for shift_seq in shift_sequence_vec:
			allocNum = 0
			latency = 0
			dealloc = np.ones(self.stride_width, dtype=np.uint32)
			for shift_pattern in shift_seq:
				I_msg, vec_out = self.circular_permutation(vec_in=msg_in, shift_factor=shift_pattern)
				for i in range(self.stride_width):
					j = I_msg[i]
					r = R_gp2_in[j]
					b = Base_gp2_in[i]
					d = dealloc[j]
					#--------------------------
					# Solution 1: (r xnor b)*d
					#temp = self.XNOR_2X1(r, b)
					# --------------------------
					# Solution 2:
					#~(r & ~b)*d
					temp = self.NOT_1X1(b)
					temp = self.AND_2X1(operand_0=r, operand_1=temp)
					temp = self.NOT_1X1(temp)
					# --------------------------
					alloc = self.AND_2X1(operand_0=temp, operand_1=d)  # to update GP1/GP2 allocation status
					dealloc[j] = dealloc[j] - alloc
					allocNum = allocNum + alloc

				latency = latency + 1
				if(allocNum == self.stride_width): # To halt checking early
					break

			# Feasibility checking
			if(allocNum == self.stride_width):
				isFeasible[seq_cnt] = 1
				feasible_shiftSeq_vec.append(shift_seq)
				#print("Shift sequence: ", shift_seq, " is feasible with ", latency, " iteration")
			else:
				#print("Shift sequence: ", shift_seq, " is infeasible")
				pass
			seq_cnt = seq_cnt + 1

		return isFeasible, feasible_shiftSeq_vec

	def l2pa_invalidIndex_patternGen(self, msg_in, R_gp2_in, Base_gp2_in, shift_seq):
		shift_seq_size = shift_seq.size
		load_seq_size = shift_seq_size-1 # the first pattern cycle is all-X loads, i.e. dummy L2PA operation
		load_seq = np.zeros((load_seq_size, self.stride_width), dtype=np.uint32)
		invalidIndex_seq = np.ones((shift_seq_size, self.stride_width), dtype=np.uint32)
		pattern_cnt = 0;

		# Feasibility checking for every shift sequence
		allocNum = 0
		dealloc = np.ones(self.stride_width, dtype=np.uint32)
		for shift_pattern in shift_seq:
			I_msg, vec_out = self.circular_permutation(vec_in=msg_in, shift_factor=shift_pattern)
			for i in range(self.stride_width):
				j = I_msg[i]
				r = R_gp2_in[j]
				b = Base_gp2_in[i]
				d = dealloc[j]
				# Solution 2:
				# ~(r & ~b)*d
				temp = self.NOT_1X1(b)
				temp = self.AND_2X1(operand_0=r, operand_1=temp)
				temp = self.NOT_1X1(temp)
				# --------------------------
				alloc = self.AND_2X1(operand_0=temp, operand_1=d)  # to update GP1/GP2 allocation status
				dealloc[j] = dealloc[j] - alloc
				invalidIndex_seq[pattern_cnt][i] = alloc # to generate the invalid index pattern, 0: invalid access
				allocNum = allocNum + alloc

			pattern_cnt = pattern_cnt + 1
		return load_seq, invalidIndex_seq

	# To calculate the maximum possible size of one sequence of shift patterns
	def shiftSequence_eval(self):
		return math.ceil(self.stride_width / self.N_gp2)

	def shiftSequence_pattern_gen(self, shiftNum):
		perm_len = int(math.factorial(self.stride_width) / math.factorial(self.stride_width - shiftNum))
		perm_vec = itertools.permutations(self.feasible_shiftPattern_vec, shiftNum)
		shift_sequence_vec = np.empty((perm_len, shiftNum), dtype=np.uint32)
		perm_index = 0
		for p in perm_vec:
			shift_sequence_vec[perm_index] = p
			perm_index = perm_index + 1

		return shift_sequence_vec

	def temp(self):
		rqstType_cnt = 0
		isFeasible_overall = 1

		for i in range(self.stride_width+1):
			rqstType_cnt = rqstType_cnt + int(math.factorial(self.stride_width) / (math.factorial(i) * math.factorial(self.stride_width-i)))

		requestor_indices = np.arange(start=0, stop=self.stride_width, step=1)
		subgroup2_rqstFlag_vec = np.zeros((rqstType_cnt, self.stride_width), dtype=np.uint32)
		reqstFlag_vec_cnt = 0

		# Export the set of feasible shift pattern sequences for L1PA
		alloc_temp = ""
		for a in self.Base_gp2:
			alloc_temp = alloc_temp + str(a)
		filename = "l1pa_spr_" + str(self.stride_width)+"_gp2Num"+str(self.N_gp2)+"_gp2Alloc"+str(alloc_temp)
		header = ["#PatternID", "GP2_request_pattern", "L1PA_SPR", "sequenceElementID"]
		csv_manipulation.csv_save(filename= filename+'.csv', list_in=header)

		gp2_rqst_id = 0
		for gp2_rqst_num in range(self.stride_width+1):
			gp2_rqstFlag_indices = itertools.combinations(requestor_indices, gp2_rqst_num)
			for indices in gp2_rqstFlag_indices:
				for i in range(gp2_rqst_num):
					index = indices[i]
					subgroup2_rqstFlag_vec[reqstFlag_vec_cnt][index] = 1
				#print(subgroup2_rqstFlag_vec)
				#reqstFlag_vec_cnt = reqstFlag_vec_cnt + 1
				rqstFlag_vec = subgroup2_rqstFlag_vec[reqstFlag_vec_cnt]
				reqstFlagVec_feasibleNum = 0
				for shiftNum in range(1, self.maxSeq_size + 1):
					#print("Base_gp2: ", self.Base_gp2, "\tR_gp2: ", rqstFlag_vec, "\tmaxSeq_size: ", self.maxSeq_size)
					#print("%dP%d: " % (self.stride_width, shiftNum))
					# print(shift_sequence_vec)
					shift_sequence_vec = self.shiftSequence_pattern_gen(shiftNum=shiftNum)
					isFeasible, feasible_shiftSeq_vec = self.l1pa_shift_feasible_checker(
						msg_in=self.Y_in,
						R_gp2_in=rqstFlag_vec,
						Base_gp2_in=self.Base_gp2,
						shift_sequence_vec=shift_sequence_vec
					)

					# ------ Exporting the .CSV file, and .COE files of L2PA load patterns and invalid index patterns
					if(len(feasible_shiftSeq_vec) > 0):
						if gp2_rqst_id == 31:
							print(gp2_rqst_id)
						list_in = []
						gp2_rqst_temp = ""
						for g in rqstFlag_vec:
							gp2_rqst_temp = gp2_rqst_temp + str(g)
						list_in.append(str(gp2_rqst_id))
						list_in.append(gp2_rqst_temp)
						load_seq, invalidIndex_seq = self.l2pa_invalidIndex_patternGen(msg_in=self.Y_in, R_gp2_in=rqstFlag_vec, Base_gp2_in=self.Base_gp2, shift_seq=feasible_shiftSeq_vec[0])
						for l1pa_spr_id in range(len(feasible_shiftSeq_vec[0])): # just taking the first feasible pattern sequence is sufficient
							sublist = []
							sublist = list_in.copy()
							sublist.append(str(feasible_shiftSeq_vec[0][l1pa_spr_id]))
							sublist.append(str(l1pa_spr_id))
							csv_manipulation.csv_append(filename=filename + '.csv', list_in=sublist)
					# ------ End of CSV exporting
					cnt = 0;
					for seq in feasible_shiftSeq_vec:
						print("%dP%d: " % (self.stride_width, shiftNum), "\t->\t", seq)
						if (cnt >= 1):  # Do not print out too many feasible solutions
							break
						cnt = cnt + 1
					# Since the feasible solution(s) has/have been found, the following searching is halted
					if(len(feasible_shiftSeq_vec) > 0):
						print("Since the feasible solution(s) has/have been found, the follwoing searching is halted.")
						break
					#print("The number of feasible solutions: %d" % (sum(isFeasible)))
					#print("-----------------------------")

				isFeasible_curPerm = sum(isFeasible)
				if isFeasible_curPerm == 0:
					isFeasible_overall = 0
				reqstFlagVec_feasibleNum = reqstFlagVec_feasibleNum + sum(isFeasible)
				print("Base_gp2: ", self.Base_gp2, "\tR_gp2: ", rqstFlag_vec, "\tmaxSeq_size: ", self.maxSeq_size)
				print("The number of feasible solutions: %d" % (reqstFlagVec_feasibleNum))
				print("-----------------------------")
				reqstFlag_vec_cnt = reqstFlag_vec_cnt + 1 # to counting the considered case of GP2 request pattern (for exporting the .CSV file)
				gp2_rqst_id = gp2_rqst_id + 1
		if(isFeasible_overall == 0):
			print("The H/W settings of Base_gp2: ", self.Base_gp2, "\tmaxSeq_size: ", self.maxSeq_size, ", is not feasible. The size of GP2 subject to the given maxSeq_size ought to be increased.")


	# Hardware configuration
	def l1pa_regFile_gen(self, shift_sequence_vec, seq_endFlag_vec):
		actual_reg_num = shift_sequence_vec.size
		self.regFile = np.empty((actual_reg_num, 2), dtyp=np.uint32)
		max_reg_num = 0
		for i in range(self.stride_width+1):
			max_reg_num = max_reg_num + int(math.factorial(self.stride_width) / (math.factorial(i) * math.factorial(self.stride_width - i)))
		max_reg_num = max_reg_num*self.maxSeq_size

		for page in range(actual_reg_num):
			self.regFile[page] = [shift_sequence_vec[page], seq_endFlag_vec[page]]

def main():
	stride_width = 5
	C2V_vec = np.arange(start=0, stop=stride_width, step=1)
	subgroup2_num = 3
	subgroup2_bankBaseAddr = np.flip(np.array([1, 0, 1, 0, 1]))
	configurator = shareIB_LUT_configurator(
		stride_width=stride_width,
		subgroup2_num=subgroup2_num,
		subgroup2_bankBaseAddr=subgroup2_bankBaseAddr
	)


	subgroup2_rqstFlag_vec = np.flip(np.array([0, 0, 0, 0, 0]))
	configurator.incomingMsg_load(incomingMsg_vec=C2V_vec, subgroup2_rqstFlag_vec=subgroup2_rqstFlag_vec)

	isFeasible = configurator.temp()

if __name__ == "__main__":
	main()