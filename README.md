# mac-insomnia 🌙 ⚡

> **Ultra-lightweight, zero-bloat macOS lid-closed stay-awake CLI tool for AI agents, local LLMs, and background jobs.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%20Apple%20Silicon%20%7C%20Intel-lightgrey.svg)]()
[![Footprint: ~24 KB](https://img.shields.io/badge/Disk%20Footprint-~24%20KB-success.svg)]()
[![Idle RAM: 0 MB](https://img.shields.io/badge/Idle%20RAM-0%20MB-success.svg)]()

Keep your MacBook running with the lid closed without external displays or heavy menu-bar apps. Built specifically for developers running local LLMs (Ollama, llama.cpp), background AI agents, long training sessions, large downloads, or builds.

---

## Why mac-insomnia?

Most existing tools (Amphetamine, Insomnia.app, Macsomnia) are heavy Swift/SwiftUI GUI apps requiring 50–100 MB of disk space, eating 80–120 MB of RAM in the menu bar, and running background daemons polling every 60 seconds.

**mac-insomnia** strips away the bloat and gives you pure, deterministic control:

| Feature | Heavy Menu-Bar Apps | `mac-insomnia` |
| :--- | :--- | :--- |
| **Disk Space** | 50 – 100 MB | **~24 KB** |
| **Idle RAM** | 80 – 120 MB | **0 MB** (no resident GUI) |
| **Active RAM** | 80 – 120 MB | **< 8 MB** |
| **Background Daemons** | Continuous launchd jobs | **None** (Clean on-demand process) |
| **Smart Display Off** | ❌ Screen often stays backlit | **✅ Yes (Instant blackout on lid close)** |
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

### 2. (Recommended) One-Command Permission Setup

macOS requires administrator privileges to toggle clamshell sleep (`pmset -a disablesleep`). To allow `mac-insomnia` to toggle sleep seamlessly without prompting for your password, run:

```bash
mac-insomnia setup
```

Or manually run:
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

### 2. Start a Stay-Awake Session (Runs as a Detached Background Daemon)

`mac-insomnia start` launches automatically into the background and detaches from your terminal. You can safely close your terminal window or terminal app and the daemon will keep running!

```bash
# Stay awake in background for 2 hours (default)
mac-insomnia start 2h

# Custom durations (e.g. 30m, 45m, 4h, 1d)
mac-insomnia start 45m

# Indefinite (stays awake until manually stopped or battery reaches floor)
mac-insomnia start indefinite

# Run in foreground instead (optional)
mac-insomnia start 2h -f
```

View live daemon activity anytime:
```bash
tail -f ~/.cache/mac-insomnia/daemon.log
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

1. **Hardware Display Blackout on Lid Close:** On macOS, when sleep is disabled, closing the lid prevents macOS from shutting off the display backlight automatically. `mac-insomnia` polls the clamshell sensor every ~0.5 s and, via Apple's private `DisplayServices` framework, drops the built-in display backlight brightness to **0.0%** once it detects `AppleClamshellState = Yes`. The screen goes completely dark, eliminating heat against the closed lid and saving battery, while all AI models, agents, scripts, and MCP servers run at 100% speed. The original brightness is restored automatically when you open the lid. (Built-in display only; external monitors are unaffected.)
2. **Battery Floor Protection:** If running on battery power and charge drops to or below **15%**, `mac-insomnia` automatically restores normal sleep settings and terminates, preventing battery exhaustion.
3. **Clean Signal Traps:** Standard `atexit` and signal handlers (`SIGINT`, `SIGTERM`, `SIGHUP`) ensure that interrupting the script instantly resets `disablesleep` back to `0`.
4. **Orphan Detection:** Running `mac-insomnia status` inspects if `disablesleep` is stuck at `1` without an active daemon and warns you with an instant one-click reset.

---

## ❓ Troubleshooting & FAQ

#### Q: Why does `mac-insomnia` require sudo privileges?
macOS strictly guards the clamshell sleep setting (`pmset -a disablesleep 1/0`) behind root privileges. Running `mac-insomnia setup` configures a secure, granular sudoers rule strictly for `/usr/bin/pmset -a disablesleep`, allowing you to run `mac-insomnia` commands seamlessly without password prompts.

#### Q: How do I verify my Mac is actually staying awake?
Run `mac-insomnia status`. It displays the active daemon PID, elapsed duration, remaining time, battery level, and confirms `SleepDisabled = 1`. You can also tail the live daemon log at `tail -f ~/.cache/mac-insomnia/daemon.log`.

#### Q: Does my screen stay on when the lid is closed?
No. `mac-insomnia` monitors the hardware clamshell sensor via Apple's native `DisplayServices` framework. When the lid closes, it automatically dims the display backlight to `0.0%`, completely turning off the screen to prevent heat buildup and preserve battery. When you reopen the lid, your previous brightness is restored immediately.

---

## 🗑️ Uninstallation

### Option 1: Via Uninstaller Script (Recommended)
From inside the repository folder, run:
```bash
./uninstall.sh
```

### Option 2: Manual Removal & Cleanup
To reset system sleep settings and remove all installed files manually:
```bash
# 1. Stop any active stay-awake sessions and restore default macOS sleep
mac-insomnia stop 2>/dev/null || true
sudo pmset -a disablesleep 0 2>/dev/null || true

# 2. Remove binary, cache/logs, and passwordless sudoers file
rm -f ~/.local/bin/mac-insomnia
rm -rf ~/.cache/mac-insomnia
sudo rm -f /etc/sudoers.d/mac-insomnia

# 3. Delete the repository directory
rm -rf ~/mac-insomnia
```

---

## 📄 License

MIT License © 2026 Anant Raj
