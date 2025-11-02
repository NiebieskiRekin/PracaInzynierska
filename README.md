# Praca Inżynierska

Przetwarzanie języka naturalnego w celu sterowania aplikacją webową Moje Konie

## Autorzy pracy

- Jakub Buler 155987
- Adam Detmer 155976 
- Jakub Kamieniarz 155845
- Tomasz Pawłowski 155965

## Promotor pracy

dr inż. Jędrzej Potoniec 

## Kompilacja dokumentu

W zależności od systemu operacyjnego należy wybrać odpowiedni skrypt (sh lub ps1).

### Zalecane paczki TeX do kompilacji lokalnie (Ubuntu)

```bash
apt-get update && apt-get install -y \
  texlive-base \
  texlive-latex-base \
  texlive-latex-recommended \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-fonts-extra \
  texlive-lang-polish \
  texlive-pictures \
  latexmk
```

### Zalecane paczki TeX do kompilacji lokalnie (TeX Live)

```bash
tlmgr install memoir etoolbox iftex array dcolumn delarray tabularx textcase \
babel babel-polish graphicx fancyvrb url hyperref varioref inputenc fontenc \
polski epstopdf-pkg color lm cm-super latexmk
```

### Kompilacja za pomocą środowiska Docker

```bash
docker run --rm -v ${PWD}:/workdir:z --entrypoint=sh --user $(id -u):$(id -g) ghcr.io/xu-cheng/texlive-alpine:20251002 -c "cd workdir && mkdir -p out && pdflatex -output-directory=out main"
```
