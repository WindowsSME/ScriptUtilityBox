# Archives folders typically used for documentation by compressing and timestamping them.

# Define the source and destination directories using the current user's username
$sourceDir = "C:\Users\$env:USERNAME\Documents"
$destDir = "C:\Users\$env:USERNAME\Documents\Archived"

# Ensure the destination directory exists
if (-not (Test-Path -Path $destDir)) {
    New-Item -Path $destDir -ItemType Directory
}

# Get a list of directories in the source directory
$directories = Get-ChildItem -Path $sourceDir -Directory

# Define a regex pattern to match date-based folder names
$pattern = "^\d{8}$"

# Get today's date in the format yyyyMMdd
$today = (Get-Date).ToString("yyyyMMdd")

# Loop through each directory
foreach ($dir in $directories) {
    # Check if the directory name matches the date pattern
    if ($dir.Name -match $pattern) {
        # Skip moving if the directory name is today's date
        if ($dir.Name -eq $today) {
            Write-Output "Skipping directory: $($dir.Name) (Current)"
            continue
        }
        
        # Define the full path of the destination
        $destPath = Join-Path -Path $destDir -ChildPath $dir.Name
        
        # Move the directory to the destination
        Move-Item -Path $dir.FullName -Destination $destPath -Force
        Write-Output "Moved directory: $($dir.Name)"
    }
}
