#!/bin/bash

# Resize all the images of the Images/hires input folder to a predefined size. 
# The images are saved in the Images/lores output folder.
# This command loop on all the input image files and send a slurm job to the
# first available node to execute the resize job.

# Number of files to process per batch job
max_files=25
# Current file batch group
current_batch=1
# Current batch name
batch_name=''

function batchHeader() {
    # Create the batch job command header
    echo "#!/bin/bash" > $batch_name
	echo "#SBATCH --nodes=3" >> $batch_name
	echo "#SBATCH --ntasks-per-node=1" >> $batch_name
	echo "#SBATCH --partition=picluster" >> $batch_name
	echo >> $batch_name
	echo "# Calls the imagemagick shell command to resize the image passed as a parameter." >> $batch_name

	# Set the file executable
	chmod +x $batch_name
	
	echo 'Created batch file ' $batch_name
}

function loopFiles() {
    ## Do nothing if * doesn't match anything.
    ## This is needed for empty directories, otherwise
    ## "foo/*" expands to the literal string "foo/*"/
    shopt -s nullglob

    # file_count=$( shopt -s nullglob ; set -- $directory_to_search_inside/* ; echo $#)
    # echo $file_count 'files'
    
	# file group counter
	local file_group_counter=0
	# Create the first batch file header
	batch_name='b'$current_batch'.sh'
	# Create the batch header
	batchHeader
	
    # Loop on all the files of the input folder
	for file in "$@"/*
		do
			## If $file is a file
			if [ -f "$file" ]
				then
					# Update the job script
					echo "./magickResize.sh ${file##*/}" >> $batch_name
					# Increment the number of files in the current batch
					((file_group_counter++))
					# Check if this was the last file in the batch group
					if ! ((file_group_counter < max_files)) 
						then
							# Submit the batch to slurm
							sbatch ./$batch_name
							# Create the new batch file header
							((current_batch++))
							batch_name='b'$current_batch'.sh'
							batchHeader
							# Reset the group counter
							((file_group_counter=0))
					fi
				fi
		done
		# Submit the last batch to slurm
		sbatch ./$batch_name
}

# Submit a slurm job every group of files in the input folder

echo "------------------------------------"
echo " Resize the files in the folder:"
echo " $1"
echo "------------------------------------"

echo 'slurm submission started'
date '+%a %b %d %H:%M:%s.%N %Z %Y'

loopFiles $1

echo 'slurm submission ended'
date '+%a %b %d %H:%M:%s.%N %Z %Y'

