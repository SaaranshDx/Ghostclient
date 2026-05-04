# GhostDrop Client

A client for quick and secure file sharing with GhostDrop.

## Demo
![vid](assets/20260504-1109-30.1792959.mp4)

## Features

- **Password Protection** - Optional password for uploaded files
- **Auto-Copy Links** - Share links automatically copied to clipboard

## Installation

### Quick Install (One-liner)

Copy and paste this command into PowerShell (as Administrator) and press Enter:

```powershell
iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SaaranshDx/Ghostclient/main/installer.ps1')
```

Or use this alternative if the above doesn't work:

```powershell
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SaaranshDx/Ghostclient/main/installer.ps1' -UseBasicParsing | Invoke-Expression
```

## Usage

1. **Launch the Client**
   - Right-click any file and select "Upload with GhostDrop" 

2. **Enter Password (Optional)**
   - Leave blank for no password protection
   - Or enter a password to secure your upload

3. **Upload**
   - Click "Upload" button
   - Wait for success notification
   - Link is automatically copied to your clipboard

4. **Share**
   - Paste the link anywhere
   - Recipients can download your file
   - If password-protected, they'll need to enter the password

## System Integration

After installation, GhostDrop Client integrates with your Windows context menu:
- Right-click any file → "Upload with GhostDrop"
- Files are uploaded securely to GhostDrop servers
- Instant link generation and clipboard copy

## Privacy & Security

- Files are uploaded directly to GhostDrop servers
- Optional password protection available
- Links expire based on server policy
- No file tracking or user profiling

### Script Execution Policy Error Fix
If you get an execution policy error, run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Support

For issues, feature requests, or questions, please visit:
- GitHub Issues: https://github.com/SaaranshDx/GhostClient/issues
- Main Project: https://github.com/SaaranshDx/GhostDrop



Made with ❤️ by SaaranshDx
