# Detects whether a system reboot is pending due to updates or configuration changes.

function Check-PendingReboot {

    # Reboot upon confirmation of PendingReboot key in Registy
    # Author: James Romeo Gaspar
    # 31 January 2025
    # Version 1.1 : 6 February 2025 - Added comments to the script to improve readability and make the logic flow easier to understand.
    # Version 2.1 : 10 February 2025 - Revised script to just only write to event logs and removed using rebootlogs.txt
    # Version 2.2 : 11 February 2025 - Added line to ensure that event log source exists before writing to it.
    # Version 2.3 : 12 February 2025 - Changed method in checking if event log source exists. Changed method in displaying notification.

    # Initialize the variable to track if a reboot is required
    $PendingReboot = $false

    # Define registry keys that indicate a pending reboot
    $RebootKeys = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired",
        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations"
    )

    # Check if any of the defined registry keys exist
    foreach ($Key in $RebootKeys) {
        if (Test-Path $Key) {
            $PendingReboot = $true
            break  # Exit loop early if a pending reboot key is found in the registry
        }
    }

    # Ensure event log source exists
    if (-not [System.Diagnostics.EventLog]::SourceExists("RebootScript")) {
        New-EventLog -LogName System -Source "RebootScript"
    }

    # Get today's date in DateTime format
    $Today = (Get-Date).Date

    # Count the number of reboots logged today
    $RebootCount = (Get-WinEvent -FilterHashtable @{
        LogName = "System"
        Id = 1001
        StartTime = $Today
        ProviderName = "RebootScript"
    } -ErrorAction SilentlyContinue).Count

    if ($PendingReboot) {
        $Title = "System Reboot Required"
        $Message = "The system has detected a pending reboot."

        if ($RebootCount -lt 2) {
            # Notify user and log reboot attempt if less than 2 reboots detected today
            $Message += " The system will restart immediately."
            msg * /time:10 $Message  # Message stays for 10 seconds
            
            # Log the reboot event
            Write-EventLog -LogName System -Source "RebootScript" -EventId 1001 -EntryType Information -Message "System reboot initiated due to pending reboot flag."

            # Force a system restart
            Restart-Computer -Force -Confirm:$false
        } else {
            # If more than 2 reboots detected today, send a reminder to the user
            $Message += " Please manually restart your computer to complete pending Windows Updates."
            msg * /time:60 $Message  # Message stays for 60 seconds
        }
    } else {
        # Log that no pending reboot is detected
        Write-EventLog -LogName System -Source "RebootScript" -EventId 1002 -EntryType Information -Message "No pending reboot detected."
    }
}

# Call the function to check for pending reboots
Check-PendingReboot
