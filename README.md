# cogli1_auto
Automatise the cogli1 video generation

### Credit 
* By Léo Mullot
* For the LiMMS
* In 2018

### Description
This application is a shell script that automatize the creation of video from oxdna output, with cogli1.
It use .dat and .top file and create an avi film.
This script use every screenshot of the dat. If you want less, see the folder python_divide_file

## Running application

### Normal run

To run the application, just run : 
```
./colgi1_auto.sh -d <datfile> -t <top file>
```

### Specific usage

To run the application with specific parameter, you can give few arguments to the app :
* --cpy <file> : the .cpy file if you want to skip the cogli graphic part
* --hq|--hd : if present, the output will be in hq
* -f|--force : if present, every files will be overwrite without alert


## Recap with full parameters

Needed parameter :
* -d|--dat <file> : the .dat file
* -t|--top <file> : the .top file

Facultatif parameter
* --cpy <file> : the .cpy file if you want to skip the cogli graphic part
* --hq|--hd : if present, the output will be in hq
* -f|--force : if present, every files will be overwrite without alert


Example for specifig usage :
```
./colgi1_auto.sh -d <datfile> -t <topfile> --cpy <cpyfile> --hq --force
```
