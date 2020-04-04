#!/bin/bash

# Image resizing script using the imagemagick function convert.
#
# Input parameter : source image name
#
# All the other parameters are hardcoded

source=Images/4k_Frames/$1
dest=Images/FullHD_Frames/FullHD-$1

convert $source -resize 1920x1920 $dest
