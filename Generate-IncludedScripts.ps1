# Generate-IncludedScripts.ps1

$folders = @("stable", "helpers", "experimental")
$readmePath = "README.md"

function Get-ScriptDescription {
    param (
        [string]$filePath
    )

    $lines = Get-Content -Path $filePath -TotalCount 10
    foreach ($line in $lines) {
        if ($line -match '^\s*#\s*Description\s*:\s*(.+)$') {
            return $matches[1].Trim()
        }
    }
    return "No description available."
}

# Build new section
$newSection = @()
$newSection += "## Included Scripts`n"

foreach ($folder in $folders) {
    $files = Get-ChildItem -Path $folder -Filter *.ps1 -File -ErrorAction SilentlyContinue

    if ($files.Count -gt 0) {
        $newSection += "`n### $folder`n"
        foreach ($file in $files) {
            $relativePath = "./$folder/$($file.Name)"
            $desc = Get-ScriptDescription -filePath $file.FullName
            $newSection += "- [$($file.Name)]($relativePath)  `n  $desc`n"
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
