#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=1
#SBATCH --partition=picluster

# Calls the ffmpeg shell command to assemble a scene
cat Images/numbered_frames/{0480..0719}*.jpg | /usr/bin/ffmpeg -f image2pipe -framerate 24 -i - -c:v libx264 Images/scenes/2.mp4 2>/dev/null
