# Generate-IncludedScripts.ps1

$folders = @("stable", "helpers", "experimental")
$outputPath = "README_SCRIPTS.md"
$scriptList = @()

$scriptList += "## Included Scripts`n"

foreach ($folder in $folders) {
    $files = Get-ChildItem -Path $folder -Filter *.ps1 -File -ErrorAction SilentlyContinue

    if ($files.Count -gt 0) {
        $scriptList += "`n### $folder`n"

        foreach ($file in $files) {
            $relativePath = "./$folder/$($file.Name)"
            $description = "Add description here."  # You can customize this line to parse comments/doc blocks

            $scriptList += "- [$($file.Name)]($relativePath)  `n  $description`n"
        }
    }
}

$scriptList -join "`n" | Set-Content $outputPath -Encoding UTF8

Write-Host "README_SCRIPTS.md generated. You can now copy this section into your main README.md"
