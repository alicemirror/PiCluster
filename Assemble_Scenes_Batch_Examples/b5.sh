#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=1
#SBATCH --partition=picluster

# Calls the ffmpeg shell command to assemble a scene
cat Images/numbered_frames/{1200..1439}*.jpg | /usr/bin/ffmpeg -f image2pipe -framerate 24 -i - -c:v libx264 Images/scenes/5.mp4 2>/dev/null
