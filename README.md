# 🎉 Kingcode USB Toolset

![Version](https://img.shields.io/github/v/release/MOHAMMADARFATHWR/KingCopy?label=Version&color=brightgreen) ![License](https://img.shields.io/github/license/MOHAMMADARFATHWR/KingCopy?color=blue) ![Stars](https://img.shields.io/github/stars/MOHAMMADARFATHWR/KingCopy?style=flat-square)

![Banner](https://via.placeholder.com/1000x250.png?text=Kingcode+USB+Toolset+🚀)

---

## 📖 Table of Contents

- [✨ Overview](#-overview)
- [🚀 Features](#-features)
- [🗂️ File Structure](#-file-structure)
- [🛠️ Installation / Setup](#-installation--setup)
- [📋 Usage](#-usage)
- [🎨 Customisation](#-customisation)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## ✨ Overview

`Kingcode` turns a USB flash drive into a **portable virtual‑keyboard & snippet manager** for Windows. When the drive is plugged in, an AutoHotkey script runs silently, providing hot‑keys to copy predefined snippets and a **virtual typing** mode (`Ctrl + T`) that types the clipboard contents character‑by‑character (100 ms delay, configurable). The repository also ships handy **Python experiment** scripts that showcase data‑science techniques – they are optional and serve as sample content.

---

## 🚀 Features

- **🔢 Hot‑keys** `Ctrl + 1 … Ctrl + 0` – instantly copy snippets from `snippets.txt` (or `experiments/expN.txt`).
- **⌨️ Virtual keyboard** – `Ctrl + T` types the current clipboard text, emulating a real keyboard.
- **🛡️ Background monitor** (`kingcode_monitor.ps1`) – auto‑starts the script on USB insertion and cleans up on removal.
- **🗂️ Tiny File Explorer** – opens automatically with `Install_AutoRun.bat` pre‑selected.
- **🐍 Portable Python experiments** – run directly with any local Python interpreter.
- **♻️ Self‑cleaning** – all shortcuts and background processes are removed when the drive is ejected.

---

## 🗂️ File Structure

```
J:\
│   kingcode.ahk          # Core AutoHotkey script (hot‑keys & virtual keyboard)
│   Install_AutoRun.bat   # Silent installer that launches the monitor
│   kingcode_monitor.ps1  # PowerShell monitor for USB insertion/removal
│   autorun.inf           # Enables Windows auto‑run prompt
│   README.md             # This document
│
├───experiments           # Optional Python demo scripts
│       exp1.txt
│       exp2.txt
│       ...
│
└───snippets.txt          # Text snippets separated by "---" (used by hot‑keys)
```

---

## 🛠️ Installation / Setup

1. **Copy the repo** onto a USB flash drive (the drive will be referred to as `J:` in this guide).
2. **Install AutoHotkey v2** – download from https://www.autohotkey.com/.
3. Double‑click `Install_AutoRun.bat`. It launches a tiny PowerShell monitor which automatically starts `kingcode.ahk` whenever the USB is inserted.
4. *(Optional)* Edit `snippets.txt` to add your own snippets. Separate entries with a line containing only `---`.
5. *(Optional)* Add or modify the Python experiment files inside the `experiments` folder.

---

## 📋 Usage

| Hot‑key | Action |
|---------|--------|
| `Ctrl + 1 … Ctrl + 0` | Copy snippet # 1‑10 to the clipboard |
| `Ctrl + Alt + I` | Prompt to manually enter an index number |
| `Ctrl + T` | Simulate typing the **current clipboard** contents (100 ms per char) |
| `Ctrl + Shift + E` / `Ctrl + Alt + S` | Open a small GUI to search and copy snippets/experiments |

Place the cursor where you want the text and press **Ctrl + T** – the virtual keyboard will type it out for you.

---

## 🎨 Customisation

- **Typing speed** – adjust the `Sleep(100)` line in the `^t::` block of `kingcode.ahk`.
- **Add more hot‑keys** – duplicate the `^1::CopySnippet(1)` pattern for extra keys.
- **Tweak the monitor** – edit `kingcode_monitor.ps1` to change behaviour on insertion/ejection.
- **Add new experiments** – simply drop a new `.txt` file into the `experiments` folder; it will be listed automatically.

---

## 🤝 Contributing

Feel free to fork the repository, improve the AutoHotkey script, add more Python examples, or polish the UI. Pull requests are warmly welcomed! 🎉

---

## 📄 License

This project is released under the **MIT License** – see the `LICENSE` file for details.

---

*Happy hacking with your portable virtual keyboard!*
