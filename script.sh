#!/usr/bin/env bash
output="dist"
filename="main"
mkdir -p out
pdflatex -output-directory=out -jobname $output $filename

# docker run --rm -v ${PWD}:/workdir:z --entrypoint=sh --user $(id -u):$(id -g) ghcr.io/xu-cheng/texlive-alpine:20251002@sha256:556e2e2caa7d489ce155de0eb3f43e324e6502ed4e9871aa400662b156cf00ad -c "cd workdir && mkdir -p out && pdflatex -output-directory=out main"