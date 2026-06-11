@echo off
mode con: cols=40 lines=4
title Kingcode AutoRun Installer

echo Installing Kingcode background monitor...
set "TARGET_DIR=%LOCALAPPDATA%\Kingcode"

:: Create local directory
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

:: Copy monitor script
copy /y "%~dp0kingcode_monitor.ps1" "%TARGET_DIR%\kingcode_monitor.ps1" >nul

:: Create VBS launcher to run PowerShell silently (no console flash)
echo Set objShell = CreateObject("WScript.Shell") > "%TARGET_DIR%\run_monitor.vbs"
echo strCommand = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File """ ^& objShell.ExpandEnvironmentStrings("%%LOCALAPPDATA%%") ^& "\Kingcode\kingcode_monitor.ps1""" >> "%TARGET_DIR%\run_monitor.vbs"
echo objShell.Run strCommand, 0, False >> "%TARGET_DIR%\run_monitor.vbs"

:: Create shortcut in Windows Startup folder
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT_PATH=%STARTUP_DIR%\KingcodeMonitor.lnk"

:: Use PowerShell to create the shortcut file
powershell -Command "$wsh = New-Object -ComObject WScript.Shell; $sc = $wsh.CreateShortcut('%SHORTCUT_PATH%'); $sc.TargetPath = '%TARGET_DIR%\run_monitor.vbs'; $sc.Save()"

:: Run the monitor immediately in the background
wscript.exe "%TARGET_DIR%\run_monitor.vbs"

exit
