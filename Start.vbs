Set objFSO = CreateObject("Scripting.FileSystemObject")
strPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
Set objShell = CreateObject("WScript.Shell")
objShell.Run """" & strPath & "\kingcode.exe"" """ & strPath & "\kingcode.ahk""", 0, False
