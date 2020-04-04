#!/bin/bash

# Resize all the images of the Images/hires input folder to a predefined size. 
# The images are saved in the Images/lores output folder.
# This command loop on all the input image files and send a slurm job to the
# first available node to execute the resize job.

jobGroups

function loopFiles() {
    ## Do nothing if * doesn't match anything.
    ## This is needed for empty directories, otherwise
    ## "foo/*" expands to the literal string "foo/*"/
    shopt -s nullglob
    
	# Remove and recreate the destination folder if exists
	# Uncomment to empty the destination folder before creating the job
    # rm -R Images/lores/
    # mkdir Images/lores

    # Create the batch job command header -----------------------------------------
    echo "#!/bin/bash" > imageResizeJob.sh
	echo "#SBATCH --nodes=1" >> imageResizeJob.sh
	echo "#SBATCH --ntasks-per-node=1" >> imageResizeJob.sh
	echo "#SBATCH --partition=picluster" >> imageResizeJob.sh
	echo >> imageResizeJob.sh
	echo "# Calls the imagemagick shell command to resize the image passed as a parameter." >> imageResizeJob.sh
    
    # Loop on all the files of the input folder
	for file in "$@"/*
		do
			## If $file is a file
			if [ -f "$file" ]
				then
					# Update the job script
					echo "./magickResize.sh ${file##*/}" >> imageResizeJob.sh
				fi
		done
}

# Launch a slurm job every file in the input folder
echo "------------------------------------"
echo " Resize the files in the folder:"
echo " $1"
echo "------------------------------------"

loopFiles $1

# make the batch job executable
chmod +x ./imageResizeJob.sh

# Submit the job
sbatch ./imageResizeJob.sh
