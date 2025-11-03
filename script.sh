#!/usr/bin/env bash
set -e  # zatrzymaj wykonanie, jeśli coś się nie powiedzie

output="main"
filename="main"
outdir="out"

mkdir -p "$outdir"

echo "[1/4] Kompilacja LaTeX..."
pdflatex -interaction=nonstopmode -output-directory="$outdir" -jobname="$output" "$filename"

echo "[2/4] Uruchamianie BibTeX..."
bibtex "$outdir/$output"

echo "[3/4] Druga kompilacja LaTeX..."
pdflatex -interaction=nonstopmode -output-directory="$outdir" -jobname="$output" "$filename"

echo "[4/4] Ostatnia kompilacja LaTeX..."
pdflatex -interaction=nonstopmode -output-directory="$outdir" -jobname="$output" "$filename"

echo "Kompilacja zakończona. Wynik: $outdir/$output.pdf"


# docker run --rm -v ${PWD}:/workdir:z --entrypoint=sh --user $(id -u):$(id -g) ghcr.io/xu-cheng/texlive-alpine:20251002@sha256:556e2e2caa7d489ce155de0eb3f43e324e6502ed4e9871aa400662b156cf00ad -c "cd workdir && mkdir -p out && pdflatex -output-directory=out main"