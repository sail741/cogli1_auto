#!/bin/bash


# initial parameters
HD="0"
FORCE_DELETE="0"
HAS_GIVEN_CPY="0"

# WE GET THE PARAMETERS ------------------------------------------------------------------
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -d|--dat)
    DAT="$(realpath $2)"
    shift # past argument
    shift # past value
    ;;
	-t|--top)
    TOP="$(realpath $2)"
    shift # past argument
    shift # past value
    ;;
	--cpy)
    CPY="$(realpath $2)"
	HAS_GIVEN_CPY="1"
    shift # past argument
    shift # past value
    ;;
    --hq|--hd)
    HD="1"
    shift # past argument
    shift # past value
    ;;
    -f|--force)
    FORCE_DELETE="1"
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


# WE CHECK THAT THE PARAMETERS ARE GOOD --------------------------------------------------
if [ ! -f "$DAT" ]; then
    echo "File dat : '$DAT' not found!"
    exit 1
fi

if [ ! -f "$TOP" ]; then
    echo "File top : '$TOP' not found!"
    exit 1
fi

if [ "$CPY" != "" ] && [ ! -f "$CPY" ]; then
    echo "File cpy : '$CPY' not found!"
    exit 1
fi

if [ "$HD" != "0" ] && [ "$HD" != "1" ]; then
	echo "hd boolean must be 0 or 1 !"
	exit 1
fi



# We do some preparation before the script --------------------------------------------------


# Check if there is already the tmp-pov folder. If yes, ask the user before delete in case he wanna save data
if [ -d "tmp-pov" ]; then
	if [ "$FORCE_DELETE" = "1" ]; then
		rm -r tmp-pov
	else
		echo "Please delete tmp folder before running the script."
		exit 1
	fi
fi

# We turn the HD boolean to resolution string
if [ "$HD" = "1" ]; then
	height="1200"
	width="1920"
else
	height="600"
	width="860"
fi


# RUN THE MAIN SCRIPT --------------------------------------------------

# If the user didn't give a cpy file, we prompt cogli1 until there is a nez .cpy file in the folder.
if [ "$CPY" = "" ]; then

	clear
	# We run cogli1, that display the windows to chose the position of the camera
	
	# We start by getting the last .cpy file of the folder to check if there is a difference later.
	if [ ! -z "$(ls -Art *cpy 2> /dev/null)" ]; then
		lastCpyFile="$(ls -Art *.cpy | tail -n 1)"
		lastEditBak="$(stat -c %y $lastCpyFile)"
	else
		lastEditBak=""
	fi

	# We use a for loop to allow 3 try to the user. If he dont give a .cpy file in 3 try we give up.
	for i in {1..3}; do
		echo "You will see a graphic display of the scene. Please press [U] when the display is ok for you, and then quit by pressing [ECHAP]."
		printf 'press [ENTER] to continue ...'
		read _
		# We run the graphic command cogli to choose the position of the camera
		cogli1 --always-centre -I -v -m -t "$TOP" "$DAT"

		# We check the latest .cpy file of the folder
		lastCpyFile="$(ls -Art *.cpy 2> /dev/null | tail -n 1)" 

		# if there is no cpy file, we ask him to choose one and restart the loop.
		if [ ! -f "$lastCpyFile" ]; then
			printf "\n\n\n"
			if [ "$i" = "3" ]; then
				echo "There is no cpy file. Exiting the application."
				exit 1
			fi
			echo "There is no cpy file. You need to press [U] when the display is ok for you."
		# If there is a cpy file, we check that the file is a new one (not an old legacy file)
		else
			lastEdit="$(stat -c %y $lastCpyFile)"
			if [ "$lastEdit" = "$lastEditBak" ]; then
				echo "You didn't pressed [U] to generate a .cpy file, but there is cpy file in the folder. If you want to give an existing .cpy file, add the parameter '--cpy filename.cpy'"
			else
				CPY="$(realpath $lastCpyFile)"
				break
			fi
		fi
	done
fi




# Create the tmp-pov file to hold aaaaaaaall the files
mkdir tmp-pov

# We make a virtual link of the dat file because cogli1 use this file for the pov output
ln -s "$DAT" "$DAT"-ln
mv "$DAT"-ln ./tmp-pov/"datfile"

# Generate the pov files
cogli1 -o -l $CPY -t "$TOP" ./tmp-pov/"datfile"

# Turn the pov into images
for d in $(ls -v1 ./tmp-pov/*.pov); do povray -D +A +H$height +W$width $d; done

ls -1v ./tmp-pov/*.png > ./tmp-pov/storyboard.txt

# turn the image file into video
mencoder mf://@tmp-pov/storyboard.txt -mf w="$width":h="$height":fps=30:type=png -ovc xvid -xvidencopts pass=1 -o output.avi


if [ "$HAS_GIVEN_CPY" = "0" ]; then
	mv $CPY ./tmp-pov/cpyfile.cpy
fi

# We remove the log of the mencoder to avoid polluate the user folder
if [ -f "divx2pass.log" ]; then
	rm divx2pass.log
fi


echo "Done!"
