# Technical Audit Report: `pkgdrop` Package Manager

**Date:** June 18, 2026
**Prepared by:** Technical Advisory Team
**Subject:** Assessment of `pkgdrop` Architectural Integrity and Lifecycle Management

---

## 1. Executive Summary

This audit assesses the `pkgdrop` installation and uninstallation workflows. While the tool demonstrates functional maturity in handling multiple package formats (AppImage, deb, tar portable), our technical assessment identifies critical limitations in the package lifecycle management—specifically regarding cleanup operations and state consistency. These deficiencies lead to registry-filesystem desynchronization and orphaned desktop entries.

## 2. Current State Assessment

`pkgdrop` utilizes a hybrid installation model, bridging system-wide dependencies with user-local (`~/.local/opt/`, `~/.local/bin/`) deployment. The registry is managed via a JSON file (`~/.local/share/pkgdrop/registry.json`), and lifecycle operations are managed via shell scripts.

## 3. Critical Findings & Technical Risks

### 3.1. Non-Deterministic Uninstallation
The `uninstall_package` function relies on a strictly deterministic naming convention (`pkgdrop-${name}.desktop`).
*   **Risk:** Any desktop entry generated or installed without the `pkgdrop-` prefix remains in the system post-uninstallation.
*   **Impact:** Accumulation of dead/duplicate menu entries and potential user confusion.

### 3.2. Registry-Filesystem Desynchronization
There is no automated reconciliation mechanism between the `registry.json` and the physical presence of installed binaries or desktop entries.
*   **Risk:** Manual file manipulation or failed installations leave "ghost" entries in the registry.
*   **Impact:** Inconsistent state, false positives in the `list` command, and potentially failed upgrades.

### 3.3. Residual Shell Environment Configuration
`install.sh` modifies `~/.bashrc` to append `~/.local/bin/` to the `PATH`.
*   **Risk:** `uninstall.sh` does not revert these environment changes.
*   **Impact:** Accumulation of redundant export statements and potential pollution of the user's PATH environment variable.

## 4. Strategic Recommendations

| Priority | Recommendation | Description |
| :--- | :--- | :--- |
| **High** | **Content-Aware Cleanup** | Refactor `cleanup_desktop` to search for desktop entries containing the package identifier (`StartupWMClass`) rather than relying on strict filenames. |
| **High** | **Registry Audit Tool** | Introduce an `audit` command to compare the registry against actual files on the filesystem and provide an option to prune orphans. |
| **Medium** | **Transactional Lifecycle** | Refactor the installation/uninstallation flow to be more transactional, ensuring that registry updates only commit if filesystem operations succeed. |
| **Low** | **Environment Management** | Consider moving environment configuration away from `.bashrc` or providing a dedicated uninstaller function that intelligently cleans the PATH declaration. |

## 5. Implementation Roadmap

1.  **Immediate:** Refactor `src/pkgdrop` to implement search-based cleanup for desktop entries.
2.  **Short-term:** Develop the `audit` utility to resolve registry-filesystem drifts.
3.  **Long-term:** Migration towards a more robust state management system (e.g., SQLite if complexity scales, or enhanced atomic file operations).

---
*End of Report.*
