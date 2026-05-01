#!/bin/sh

$1 | convert -background black -fill white \
-font Helvetica -pointsize 14 \
-border 10 -bordercolor black \
label:@- $2
