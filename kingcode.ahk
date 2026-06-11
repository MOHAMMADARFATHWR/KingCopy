#Requires AutoHotkey v2.0
#SingleInstance Force

; Initialize snippets from files or snippets.txt
global useSingleFile := false
global snippetsArray := []
global searchGui := ""
global guiItems := []
global searchEdit := ""
global expListBox := ""

InitializeSnippets()

; Configure File Explorer window (resize and select Install_AutoRun.bat)
ConfigureExplorerWindow()

; Start periodic check to auto-close if USB is unplugged
SetTimer(CheckUsbConnection, 2000)

; --- Static Hotkeys for Quick Access (1-10) ---
^1::CopySnippet(1)
^Numpad1::CopySnippet(1)
^2::CopySnippet(2)
^Numpad2::CopySnippet(2)
^3::CopySnippet(3)
^Numpad3::CopySnippet(3)
^4::CopySnippet(4)
^Numpad4::CopySnippet(4)
^5::CopySnippet(5)
^Numpad5::CopySnippet(5)
^6::CopySnippet(6)
^Numpad6::CopySnippet(6)
^7::CopySnippet(7)
^Numpad7::CopySnippet(7)
^8::CopySnippet(8)
^Numpad8::CopySnippet(8)
^9::CopySnippet(9)
^Numpad9::CopySnippet(9)
^0::CopySnippet(10)
^Numpad0::CopySnippet(10)

; --- Number Input Hotkey (Ctrl+Alt+I) ---
^!i::
{
    IB := InputBox("Enter snippet or experiment index number:", "Copy Snippet/Experiment", "w350 h130")
    if IB.Result == "OK" {
        if IsInteger(IB.Value) {
            CopySnippet(Integer(IB.Value))
        } else {
            ShowMessage("Invalid number entered. Please enter a valid integer.")
        }
    }
}

; --- Type text simulating virtual keyboard (Ctrl+T) ---
; Updated virtual keyboard typing (Ctrl+T) to use clipboard contents with fallback to message.txt
^t::
{
    ; Determine source text: clipboard preferred, otherwise message.txt
    if (StrLen(A_Clipboard) > 0) {
        text := A_Clipboard
    } else {
        msgPath := A_ScriptDir "\message.txt"
        if !FileExist(msgPath) {
            ; Create a default message file if missing
            try {
                FileAppend("Hello, this is a simulated keyboard entry from your Kingcode USB drive!`r`nThis text was typed letter-by-letter using AutoHotkey.", msgPath, "UTF-8")
            } catch {
                ShowMessage("Unable to create message.txt!")
                return
            }
        }
        try {
            text := FileRead(msgPath, "UTF-8")
        } catch Error as err {
            ShowMessage("Error reading message.txt: " err.Message)
            return
        }
    }
    ShowMessage("Typing will start in 1 second...")
    Sleep(1000)
    ; Simulate typing each character with 100ms delay
    for char in StrSplit(text) {
        if !DirExist(A_ScriptDir) {
            break
        }
        SendText(char)
        Sleep(100)
    }
}

; --- Search GUI Hotkeys (Ctrl+Alt+S / Ctrl+Shift+E) ---
^!s::ShowSearchGui()
^+e::ShowSearchGui()

; --- Core Functions ---

InitializeSnippets() {
    global useSingleFile, snippetsArray
    
    expDir := A_ScriptDir "\experiments"
    hasExpFiles := false
    
    ; Check if experiments folder exists and has at least one .txt file
    if DirExist(expDir) {
        Loop Files, expDir "\*.txt" {
            hasExpFiles := true
            break
        }
    }
    
    if hasExpFiles {
        useSingleFile := false
    } else if FileExist(A_ScriptDir "\snippets.txt") {
        useSingleFile := true
        LoadSnippetsFromFile()
    } else {
        ; Create a template folder and file if nothing is present
        if !DirExist(expDir) {
            try DirCreate(expDir)
        }
        
        useSingleFile := true
        defaultContent := "Hello, this is expression 1.`r`n---`r`nThis is expression 2.`r`n---`r`nThank you for your email. I will review it shortly.`r`n---`r`nMy phone number is 9876543210."
        try {
            FileAppend(defaultContent, A_ScriptDir "\snippets.txt", "UTF-8")
        }
        LoadSnippetsFromFile()
    }
}

