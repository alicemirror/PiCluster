#!/bin/bash

# Prepare the numbered frames links folder

# Renamed files folder linked to the originals
numberedFolder=Images/numbered_frames/
    	
echo "------------------------------------"
echo " Prepare linked frames from folder:"
echo " $1"
echo "------------------------------------"

echo 'Creating numbered links from frames'
date '+%a %b %d %H:%M:%s.%N %Z %Y'

x=0
# Remove previous links if exists
rm $numberedFolder*.jpg

# Loop on the input files to create the links
for i in $1/*JPG
	do 
		counter=$(printf %04d $x)
		ln $i $numberedFolder$counter.jpg
		x=$(($x+1))
	done

echo 'Links to frames created.'
date '+%a %b %d %H:%M:%s.%N %Z %Y'
