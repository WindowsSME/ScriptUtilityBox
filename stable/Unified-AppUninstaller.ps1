# Provides a unified way to uninstall apps using registry paths and Win32_Product querie

function Get-ExePath {

    # Unified Uninstaller Script
    # Author: James Romeo Gaspar
    # Date: 18 February 2025

    param (
        [string]$AppName
    )

    $commonPaths = @(
        "$env:SystemRoot\System32\",
        "$env:SystemRoot\SysWOW64\"
    )

    foreach ($path in $commonPaths) {
        $exeFiles = Get-ChildItem -Path $path -Filter "*.exe" | Where-Object { $_.Name -like "*$AppName*" }
        if ($exeFiles.Count -gt 0) {
            $exePath = $exeFiles[0].FullName
            return $exePath
        }
    }

    Write-Host "Uninstaller EXE for $AppName could not be found in target directories." -ForegroundColor Red
    return $null
}

function Uninstall-MSIApplication {
    param (
        [string]$AppName,
        [switch]$Simulate
    )

    try {
        $app64 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$AppName*" }
        $app32 = Get-ItemProperty HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$AppName*" }

        if ($app64 -or $app32) {
            Write-Host "$AppName is installed. Preparing for uninstallation..." -ForegroundColor Yellow

            if ($Simulate) {
                if ($app64) { Write-Host "[SIMULATION] Would uninstall $AppName (64-bit) with product code: $($app64.PSChildName)" -ForegroundColor Cyan }
                if ($app32) { Write-Host "[SIMULATION] Would uninstall $AppName (32-bit) with product code: $($app32.PSChildName)" -ForegroundColor Cyan }
                Write-Host "[SIMULATION] No actual changes were made." -ForegroundColor Magenta
                return
            }

            if ($app64) {
                Write-Host "Uninstalling $AppName (64-bit)..."
                Start-Process -FilePath "msiexec.exe" -ArgumentList "/x $($app64.PSChildName) /quiet /norestart" -NoNewWindow -Wait
            }

            if ($app32) {
                Write-Host "Uninstalling $AppName (32-bit)..."
                Start-Process -FilePath "msiexec.exe" -ArgumentList "/x $($app32.PSChildName) /quiet /norestart" -NoNewWindow -Wait
            }

            Write-Host "$AppName has been uninstalled." -ForegroundColor Green
        } else {
            Write-Host "$AppName is not installed." -ForegroundColor Cyan
        }
    } catch {
        Write-Host "An error occurred while attempting to uninstall ${AppName}: $_" -ForegroundColor Red
        "$($AppName): $_" | Out-File -FilePath "Uninstall-Errors.log" -Append
    }
}

function Uninstall-EXEApplication {
    param (
        [string]$AppName,
        [switch]$Simulate
    )

    try {
        $exePath = Get-ExePath -AppName $AppName

        if ($exePath) {
            Write-Host "$AppName is installed. Preparing for uninstallation..." -ForegroundColor Yellow

            if ($Simulate) {
                Write-Host "[SIMULATION] Would uninstall $AppName using: `"$exePath /uninstall /quiet /norestart`"" -ForegroundColor Cyan
                Write-Host "[SIMULATION] No actual changes were made." -ForegroundColor Magenta
                return
            }

            Write-Host "Uninstalling $AppName..."
            Start-Process -FilePath $exePath -ArgumentList "/uninstall /quiet /norestart" -NoNewWindow -Wait

            Write-Host "$AppName has been uninstalled." -ForegroundColor Green
        } else {
            Write-Host "$AppName is not installed or the EXE path could not be found." -ForegroundColor Cyan
        }
    } catch {
        Write-Host "An error occurred while attempting to uninstall ${AppName}: $_" -ForegroundColor Red
        "$($AppName): $_" | Out-File -FilePath "Uninstall-Errors.log" -Append
    }
}

function Uninstall-Applications {
    param (
        [string[]]$Applications,
        [switch]$Simulate
    )

    function Get-InstalledApplicationType {
        param (
            [string]$AppName
        )

        $app64MSI = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$AppName*" }
        $app32MSI = Get-ItemProperty HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$AppName*" }

        if ($app64MSI -or $app32MSI) {
            return "MSI"
        }

        $app64EXE = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$AppName*" -and $_.UninstallString -like "*.exe*" }
        $app32EXE = Get-ItemProperty HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$AppName*" -and $_.UninstallString -like "*.exe*" }

        if ($app64EXE -or $app32EXE) {
            return "EXE"
        }

        $exePath = Get-ExePath -AppName $AppName
        if ($exePath) {
            return "EXE"
        }

        return "Unknown"
    }

    foreach ($app in $Applications) {
        $appType = Get-InstalledApplicationType -AppName $app

        switch ($appType) {
            "MSI" {
                Uninstall-MSIApplication -AppName $app -Simulate:$Simulate
            }
            "EXE" {
                Uninstall-EXEApplication -AppName $app -Simulate:$Simulate
            }
            default {
                Write-Host "$app is not installed." -ForegroundColor Red
            }
        }
    }
}

### List of applications to uninstall ###
$Applications = @(
    "Zoom",
    "VLC media player",
    "Teams Meeting Add-in for Microsoft Office",
    "Amazon WorkSpaces",
    "Microsoft Excel LTSC",
    "OneDrive"
)

# Run in simulation mode by default
Uninstall-Applications -Applications $Applications -Simulate

# Actual Uninstallation Row
# Uninstall-Applications -Applications $Applications