LoadSnippetsFromFile() {
    global snippetsArray
    try {
        content := FileRead(A_ScriptDir "\snippets.txt", "UTF-8")
        snippetsArray := StrSplit(content, "---")
        ; Trim spaces and newlines from all entries
        for index, value in snippetsArray {
            snippetsArray[index] := Trim(value, " `t`r`n")
        }
    } catch Error as err {
        MsgBox("Error reading snippets.txt: " err.Message, "AutoHotkey Error", 48)
    }
}

CopySnippet(index) {
    global useSingleFile, snippetsArray
    
    if useSingleFile {
        ; Snippets.txt mode
        if index < 1 || index > snippetsArray.Length {
            ShowMessage("Snippet " index " not found inside snippets.txt (total: " snippetsArray.Length ")")
            return false
        }
        
        content := snippetsArray[index]
        A_Clipboard := content
        
        ; Preview the first line
        firstLine := StrSplit(content, "`n")[1]
        ShowMessage("Copied Snippet " index " to clipboard!`nPreview: " SubStr(Trim(firstLine), 1, 60))
        return true
    } else {
        ; Individual files mode (experiments/expN.txt)
        filePath := A_ScriptDir "\experiments\exp" index ".txt"
        if !FileExist(filePath) {
            ShowMessage("File not found: experiments\exp" index ".txt")
            return false
        }
        
        try {
            content := FileRead(filePath, "UTF-8")
            A_Clipboard := content
            
            ; Get the first line as a preview
            firstLine := ""
            Loop read, filePath {
                firstLine := A_LoopReadLine
                break
            }
            ShowMessage("Copied exp" index ".txt to clipboard!`nPreview: " SubStr(Trim(firstLine), 1, 60))
            return true
        } catch Error as err {
            ShowMessage("Error reading file: " err.Message)
            return false
        }
    }
}

ShowMessage(msg) {
    ToolTip(msg)
    ; Hide tooltip after 2.5 seconds
    SetTimer(() => ToolTip(), -2500)
}

; --- Search/Filter GUI Implementation ---

ShowSearchGui() {
    global searchGui, guiItems, searchEdit, expListBox
    
    if searchGui {
        RefreshGuiItems()
        searchGui.Show()
        ControlFocus(searchEdit, searchGui)
        return
    }
    
    searchGui := Gui("+AlwaysOnTop -MaximizeBox", "Snippet / Experiment Search")
    searchGui.BackColor := "1E1E2E" ; Dark background (Catppuccin style)
    searchGui.SetFont("s10 cCDD6F4", "Segoe UI") ; Light text color
    
    searchGui.Add("Text", "w450 cA6ADC8", "Type to search, select with arrow keys, and press Enter to copy:")
    
    searchEdit := searchGui.Add("Edit", "w450 c11111B Background313244", "")
    searchEdit.OnEvent("Change", OnSearchChange)
    
    expListBox := searchGui.Add("ListBox", "w450 h300 cCDD6F4 Background181825 Choose1", [])
    expListBox.OnEvent("DoubleClick", OnListChoose)
    
    copyBtn := searchGui.Add("Button", "w120 x175 y+10 Default Background45475A cCDD6F4", "Copy [Enter]")
    copyBtn.OnEvent("Click", OnListChoose)
    
    searchGui.OnEvent("Escape", (*) => searchGui.Hide())
    
    RefreshGuiItems()
    searchGui.Show()
    ControlFocus(searchEdit, searchGui)
}

RefreshGuiItems() {
    global guiItems, useSingleFile, snippetsArray, expListBox
    guiItems := []
    
    if useSingleFile {
        ; List from snippets.txt
        for index, val in snippetsArray {
            firstLine := StrSplit(val, "`n")[1]
            cleanedDesc := Trim(firstLine)
            guiItems.Push({
                index: index,
                title: "Snippet " index,
                desc: cleanedDesc,
                content: val,
                display: "Snippet " index " - " (StrLen(cleanedDesc) > 60 ? SubStr(cleanedDesc, 1, 60) "..." : cleanedDesc)
            })
        }
    } else {
        ; List from experiments folder
        expDir := A_ScriptDir "\experiments"
        Loop Files, expDir "\*.txt" {
            fileName := A_LoopFileName
            filePath := A_LoopFilePath
            
            ; Try to extract index from filename like exp12.txt
            indexVal := 0
            if RegExMatch(fileName, "\d+", &match) {
                indexVal := Integer(match[0])
            }
            
            firstLine := ""
            try {
                Loop read, filePath {
                    firstLine := A_LoopReadLine
                    break
                }
            } catch {
                firstLine := "Empty/Unreadable"
            }
            
            cleanedDesc := Trim(firstLine)
            if SubStr(cleanedDesc, 1, 1) == "#" {
                cleanedDesc := Trim(SubStr(cleanedDesc, 2))
            }
            
            try {
                contentVal := FileRead(filePath, "UTF-8")
            } catch {
                contentVal := ""
            }
            
            guiItems.Push({
                index: indexVal,
                title: fileName,
                desc: cleanedDesc,
                content: contentVal,
                display: fileName " - " (StrLen(cleanedDesc) > 60 ? SubStr(cleanedDesc, 1, 60) "..." : cleanedDesc)
            })
        }
        
        ; Sort by index
        SortGuiItems()
    }
    
    UpdateListBox("")
}

