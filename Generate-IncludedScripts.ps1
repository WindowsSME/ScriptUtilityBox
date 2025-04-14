# Generate-IncludedScripts.ps1

$folders = @("stable", "helpers", "experimental")
$readmePath = "README.md"

# Build new section
$newSection = @()
$newSection += "## Included Scripts`n"

foreach ($folder in $folders) {
    $files = Get-ChildItem -Path $folder -Filter *.ps1 -File -ErrorAction SilentlyContinue

    if ($files.Count -gt 0) {
        $newSection += "`n### $folder`n"
        foreach ($file in $files) {
            $relativePath = "./$folder/$($file.Name)"
            $newSection += "- [$($file.Name)]($relativePath)  `n  Add description here.`n"
        }
    }
}

# Read existing README.md
if (!(Test-Path $readmePath)) {
    Write-Host "README.md not found. Exiting."
    exit 1
}

$readme = Get-Content $readmePath -Raw
$pattern = '(?s)(## Included Scripts.*?)(?=\n##|\Z)'

if ($readme -match $pattern) {
    $newReadme = $readme -replace $pattern, ($newSection -join "`n")
    Set-Content -Path $readmePath -Value $newReadme
    Write-Host "README.md updated successfully."
} else {
    Write-Host "No Included Scripts section found in README.md."
}
