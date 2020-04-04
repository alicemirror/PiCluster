#!/bin/bash

# Convert a series of frames to mp4 scene

source=Images/FullHD_Frames/*.JPG
dest=Images/scenes/

echo "------------------------------------"
echo " Assemble the scene"
echo " $dest$1"
echo "------------------------------------"

date '+%a %b %d %H:%M:%s.%N %Z %Y'
echo 'Frame process started'

ffmpeg -r 24 -pattern_type glob -i "$source" -c:v libx264 $dest$1 2> /dev/null

date '+%a %b %d %H:%M:%s.%N %Z %Y'
echo 'Frame process ended'