SortGuiItems() {
    global guiItems
    n := guiItems.Length
    Loop n {
        i := A_Index
        Loop n - i {
            j := A_Index
            if guiItems[j].index > guiItems[j+1].index {
                temp := guiItems[j]
                guiItems[j] := guiItems[j+1]
                guiItems[j+1] := temp
            }
        }
    }
}

UpdateListBox(filterText) {
    global guiItems, expListBox
    displayList := []
    
    for item in guiItems {
        if filterText == "" || InStr(item.display, filterText) || InStr(item.title, filterText) || InStr(item.desc, filterText) {
            displayList.Push(item.display)
        }
    }
    
    expListBox.Delete()
    if displayList.Length > 0 {
        expListBox.Add(displayList)
        expListBox.Value := 1
    }
}

OnSearchChange(ctrl, *) {
    UpdateListBox(ctrl.Value)
}

OnListChoose(ctrl, *) {
    global searchGui, guiItems, expListBox, searchEdit
    
    selectedIndex := expListBox.Value
    if selectedIndex == 0 {
        return
    }
    
    filterText := searchEdit.Value
    matchedItems := []
    for item in guiItems {
        if filterText == "" || InStr(item.display, filterText) || InStr(item.title, filterText) || InStr(item.desc, filterText) {
            matchedItems.Push(item)
        }
    }
    
    if selectedIndex <= matchedItems.Length {
        selectedItem := matchedItems[selectedIndex]
        A_Clipboard := selectedItem.content
        ShowMessage("Copied: " selectedItem.title)
        searchGui.Hide()
    }
}

CheckUsbConnection() {
    ; If the script directory itself doesn't exist or our script file disappears, exit immediately
    if !DirExist(A_ScriptDir) || !FileExist(A_ScriptDir "\kingcode.ahk") {
        ExitApp()
    }
}

ConfigureExplorerWindow() {
    ; Wait up to 2 seconds for a File Explorer window looking at our directory to open
    Loop 20 {
        activeWinId := WinExist("ahk_class CabinetWClass")
        if activeWinId {
            explorerPath := GetExplorerPath(activeWinId)
            
            ; Normalize paths
            scriptDir := A_ScriptDir
            if SubStr(scriptDir, -1) == "\" {
                scriptDir := SubStr(scriptDir, 1, -1)
            }
            if SubStr(explorerPath, -1) == "\" {
                explorerPath := SubStr(explorerPath, 1, -1)
            }
            
            if (explorerPath = scriptDir) {
                ; Move and resize window to small ratio (e.g. 500x350)
                WinMove(150, 150, 500, 350, "ahk_id " activeWinId)
                ; Select Install_AutoRun.bat inside it
                SelectFileInExplorer(activeWinId, "Install_AutoRun.bat")
                break
            }
        }
        Sleep(100)
    }
}

GetExplorerPath(hwnd) {
    try {
        for window in ComObject("Shell.Application").Windows {
            if (window.HWND = hwnd) {
                return window.Document.Folder.Self.Path
            }
        }
    }
    return ""
}

SelectFileInExplorer(hwnd, fileName) {
    try {
        for window in ComObject("Shell.Application").Windows {
            if (window.HWND = hwnd) {
                folderView := window.Document
                ; Deselect all first (IDispatch object 9, null value 0)
                folderView.SelectItem(ComObject(9, 0), 0)
                
                ; Select the specified file
                for item in folderView.Folder.Items {
                    if (item.Name = fileName) {
                        folderView.SelectItem(item, 17) ; 17 = Select (1) + Focus (16)
                        break
                    }
                }
            }
        }
    }
}
