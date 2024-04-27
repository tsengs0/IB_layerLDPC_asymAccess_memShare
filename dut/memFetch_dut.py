import numpy as np
import math
import sys
import csv_manipulation

RP=255 # Row parallelism

def csvFile_write(fd, vec_size, vecIn):
	for i in range(vec_size):
		if(i == vec_size-1):
			fd.write(vecIn[i]+'\n')
		else:
			fd.write(vecIn[i]+',')

def memFetch_convert(filename):
	fd = open(filename, 'r')
	wrFd = open(filename+'.csv', 'w')
 
	while True:
		line=fd.readline()
 
		if not line:
			break

		if(RP != len(line)-1): # because one additional  "space" charactor are padded at the end of every line by systemVerilog
			sys.exit()
		else:
			c2v_line=np.zeros(RP, dtype=np.str)
			for i in range(RP):
				c2v_line[i]=line[i]
			
			c2v_line=np.flipud(c2v_line)

			csvFile_write(wrFd, RP, c2v_line)
 
	fd.close()
	wrFd.close()

def main():
	if(len(sys.argv) != 2):
		print("Please give the filename of memFetch log file")
		sys.exit()

	memFetch_vec = csv_manipulation.csv_load(sys.argv[1])
	print(memFetch_vec)

if __name__ == "__main__":
	main()
