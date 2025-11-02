# Requires PowerShell 5 or later

$output = "main"
$filename = "main"
$outDir = "out"

if (!(Test-Path -Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

Write-Host "[1/4] Kompilacja LaTeX..."
pdflatex -interaction=nonstopmode -output-directory=$outDir -jobname=$output $filename | Out-Null

Write-Host "[2/4] Uruchamianie BibTeX..."
bibtex "$outDir\$output" | Out-Null

Write-Host "[3/4] Druga kompilacja LaTeX..."
pdflatex -interaction=nonstopmode -output-directory=$outDir -jobname=$output $filename | Out-Null

Write-Host "[4/4] Ostatnia kompilacja LaTeX..."
pdflatex -interaction=nonstopmode -output-directory=$outDir -jobname=$output $filename | Out-Null

Write-Host "Kompilacja zakończona. Wynik: $outDir\$output.pdf"
