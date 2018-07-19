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
import os

# We check the 1st parameter
if len(sys.argv) < 2:
    print("You need to give the file in parameter.")
    exit(1)

# We check the file exist
if not os.path.isfile(sys.argv[1]):
    print("The given file is unfoundable.")
    exit(1)
filepath_input = sys.argv[1]
filepath_output = sys.argv[1] + ".min"

# We check that the output file dosnt already exist
if os.path.isfile(filepath_output):
    print("The output file already exist. Please delete the " + filepath_output + " file")
    exit(1)

# We check the 2nd parameter
if len(sys.argv) < 3:
    print("You need to give the amout of portion we keep.")
    exit(1)
read_every = int(sys.argv[2])

# init var
do_write = True
size_input = os.stat(filepath_input).st_size
nb_row_bloc = 0

# we get the bloc size (number of row)
with open(filepath_input, 'r') as f_in:
    line = f_in.readline()
    if not line.strip().startswith('t'):
        print("Wrong file content. Must start with 't'")
        exit(1)

    line = f_in.readline()
    nb_row_bloc += 1
    while line:
        # if the line start with a 't'
        if line.strip().startswith('t'):
            break
        line = f_in.readline()
        nb_row_bloc += 1


# We open the ouput file to write
with open(filepath_output, 'a') as f_out:

    # We open the input file to read it
    with open(filepath_input, 'r') as f_in:

        print("STARTING")
        while True:
            # This is just to have a track and display the % we are
            first_row = f_in.readline()
            if not first_row:
                break
            print("Added the bloc of '" + first_row.strip() + "'")
            percent = os.stat(filepath_output).st_size / (size_input / read_every) * 100
            print("{:.2f}% ".format(percent))

            # The bloc we want
            for i in range(nb_row_bloc - 1):
                line = f_in.readline()
                f_out.write(line)

            # Blocs we skip
            for i in range(nb_row_bloc * (read_every - 1)):
                line = f_in.readline()

print("100%")
print("Done!")
