"""
	This file work with .dat for cogli1.
	Note that .dat file contains bloc, starting with the char "t"
	This script create a copy of the .dat file, skipping some blocs.
	It keep them regulary, like 1/2, 1/3, 1/4, ... (1/n)

	The script take 2 parameter :
	1) the file .dat
	2) the amount of blocs we keep.

	then the result is written in a file with the same name that the input + ".min"

	@author : Leo Mullot
	@date : 2018
"""

import sys
import os.path


# We check the 1st parameter
if len(sys.argv) < 2:
	print("You need to give the file in parameter.")
	exit(1)

# We check the file exist
if not os.path.isfile(sys.argv[1]):
	print("The given file is unfoundable.")
	exit(1)
filepath = sys.argv[1]
output = sys.argv[1] + ".min"

# We check that the output file dosnt already exist
if os.path.isfile(output):
	print("The output file already exist. Please delete the " + output + " file")
	exit(1)

# We check the 2nd parameter
if len(sys.argv) < 3:
	print("You need to give the amout of portion we keep.")
	exit(1)
read_every = int(sys.argv[2])
cpt = read_every

# init var
do_write = False

# We open the ouput file to write
with open(output, 'a') as f_out:

	# We open the input file to read it
	with open(filepath, 'r') as f_in:  
		line = f_in.readline()
		# While there is content in the file
		while line:
			# if the line start with a 't'
			if line.strip().startswith('t'):
				if read_every == cpt:
					# if we reach cpt, then we keep this bloc
					do_write = True
					cpt = 0
				else:
					# else, we dont keep this bloc
					do_write = False
				cpt += 1

			# if we keep the bloc, we write the current line
			if do_write:
				f_out.write(line)

			# And we go to the next line
			line = fp.readline()