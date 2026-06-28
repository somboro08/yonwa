$fichiers = Get-ChildItem -File | Where-Object { $_.Name -ne $MyInvocation.MyCommand.Name } | Sort-Object Name

$i = 0

foreach ($fichier in $fichiers) {
    Rename-Item -LiteralPath $fichier.FullName -NewName ("hero{0}{1}" -f $i, $fichier.Extension)
    $i++
}

Write-Host "$i fichiers renommés avec succès."
Pause