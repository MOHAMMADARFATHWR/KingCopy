# Kingcode USB Toolset

## Overview

`Kingcode` turns a USB flash drive into a portable **virtual‑keyboard & snippet manager** that works on any Windows PC.  When the drive is inserted the AutoHotkey script runs in the background, provides hot‑keys to copy predefined text snippets to the clipboard, and lets you **type the clipboard contents character‑by‑character** with `Ctrl + T` (a virtual keyboard).  The project also bundles a collection of small Python *experiment* scripts that demonstrate data‑science techniques – they are completely optional and serve as example content for the snippet manager.

## Features

- **AutoHotkey hot‑keys** `Ctrl + 1 … Ctrl + 0` to copy snippets from `snippets.txt` (or individual `experiments/expN.txt` files) to the clipboard.
- **`Ctrl + T`** types the current clipboard text mimicking a real keyboard (100 ms per character, configurable).
- **Background monitor** (`kingcode_monitor.ps1`) automatically launches the script when the USB is inserted and cleans up when it is removed.
- **Small File‑Explorer window** automatically opened on insertion with the installer (`Install_AutoRun.bat`) pre‑selected.
- **Portable Python experiment files** (`experiments/*.txt`) without any external dependencies – just run them with your local Python interpreter.
- **Self‑cleaning** – shortcuts and background processes are removed when the drive is ejected.

## File Structure

```
J:\
│   kingcode.ahk          # Core AutoHotkey script (hot‑keys & virtual keyboard)
│   Install_AutoRun.bat   # Small installer that starts the monitor silently
│   kingcode_monitor.ps1  # PowerShell monitor that watches for USB insertion/removal
│   autorun.inf           # Labels the drive (required for Windows auto‑run prompt)
│   README.md             # This document
│
├───experiments           # Example Python scripts (optional)
│       exp1.txt
│       exp2.txt
│       ...
│
└───snippets.txt          # Text snippets separated by "---" (used by hot‑keys)
```

## Installation / Setup

1. **Copy the repository** to a USB flash drive (the drive will be referenced as `J:` in this README).
2. **Install AutoHotkey v2** on the host computer if it is not already present – download from https://www.autohotkey.com/.
3. Double‑click `Install_AutoRun.bat` (it opens a tiny console window, launches the PowerShell monitor, and then hides).  The monitor runs in the background and will automatically start `kingcode.ahk` whenever the USB is inserted.
4. (Optional) Edit `snippets.txt` to add your own text snippets.  Use `---` on a line by itself to separate entries.
5. (Optional) Add or modify the Python experiment files in the `experiments` folder.

## Usage

| Hot‑key | Action |
|---------|--------|
| `Ctrl + 1 … Ctrl + 0` | Copy snippet # 1‑10 to the clipboard. |
| `Ctrl + Alt + I` | Prompt to enter an index number manually. |
| `Ctrl + T` | Simulate typing the **current clipboard** contents, character by character (100 ms delay). |
| `Ctrl + Shift + E` or `Ctrl + Alt + S` | Open the search GUI to filter and copy snippets/experiments. |

The virtual keyboard works on any active window – just place the cursor where you want the text and press `Ctrl + T`.

## Customisation

- **Change typing speed** – edit the `Sleep(100)` line in the `^t::` block of `kingcode.ahk`.
- **Add more hot‑keys** – duplicate the `^1::CopySnippet(1)` pattern for additional keys.
- **Modify the monitor** – edit `kingcode_monitor.ps1` to change the behaviour when the drive is inserted or removed.
- **Add new experiments** – place a `.txt` file in the `experiments` folder; the script will list it automatically.

## Contributing

Feel free to fork the repository, improve the AutoHotkey script, add more Python examples, or polish the UI.  Pull requests are welcome.

## License

This project is released under the **MIT License** – see the `LICENSE` file for details.

---

*Happy hacking with your portable virtual keyboard!*
