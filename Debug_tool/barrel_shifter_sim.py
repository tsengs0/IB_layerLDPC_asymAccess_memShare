import numpy as np
import math
import sys

block_length = 7650
q = 4  # 4-bit quantisation
VN_DEGREE = 3+1
M = VN_DEGREE-2
cardinality = pow(2, q) # by exploiting the symmetry of CNU, 3-Gbit input is enough
Iter_max = 10

def barrel_shifter(bs_length, shift_factor, bsIn_vec):
	bsOut_vec = np.zeros(bs_length, dtype=np.uint8)
	for i in range(bs_length):
		shifted_index = (i+shift_factor) % bs_length
		bsOut_vec[shifted_index] = bsIn_vec[i]

	return bsOut_vec

def main():
	if(len(sys.argv) != 2):
		print("Please give the shift factor for controlling the barrel shifter")
		sys.exit()

	bs_length=255	
	shift_factor=int(sys.argv[1])
	bsIn_vec = np.zeros(bs_length, dtype=np.uint8)
	for i in range(bs_length):
		bsIn_vec[i] = i % 16
	
	bsOut_vec = barrel_shifter(bs_length=bs_length, shift_factor=shift_factor, bsIn_vec=bsIn_vec)
	print("---------------------------------------------------------------------------")
	print('Shift Factor: %d' % (shift_factor))
	np.set_printoptions(formatter={'int':hex})
	print(bsOut_vec)

if __name__ == "__main__":
	main()
