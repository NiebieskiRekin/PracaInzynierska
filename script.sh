#!/usr/bin/env bash
output="dist"
filename="main"
mkdir -p out
pdflatex -output-directory=out -jobname $output $filename