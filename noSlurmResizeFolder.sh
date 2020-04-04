#!/bin/bash

# Resize all the images of the Images/hires input folder to a predefined size. 
# The images are saved in the Images/lores output folder.
# This command loop on all the input image files and send a slurm job to the
# first available node to execute the resize job.

# DEPRECATED

function loopFiles() {
    ## Do nothing if * doesn't match anything.
    ## This is needed for empty directories, otherwise
    ## "foo/*" expands to the literal string "foo/*"/
    shopt -s nullglob
    
	# Remove the destination folder if exists
    rm -r Images/lores/*

    for file in "$@"/*
		do
			## If $file is a file
			if [ -f "$file" ]
				then
					# Show the bare file name without extension
					# echo "$file"
					# Launch the slurm job
					sbatch ./imageResizeJob.sh ${file##*/}
				fi
		done

}

# Launch a slurm job every file in the input folder
echo "------------------------------------"
echo " Resize the files in the folder:"
echo " $1"
echo "------------------------------------"

echo "Start: date '+%a %b %d %H:%M:%s.%N %Z %Y'"
loopFiles $1
echo "End: date '+%a %b %d %H:%M:%s.%N %Z %Y'"
