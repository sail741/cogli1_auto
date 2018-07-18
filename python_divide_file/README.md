# divide_file

### Credit 
* By Léo Mullot
* For the LiMMS
* In 2018

### Description
This script work with .dat for cogli1.
Note that .dat file contains bloc, starting with the char "t"
This script create a copy of the .dat file, skipping some blocs.
It keep them regulary, like 1/2, 1/3, 1/4, ... (1/n)

The script take 2 parameter :
1) the file .dat
2) the amount of blocs we keep.

then the result is written in a file with the same name that the input + ".min"

## Running application

To run the application, just run : 
```
python3 divide_file.py <filedat> <integer>
```


## Parameters details

* the file .dat where you want to skip data
* the amount of blocs we keep like 1/2, 1/3, 1/4, ... (1/n) : <2> to keep 1 blocs on 2. <10> to keep 1 bloc on 10.
