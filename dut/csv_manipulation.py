import numpy as np
import csv
import pandas as pd

def csv_load(filename):
	fd = open(filename, "r")
	load_vec = np.loadtxt(filename, delimiter=",", dtype=str)
	#load_vec = pd.read_csv(filename, sep=',', dtype=str)

	return load_vec

def csv_save(filename, list_in):
	fd = open(filename, 'w')
	writer = csv.writer(fd)
	writer.writerow(list_in)
	fd.close()

def csv_append(filename, list_in):
	fd = open(filename, 'a')
	writer = csv.writer(fd)
	writer.writerow(list_in)
	fd.close()

