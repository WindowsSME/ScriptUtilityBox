# ScriptUtilityBox

> A flexible, mixed-purpose collection of useful and experimental scripts.  
> Tested tools, half-built ideas, and general utilities live here.

This repository serves as a "catch-all" for scripts that don’t fit into other specialized toolkits. It includes everything from fully working scripts to rough concepts — in PowerShell, Bash, and more.
Whether it’s a one-off utility, a work-in-progress idea, or a handy tool you use occasionally, it belongs here.

---

## Folder Structure

| Folder | Purpose |
|--------|---------|
| [`/stable`](./stable) | Fully working scripts that are reliable but don’t fit into other repos |
| [`/experimental`](./experimental) | Theoretical, under-construction, or in-development scripts |
| [`/helpers`](./helpers) | Mini-scripts, snippets, or personal tools |
| [`/archived`](./archived) | Old or replaced scripts kept for reference |

---

## Included Scripts

### stable

- [Check-DiskUsage.ps1](./stable/Check-DiskUsage.ps1)  
  Checks free space across system drives and reports disk usage.

- [Check-PendingReboot.ps1](./stable/Check-PendingReboot.ps1)  
  Detects whether a system reboot is pending due to updates or configuration changes.

- [Check-UserFolders.ps1](./stable/Check-UserFolders.ps1)  
  Scans and summarizes user profile folders (like Documents, Downloads, etc.) for size and contents.

- [Restart-GlobalProtect.ps1](./stable/Restart-GlobalProtect.ps1)  
  Restarts the Palo Alto GlobalProtect VPN client to resolve connectivity issues.

- [Unified-AppUnistaller.ps1](./stable/Unified-AppUnistaller.ps1)  
  Provides a unified way to uninstall apps using registry paths and Win32_Product queries.

### experimental

- [AWS-DetectionScript.ps1](./experimental/AWS-DetectionScript.ps1)  
  Detects if AWS VPN is installed else will deploy via Microsoft Intune

### helpers

- [Archive-DocuFolders.ps1](./helpers/Archive-DocuFolders.ps1)  
  Archives folders typically used for documentation by compressing and timestamping them.

- [Get-ADUserDept.ps1](./helpers/Get-ADUserDept.ps1)  
  Queries Active Directory to retrieve a user's department attribute.
  
---

## Usage
All scripts are provided **as-is** and may not work as expected.
Use in a test lab, VM, or safe environment before trying anywhere important.

```powershell
.\ScriptName.ps1
```

---

## Notes
- All scripts are provided as-is.
- Tested scripts may still require environment-specific tweaking.
- Use in test environments before applying to production systems.

---

## License
MIT — feel free to fork or build on any ideas here, but use at your own risk.
