#!/bin/bash

# Assemble timelapse scenes to mp4 scenes. Every scene is based on 
# 240 frames, 24fps (10 seconds)

# Number of files to process per batch job
max_files=240
# Current batch name
batch_name=''
# Renamed files folder linked to the originals
numberedFolder=Images/numbered_frames/
# Output scenes folder
scenes=Images/scenes/

function batchHeader() {
    # Create the batch job command header
    echo "#!/bin/bash" > $batch_name
	echo "#SBATCH --nodes=3" >> $batch_name
	echo "#SBATCH --ntasks-per-node=1" >> $batch_name
	echo "#SBATCH --partition=picluster" >> $batch_name
	echo >> $batch_name
	echo "# Calls the ffmpeg shell command to assemble a scene" >> $batch_name

	# Set the file executable
	chmod +x $batch_name
	
	echo 'Created batch file ' $batch_name
}

function loopFiles() {
    ## Do nothing if * doesn't match anything.
    ## This is needed for empty directories, otherwise
    ## "foo/*" expands to the literal string "foo/*"/
    shopt -s nullglob

    file_count=$( shopt -s nullglob ; set -- $numberedFolder*.jpg ; echo $#)
    echo 'Total number of files: ' $file_count

    # Loop on the file names sequence to create the scenes. 
    # Every scene should be max 240 frames, 10 seconds at 24fps.
    
	# Calculate the number of scenes
	file_group_counter=$(($file_count/$max_files))
	# Include extra frames for the last scene, if exist.
	((file_group_counter++))
	COUNTER=0
	
	echo "Creating $file_group_counter batch scenes"
	
	# Main loop over scenes.
	# Note that here we don't consider the remain of the divisionper
	# number of frames. We will consider it later.
	while [  $COUNTER -lt $file_group_counter ]
		do
			# Create the first batch file header
			batch_name='b'$COUNTER'.sh'
			# Create the batch header
			batchHeader
			# Add the command in the batch file to submit to slurm
			firstNumber=$(($max_files * $COUNTER))
			lastNumber=$(($firstNumber + $max_files - 1))
			firstFileNumber=$(printf %04d $firstNumber)
			lastFileNumber=$(printf %04d $lastNumber)
			
			echo "Scene $COUNTER from frame $firstFileNumber to $lastFileNumber"

			# Add the batch command
			echo "cat $numberedFolder{$firstFileNumber..$lastFileNumber}*.jpg | /usr/bin/ffmpeg -f image2pipe -framerate 24 -i - -c:v libx264 $scenes$COUNTER.mp4 2>/dev/null" >>$batch_name
			# And submit it to slurm
			sbatch ./$batch_name
			
			((COUNTER++)) 
         done	
}

# Submit a slurm job every group of files in the input folder

echo "------------------------------------"
echo " Resize the files in the folder:"
echo " $numberedFolder"
echo "------------------------------------"

echo 'slurm submission started'
date '+%a %b %d %H:%M:%s.%N %Z %Y'

loopFiles

echo 'slurm submission ended'
date '+%a %b %d %H:%M:%s.%N %Z %Y'

