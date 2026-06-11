# Kingcode USB Insertion & Removal Monitor
# This script runs silently in the background of the host PC, auto-launches the script when inserted, and closes it when removed.

$ErrorActionPreference = "SilentlyContinue"

while ($true) {
    # Scan for logical drives of type 2 (Removable Storage)
    $removableDrives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
    
    $kingcodeUsbFound = $false
    
    foreach ($drive in $removableDrives) {
        $driveLetter = $drive.DeviceID
        $exePath = "$driveLetter\kingcode.exe"
        $ahkPath = "$driveLetter\kingcode.ahk"
        
        # If the USB contains our kingcode files
        if ((Test-Path $exePath) -and (Test-Path $ahkPath)) {
            $kingcodeUsbFound = $true
            
            # Check if kingcode.exe is already running
            $running = Get-Process -Name "kingcode"
            if (-not $running) {
                # Start the script invisibly from the USB drive
                Start-Process -FilePath $exePath -ArgumentList "`"$ahkPath`"" -WindowStyle Hidden
            }
        }
    }
    
    # If the USB was unplugged (not found in active drives)
    if (-not $kingcodeUsbFound) {
        # Check if kingcode is running, and if so, stop it
        $running = Get-Process -Name "kingcode"
        if ($running) {
            Stop-Process -Name "kingcode" -Force
        }
        
        # Self-clean: Delete startup shortcut
        $shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\KingcodeMonitor.lnk"
        if (Test-Path $shortcutPath) {
            Remove-Item -Path $shortcutPath -Force
        }
        
        # Self-clean: Delete local directory
        $targetDir = "$env:LOCALAPPDATA\Kingcode"
        if (Test-Path $targetDir) {
            # Spawn a detached silent cmd to delete the directory after this script exits
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c timeout /t 1 /nobreak >nul & rmdir /s /q `"$targetDir`"" -WindowStyle Hidden
        }
        
        # Exit monitor script
        Exit
    }
    
    # Check again in 3 seconds (very low CPU usage)
    Start-Sleep -Seconds 3
}
