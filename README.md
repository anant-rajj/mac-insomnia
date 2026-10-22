# mac-insomnia 🌙 ⚡

> **Ultra-lightweight, zero-bloat macOS lid-closed stay-awake CLI tool for AI agents, local LLMs, and background jobs.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%20Apple%20Silicon%20%7C%20Intel-lightgrey.svg)]()
[![Footprint: < 10KB](https://img.shields.io/badge/Disk%20Footprint-%3C%2010%20KB-success.svg)]()
[![Idle RAM: 0 MB](https://img.shields.io/badge/Idle%20RAM-0%20MB-success.svg)]()

Keep your MacBook running with the lid closed without external displays or heavy menu-bar apps. Built specifically for developers running local LLMs (Ollama, llama.cpp), background AI agents, long training sessions, large downloads, or builds.

---

## Why mac-insomnia?

Most existing tools (Amphetamine, Insomnia.app, Macsomnia) are heavy Swift/SwiftUI GUI apps requiring 50–100 MB of disk space, eating 80–120 MB of RAM in the menu bar, and running background daemons polling every 60 seconds.

**mac-insomnia** strips away the bloat and gives you pure, deterministic control:

| Feature | Heavy Menu-Bar Apps | `mac-insomnia` |
| :--- | :--- | :--- |
| **Disk Space** | 50 – 100 MB | **~7 KB** |
| **Idle RAM** | 80 – 120 MB | **0 MB** (no resident GUI) |
| **Active RAM** | 80 – 120 MB | **< 8 MB** |
| **Background Daemons** | Continuous launchd jobs | **None** (Clean on-demand process) |
| **Command Wrapping** | ❌ No | **✅ Yes (`mac-insomnia wrap <cmd>`)** |
| **Battery Safety Floor** | Sometimes | **✅ Yes (Auto-restores sleep at 15%)** |
| **Fail-Safe Cleanup** | Prone to stuck sleep bugs | **✅ POSIX Signal Traps (`SIGINT/TERM/HUP`)** |

---

## ⚡ Installation

### Quick One-Liner (Clone & Install)

```bash
git clone https://github.com/anant-rajj/mac-insomnia.git
cd mac-insomnia
./install.sh
```

### (Optional) Enable Passwordless Sudo

macOS requires administrator privileges to toggle clamshell sleep (`pmset -a disablesleep`). To allow `mac-insomnia` to toggle without prompting for your password every time, run:

```bash
mac-insomnia sudoers
```

Or manually run the one-line rule:
```bash
echo "$USER ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1" | sudo tee /etc/sudoers.d/mac-insomnia > /dev/null && sudo chmod 0440 /etc/sudoers.d/mac-insomnia
```

---

## 🚀 Usage

### 1. Check Status

```bash
mac-insomnia status
```
Outputs current power source, battery percentage, whether lid stay-awake (`disablesleep`) is active, and daemon session timer.

### 2. Start a Stay-Awake Session

```bash
# Stay awake for 2 hours (default)
mac-insomnia start 2h

# Custom durations (e.g. 30m, 45m, 4h, 1d)
mac-insomnia start 45m

# Indefinite (stays awake until manually stopped or battery reaches floor)
mac-insomnia start indefinite
```

### 3. Stop Anytime

```bash
mac-insomnia stop
```
Terminates the active session and guarantees `pmset -a disablesleep 0` is restored.

### 4. Command Wrapper (The Killer Feature for AI / LLMs!)

Run any command with lid-stay-awake active **strictly while that command is running**. The moment the process finishes or exits, normal sleep is restored immediately:

```bash
# Keep MacBook awake with lid closed while running a local model:
mac-insomnia wrap ollama run deepseek-r1

# Or running an overnight agent / script:
mac-insomnia wrap python run_eval.py
```

---

## 🛡️ Safety & Safeguards

1. **Battery Floor Protection:** If running on battery power and charge drops to or below **15%**, `mac-insomnia` automatically restores normal sleep settings and terminates, preventing battery exhaustion.
2. **Clean Signal Traps:** Standard `atexit` and signal handlers (`SIGINT`, `SIGTERM`, `SIGHUP`) ensure that interrupting the script instantly resets `disablesleep` back to `0`.
3. **Orphan Detection:** Running `mac-insomnia status` inspects if `disablesleep` is stuck at `1` without an active daemon and warns you with an instant one-click reset.

---

## 🗑️ Uninstallation

```bash
./uninstall.sh
```

---

## 📄 License

MIT License © 2026 Anant Raj
