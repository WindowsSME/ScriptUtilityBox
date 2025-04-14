$InputFile = "C:\Temp\ADUsernames.txt"
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$OutputFile = "C:\Temp\OutputADUsers_V2_$Timestamp.csv"


$Usernames = Get-Content -Path $InputFile

$Results = @()

foreach ($Username in $Usernames) {
    try {
        $User = Get-ADUser -Identity $Username -Properties Department -ErrorAction Stop
        
        $Results += [PSCustomObject]@{
            SamAccountName = $User.SamAccountName
            Name           = $User.Name
            Department     = $User.Department
        }
    } catch {
        $Results += [PSCustomObject]@{
            SamAccountName = $Username
            Name           = "Not Found"
            Department     = "Not Found"
        }
    }
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Output "Export completed. Results saved to $OutputFile."
