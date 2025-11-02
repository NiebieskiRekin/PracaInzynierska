# Requires PowerShell 5 or later

$output = "main"
$filename = "main"
$outDir = "out"

if (!(Test-Path -Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

pdflatex -output-directory=$outDir -jobname=$output $filename
