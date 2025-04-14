# Detects if AWS VPN is installed and if not reinstall using Microsoft Intune.

$LogFile = "C:\Intune\AWS VPN Client-DetectionLog.log"
$ProductName = "AWS VPN Client" 
$ProductVersion = "5.0.1"
$ApplicationExePaths = "C:\Program Files\Amazon\AWS VPN Client\AWSVPNClient.exe"

if (!(Test-Path "C:\Intune")) {
    New-Item -ItemType Directory -Path "C:\Intune" -Force | Out-Null
}

$RegPaths = @( 
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

$InstalledApp = foreach ($RegPath in $RegPaths) {
    Get-ChildItem -Path $RegPath | Get-ItemProperty | Where-Object { $_.DisplayName -like "$ProductName*" } | Select-Object DisplayName, DisplayVersion, UninstallString
}

$ExecutableFound = Test-Path $ApplicationExePaths
$InstalledVersion = if ($InstalledApp) { $InstalledApp.DisplayVersion } else { $null }

$VersionCheck = $false
if ($InstalledVersion) {
    try {
        $InstalledVersionObj = [System.Version]$InstalledVersion
        $RequiredVersionObj = [System.Version]$ProductVersion
        if ($InstalledVersionObj -ge $RequiredVersionObj -and $ExecutableFound) {
            $VersionCheck = $true
        }
    } catch {
        Write-Host "Version comparison failed. Installed version: $InstalledVersion"
    }
}

if ($VersionCheck) {
    Write-Host "Installed - Version: $InstalledVersion"
    exit 0 
} else {
    $LogMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Detection failed: $ProductName not installed or outdated."
    Add-Content -Path $LogFile -Value $LogMessage
}


$LogMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Attempting to uninstall $ProductName..."
Add-Content -Path $LogFile -Value $LogMessage

$UninstallString = if ($InstalledApp) { $InstalledApp.UninstallString } else { $null }

if ($UninstallString) {
    $UninstallString = $UninstallString -replace "MsiExec.exe /I", "MsiExec.exe /X"
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $UninstallString /quiet /norestart" -NoNewWindow -Wait

    $LogMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Uninstallation completed. Restarting Intune service to trigger reinstallation."
    Add-Content -Path $LogFile -Value $LogMessage
    Restart-Service -Name "IntuneManagementExtension" -Force
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft Intune Management Extension\IntuneManagementExtension.exe" -ArgumentList "-c" -NoNewWindow -Wait
} else {
    $LogMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Failed to find uninstall string. Skipping uninstallation."
    Add-Content -Path $LogFile -Value $LogMessage
}

exit 1
