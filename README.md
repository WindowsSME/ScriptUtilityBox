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

### [`Extract-GSheetsIDs.ps1`](./helpers/Extract-GSheetsIDs.ps1)
Extracts Google Sheet IDs from a list of links and formats them into a ready-to-use JavaScript function.

### [`experimental/Cleanup-ZoomCache.ps1`](./experimental/Cleanup-ZoomCache.ps1)
WIP script to clean residual Zoom user cache files.

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
