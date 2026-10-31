# Contributing to mac-insomnia 🌙 ⚡

Thank you for your interest in improving `mac-insomnia`! We welcome contributions, bug fixes, feature requests, and documentation improvements.

---

## 🛠️ Development & Workflow

1. **Fork & Branch**:
   - Fork the repository and create your feature branch:
     ```bash
     git checkout -b feat/your-feature-name
     ```

2. **Zero External Dependencies**:
   - `mac-insomnia` is strictly built using Python's standard library and macOS's native `ctypes` bindings.
   - Do not introduce external pip dependencies.

3. **Verify Syntax & Integrity**:
   - Before committing, ensure the script compiles without errors:
     ```bash
     python3 -m py_compile mac-insomnia
     bash -n install.sh uninstall.sh
     ```
   - Ensure executable permissions remain intact:
     ```bash
     chmod +x mac-insomnia install.sh uninstall.sh
     ```

4. **Commits & Pull Requests**:
   - Use clear, descriptive commit messages (e.g. `feat:`, `fix:`, `docs:`, `ci:`).
   - Reference any related issues in your PR description (e.g., `Closes #12`).

---

## 💡 Code of Conduct

Be courteous, helpful, and collaborative. All contributions and community interactions should remain welcoming and respectful.
