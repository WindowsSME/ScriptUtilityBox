# PowerShell Script to Extract Google Sheet IDs and Format as JavaScript Code
# Author: James Romeo Gaspar
# Date: March 27, 2025
# Description: This script extracts Google Sheet IDs from a text file, formats them into a JavaScript function, and outputs the formatted code to another text file.

$inputFile = "C:\\Temp\\GLinks.txt"
$outputFile = "C:\\Temp\\GlinksCleaned.txt"

# Ensure input and output files exist
if (!(Test-Path $inputFile)) {
    New-Item -ItemType File -Path $inputFile -Force | Out-Null
}
if (!(Test-Path $outputFile)) {
    New-Item -ItemType File -Path $outputFile -Force | Out-Null
}

# Open input file before processing and wait until it's closed
$notepadProcess = Start-Process notepad.exe $inputFile -PassThru
$notepadProcess.WaitForExit()

# Read extracted IDs from input file
$ids = @()
Get-Content $inputFile | ForEach-Object {
    if ($_ -match "/d/([\w-]+)/edit") {
        $ids += $matches[1]  # Capture ID between '/d/' and '/edit'
    }
}

# Ensure output file is empty before writing
Set-Content -Path $outputFile -Value ""

# Format the output
if ($ids.Count -ge 1) {
    $destinationFileId = $ids[0]  # First extracted ID is the destination file ID
    
    # Write formatted output to file
    Add-Content -Path $outputFile -Value "function copyMultipleSheetsToTabs() {"
    Add-Content -Path $outputFile -Value "  const destinationFileId = '$destinationFileId';"
    Add-Content -Path $outputFile -Value "  const destinationSpreadsheet = SpreadsheetApp.openById(destinationFileId);"
    Add-Content -Path $outputFile -Value ""
    Add-Content -Path $outputFile -Value "  const sources = ["
    
    # Add the next two extracted IDs with the new format
    if ($ids.Count -ge 3) {
        Add-Content -Path $outputFile -Value "    { fileId: '$($ids[1])', newSheetName: 'IB-Report-WS1' },"
        Add-Content -Path $outputFile -Value "    { fileId: '$($ids[2])', newSheetName: 'IB-AppNative-Report' },"
    }
    
    # Add constant values
    Add-Content -Path $outputFile -Value "    { fileId: '1ben_-1nqm0-CFODaoC9Xa0k9ikJ91K2HqQcEdEba1UQ', sheetName: 'Campaign', newSheetName: 'Campaign' },"
    Add-Content -Path $outputFile -Value "    { fileId: '1V8UYt1e9WK2sKHrePN8bXqBSGutr8Jo1AL6-0BdRe6I', sheetName: 'Codes', newSheetName: 'Codes' },"
    Add-Content -Path $outputFile -Value "    { fileId: '1sWXm5_9iZ4P3Q0YoMJkwOQHCxjtQg1SFs7jJUHHkQwM', sheetName: 'SVC', newSheetName: 'SVC' },"
    Add-Content -Path $outputFile -Value "    { fileId: '11sPJHE3_p7Yf9SPoC2Far0zUdPl9nxn9Lja5_L34iV4', sheetName: 'IB-1-Tenant', newSheetName: 'IB-1-Tenant' },"
    Add-Content -Path $outputFile -Value "    { fileId: '1OBGDtjif5on_FhnmtYBrNACACWeEWsj-_W22fPi64fM', sheetName: 'Wise', newSheetName: 'Wise' },"
    
    # Close array and function
    Add-Content -Path $outputFile -Value "  ];"
}

# Open output file after processing
Start-Process notepad.exe $outputFile
