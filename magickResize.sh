#!/bin/bash

# Image resizing script using the imagemagick function convert.
#
# Input parameter : source image name
#
# All the other parameters are hardcoded

source=Images/hires/$1
dest=Images/lores/web-$1

convert $source -resize 1024x1024 $dest
