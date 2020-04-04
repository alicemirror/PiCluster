#!/bin/bash

# Resize all the images of the Images/hires input folder to a predefined size. 
# The images are saved in the Images/lores output folder.
# This command loop on all the input image files and send a slurm job to the
# first available node to execute the resize job.

function loopFiles() {
    ## Do nothing if * doesn't match anything.
    ## This is needed for empty directories, otherwise
    ## "foo/*" expands to the literal string "foo/*"/
    shopt -s nullglob

    echo 'Start: ' |date '+%a %b %d %H:%M:%s.%N %Z %Y'
    
    # Loop on all the files of the input folder
	for file in "$@"/*
		do
			## If $file is a file
			if [ -f "$file" ]
				then
					# Update the job script
					srun ./magickResize.sh ${file##*/}
				fi
		done
		
		echo 'End: ' |date '+%a %b %d %H:%M:%s.%N %Z %Y'
}

# Run a slurm job every file in the input folder

file_count=$( shopt -s nullglob ; set -- $directory_to_search_inside/* ; echo $#)

echo "------------------------------------"
echo " Resize the files in the folder:"
echo " $1"
echo " $file_count files"
echo "------------------------------------"

loopFiles $1
