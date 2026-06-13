# pkgdrop - User Stories

## Epic: Package Installation

### US-001: Install tar.xz package
**As a** Linux user  
**I want to** install a .tar.xz application with one command  
**So that** I don't have to manually extract and set up PATH

**Acceptance Criteria:**
- [ ] `pkgdrop app.tar.xz` extracts to `~/.local/opt/{name}/`
- [ ] Binary is found and symlinked to `~/.local/bin/{name}`
- [ ] Desktop entry is created in app launcher
- [ ] Icon is extracted and installed
- [ ] App appears in taskbar with correct name and icon
- [ ] App runs from terminal: `zen` opens browser

**Definition of Done:**
- Code passes shellcheck
- Passes bats unit tests
- Manual test: install → run → uninstall cycle complete
- Desktop entry follows freedesktop.org spec
- Summary shows install paths

---

### US-002: Install AppImage
**As a** Linux user  
**I want to** install an AppImage with one command  
**So that** it appears in my app launcher like a native app

**Acceptance Criteria:**
- [ ] `pkgdrop app.AppImage` copies to `~/.local/bin/{name}`
- [ ] File is executable
- [ ] Desktop entry is created
- [ ] Icon is extracted if available
- [ ] App runs from terminal and app launcher

---

### US-003: Install .deb package
**As a** Linux user  
**I want to** install a .deb package on Arch Linux  
**So that** I can use Debian-only software

**Acceptance Criteria:**
- [ ] debtap is installed if missing (with user permission)
- [ ] .deb is converted to .pkg.tar.zst
- [ ] Package is installed via pacman
- [ ] Temporary conversion files are cleaned up

---

### US-004: Install .rpm package
**As a** Linux user  
**I want to** install an .rpm package on Arch Linux  
**So that** I can use RPM-only software

**Acceptance Criteria:**
- [ ] alien is installed if missing (with user permission)
- [ ] .rpm is converted to .pkg.tar.zst
- [ ] Package is installed via pacman

---

## Epic: Package Management

### US-005: List installed packages
**As a** user  
**I want to** see what pkgdrop has installed  
**So that** I can manage my installed software

**Acceptance Criteria:**
- [ ] `pkgdrop --list` shows all pkgdrop-installed packages
- [ ] Shows package name and size
- [ ] Only shows pkgdrop packages, not system packages

---

### US-006: Uninstall package
**As a** user  
**I want to** remove a package I no longer need  
**So that** I can free up disk space

**Acceptance Criteria:**
- [ ] `pkgdrop --uninstall zen` prompts for confirmation
- [ ] Removes `~/.local/opt/{name}/`
- [ ] Removes `~/.local/bin/{name}`
- [ ] Removes `.desktop` entry
- [ ] Removes icon from hicolor theme
- [ ] Refreshes desktop database

---

### US-007: Preview changes before install
**As a** user  
**I want to** see what would happen before installing  
**So that** I can make an informed decision

**Acceptance Criteria:**
- [ ] `pkgdrop --dry-run file.tar.xz` shows:
  - [ ] Package name
  - [ ] File size
  - [ ] Install location
  - [ ] Binary path
  - [ ] Desktop entry that would be created
- [ ] No files are modified

---

## Epic: Desktop Integration

### US-008: App appears in launcher
**As a** user  
**I want** installed apps to appear in my app launcher  
**So that** I can launch them without terminal

**Acceptance Criteria:**
- [ ] .desktop entry created in `~/.local/share/applications/`
- [ ] Name is human-readable (e.g., "Zen Browser", not "zen.linux-x86_64")
- [ ] Icon is visible in launcher
- [ ] Clicking icon launches the app
- [ ] App appears in correct category

---

### US-009: App appears in taskbar
**As a** user  
**I want** running apps to show in taskbar with correct icon  
**So that** I can switch between windows

**Acceptance Criteria:**
- [ ] `StartupWMClass` is set correctly
- [ ] Icon matches the one in launcher
- [ ] Taskbar groups app windows correctly

---

## Epic: User Experience

### US-010: Clean uninstall
**As a** user  
**I want** uninstall to remove everything  
**So that** I don't have leftover files

**Acceptance Criteria:**
- [ ] All files removed (dir, symlink, .desktop, icon)
- [ ] Desktop database refreshed
- [ ] Confirmation prompt before removal
- [ ] Shows what was removed

---

### US-011: Skip confirmations
**As a** user  
**I want to** skip all prompts when scripting  
**So that** I can automate installations

**Acceptance Criteria:**
- [ ] `pkgdrop --yes file.tar.xz` skips all prompts
- [ ] Works with reinstall, uninstall, dependency install
- [ ] Exit code is 0 on success

---

### US-012: See installation summary
**As a** user  
**I want to** know where things were installed  
**So that** I can find them later

**Acceptance Criteria:**
- [ ] Shows install directory
- [ ] Shows binary path
- [ ] Shows if desktop entry was created
- [ ] Shows PATH instructions if needed
