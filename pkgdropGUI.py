#!/usr/bin/env python3
"""
pkgdrop GUI — Dark theme tkinter interface
Uses theyonecodes/toolkit DarkTheme for consistent styling.
"""

import sys
import os
import subprocess
import threading
import json
import argparse
from pathlib import Path

# Add toolkit to path
toolkit_path = Path(__file__).parent / "vendor" / "toolkit"
if toolkit_path.exists():
    sys.path.insert(0, str(toolkit_path))

import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext, filedialog

# Import DarkTheme from toolkit
try:
    from toolkit.gui.dark_theme import (
        apply_dark_theme, create_dark_button, create_dark_frame,
        create_dark_label, create_dark_combobox, create_dark_treeview,
        create_dark_progressbar, create_dark_separator, create_dark_entry,
        BG, BG2, BG3, FG, FG2, ACCENT, GREEN, RED, AMBER, GRAY,
        BORDER, FONT, FONT_BOLD, FONT_TITLE, FONT_MONO,
        STATUS_COLORS
    )
    HAS_TOOLKIT = True
except ImportError:
    HAS_TOOLKIT = False
    # Fallback colors
    BG = "#0D1117"
    BG2 = "#161B22"
    BG3 = "#1C2128"
    FG = "#E6EDF3"
    FG2 = "#8B949E"
    ACCENT = "#58A6FF"
    GREEN = "#3FB950"
    RED = "#F85149"
    AMBER = "#D29922"
    GRAY = "#8B949E"
    BORDER = "#30363D"
    FONT = ("Segoe UI", 10)
    FONT_BOLD = ("Segoe UI", 10, "bold")
    FONT_TITLE = ("Segoe UI", 16, "bold")
    FONT_MONO = ("Consolas", 10)
    STATUS_COLORS = {"PASS": GREEN, "FAIL": RED, "WARNING": AMBER, "PENDING": GRAY}


class PkgdropGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("pkgdrop — Universal Package Installer")
        self.root.minsize(900, 650)
        self.root.configure(bg=BG)
        self.root.state("zoomed")
        
        self.script_path = Path(__file__).parent / "src" / "pkgdrop"
        self.log_path = Path.home() / ".local" / "share" / "pkgdrop" / "install.log"
        self.running_task = None
        
        self._build_ui()
        self._load_initial_info()
    
    def _build_ui(self):
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(2, weight=1)
        
        # ========== ROW 0: Header ==========
        header = tk.Frame(self.root, bg=BG2, height=56, highlightthickness=0)
        header.grid(row=0, column=0, sticky="ew")
        header.grid_propagate(False)
        
        tk.Label(header, text="PKGDROP", bg=BG2, fg=ACCENT,
                 font=FONT_TITLE).pack(side=tk.LEFT, padx=25, pady=14)
        tk.Label(header, text="Universal Package Installer for Arch Linux", bg=BG2, fg=FG2,
                 font=FONT_MONO).pack(side=tk.LEFT, padx=(0, 14), pady=14)
        
        # Status indicators
        status_frame = tk.Frame(header, bg=BG2)
        status_frame.pack(side=tk.RIGHT, padx=25, pady=14)
        
        self.backup_status = tk.Label(status_frame, text="BACKUP: ON" if HAS_TOOLKIT else "BACKUP: OFF",
                                      bg=BG2, fg=GREEN if HAS_TOOLKIT else AMBER,
                                      font=FONT_MONO)
        self.backup_status.pack(side=tk.LEFT, padx=(0, 12))
        
        self.admin_status = tk.Label(status_frame, text="ROOT: YES" if os.geteuid() == 0 else "ROOT: NO",
                                     bg=BG2, fg=GREEN if os.geteuid() == 0 else RED,
                                     font=FONT_MONO)
        self.admin_status.pack(side=tk.LEFT)
        
        # ========== ROW 1: Toolbar ==========
        toolbar = tk.Frame(self.root, bg=BG, highlightthickness=0)
        toolbar.grid(row=1, column=0, sticky="ew", padx=20, pady=(16, 4))
        toolbar.columnconfigure(1, weight=1)
        
        # File selector
        file_frame = tk.Frame(toolbar, bg=BG3, highlightthickness=1, highlightbackground=BORDER)
        file_frame.grid(row=0, column=0, sticky="w", padx=(0, 8))
        file_frame.columnconfigure(1, weight=1)
        
        tk.Label(file_frame, text="Package:", bg=BG3, fg=FG2, font=FONT).grid(row=0, column=0, padx=(8, 4))
        self.file_var = tk.StringVar()
        self.file_entry = create_dark_entry(file_frame, textvariable=self.file_var, width=50)
        self.file_entry.grid(row=0, column=1, padx=(4, 4), pady=4, sticky="ew")
        
        browse_btn = create_dark_button(file_frame, "BROWSE", self._browse_file, variant="ghost", width=8)
        browse_btn.grid(row=0, column=2, padx=(0, 8), pady=4)
        
        # Package type display
        self.type_var = tk.StringVar(value="Type: auto")
        tk.Label(file_frame, textvariable=self.type_var, bg=BG3, fg=FG2, font=FONT_MONO).grid(row=0, column=3, padx=(8, 8))
        
        # Right side - actions
        if HAS_TOOLKIT:
            jej_btn = create_dark_button(toolbar, "JEV TRIAGE", self._run_jev_triage, variant="warn")
            jej_btn.grid(row=0, column=2, padx=(8, 0), sticky="e")
        
        backup_btn = create_dark_button(toolbar, "VIEW BACKUPS", self._view_backups, variant="ghost")
        backup_btn.grid(row=0, column=3, padx=(8, 0), sticky="e")
        
        # ========== ROW 2: Options & Progress ==========
        options_frame = tk.Frame(self.root, bg=BG2, highlightthickness=1, highlightbackground=BORDER)
        options_frame.grid(row=2, column=0, sticky="ew", padx=20, pady=(8, 4))
        options_frame.columnconfigure(0, weight=1)
        
        # Options row
        opt_row = tk.Frame(options_frame, bg=BG2)
        opt_row.pack(fill=tk.X, padx=12, pady=8)
        
        self.chk_dry_run = tk.BooleanVar(value=False)
        self.chk_dry = tk.Checkbutton(opt_row, text="DRY RUN", variable=self.chk_dry_run,
                                       bg=BG2, fg=FG, selectcolor=BG3, activebackground=BG2,
                                       activeforeground=FG, font=FONT, cursor="hand2")
        self.chk_dry.pack(side=tk.LEFT, padx=(0, 16))
        
        self.chk_force = tk.BooleanVar(value=False)
        self.chk_frc = tk.Checkbutton(opt_row, text="FORCE", variable=self.chk_force,
                                       bg=BG2, fg=FG, selectcolor=BG3, activebackground=BG2,
                                       activeforeground=FG, font=FONT, cursor="hand2")
        self.chk_frc.pack(side=tk.LEFT, padx=(0, 16))
        
        self.chk_verbose = tk.BooleanVar(value=True)
        self.chk_vrb = tk.Checkbutton(opt_row, text="VERBOSE", variable=self.chk_verbose,
                                       bg=BG2, fg=FG, selectcolor=BG3, activebackground=BG2,
                                       activeforeground=FG, font=FONT, cursor="hand2")
        self.chk_vrb.pack(side=tk.LEFT, padx=(0, 16))
        
        self.chk_system = tk.BooleanVar(value=False)
        self.chk_sys = tk.Checkbutton(opt_row, text="SYSTEM-WIDE (sudo)", variable=self.chk_system,
                                       bg=BG2, fg=FG, selectcolor=BG3, activebackground=BG2,
                                       activeforeground=FG, font=FONT, cursor="hand2")
        self.chk_sys.pack(side=tk.LEFT, padx=(0, 16))
        
        # Extract mode for AppImage
        self.chk_extract = tk.BooleanVar(value=False)
        self.chk_ext = tk.Checkbutton(opt_row, text="EXTRACT MODE (AppImage)", variable=self.chk_extract,
                                       bg=BG2, fg=FG, selectcolor=BG3, activebackground=BG2,
                                       activeforeground=FG, font=FONT, cursor="hand2")
        self.chk_ext.pack(side=tk.LEFT, padx=(0, 16))
        
        # Progress bar
        self.progress_var = tk.DoubleVar()
        self.progress = create_dark_progressbar(options_frame, variable=self.progress_var, maximum=100)
        self.progress.pack(fill=tk.X, padx=12, pady=(0, 12))
        
        # ========== ROW 3: Action Buttons ==========
        action_frame = tk.Frame(self.root, bg=BG)
        action_frame.grid(row=3, column=0, sticky="ew", padx=20, pady=(4, 8))
        
        self.install_btn = create_dark_button(action_frame, "INSTALL", self._install, variant="accent")
        self.install_btn.pack(side=tk.LEFT, padx=(0, 8))
        
        self.uninstall_btn = create_dark_button(action_frame, "UNINSTALL", self._uninstall, variant="danger")
        self.uninstall_btn.pack(side=tk.LEFT, padx=(0, 8))
        
        self.upgrade_btn = create_dark_button(action_frame, "UPGRADE", self._upgrade, variant="warn")
        self.upgrade_btn.pack(side=tk.LEFT, padx=(0, 8))
        
        self.audit_btn = create_dark_button(action_frame, "AUDIT", self._audit, variant="ghost")
        self.audit_btn.pack(side=tk.LEFT, padx=(0, 8))
        
        self.list_btn = create_dark_button(action_frame, "LIST", self._list, variant="ghost")
        self.list_btn.pack(side=tk.LEFT, padx=(0, 8))
        
        self.clean_btn = create_dark_button(action_frame, "CLEAN", self._clean, variant="ghost")
        self.clean_btn.pack(side=tk.LEFT, padx=(0, 8))
        
        # ========== ROW 4: Log Area ==========
        log_frame = tk.Frame(self.root, bg=BG2, highlightthickness=1, highlightbackground=BORDER)
        log_frame.grid(row=4, column=0, sticky="nsew", padx=20, pady=(4, 16))
        log_frame.columnconfigure(0, weight=1)
        log_frame.rowconfigure(0, weight=1)
        
        self.log_text = scrolledtext.ScrolledText(
            log_frame, bg=BG, fg=FG, font=FONT_MONO,
            insertbackground=FG, selectbackground=ACCENT, selectforeground="#FFFFFF",
            highlightthickness=0, bd=0, wrap=tk.WORD
        )
        self.log_text.grid(row=0, column=0, sticky="nsew", padx=4, pady=4)
        self.log_text.configure(state=tk.DISABLED)
        
        # File watch for type detection
        self.file_entry.bind("<KeyRelease>", self._on_file_change)
    
    def _on_file_change(self, event):
        """Auto-detect package type from filename."""
        path = self.file_var.get().strip()
        if not path:
            self.type_var.set("Type: auto")
            return
        
        if path.endswith(('.pkg.tar.zst', '.pkg.tar.xz', '.pkg.tar.gz')):
            self.type_var.set("Type: pacman")
        elif path.endswith(('.tar.xz', '.tar.gz', '.tar.zst', '.tar.bz2')):
            self.type_var.set("Type: tarportable")
        elif path.endswith('.deb'):
            self.type_var.set("Type: debtap")
        elif path.endswith('.AppImage'):
            self.type_var.set("Type: appimage")
        elif path.endswith('.rpm'):
            self.type_var.set("Type: alien")
        else:
            self.type_var.set("Type: unknown")
    
    def _browse_file(self):
        path = filedialog.askopenfilename(
            title="Select package file",
            filetypes=[
                ("All packages", "*.pkg.tar.zst *.pkg.tar.xz *.pkg.tar.gz *.tar.xz *.tar.gz *.tar.zst *.tar.bz2 *.deb *.AppImage *.rpm"),
                ("Pacman", "*.pkg.tar.zst *.pkg.tar.xz *.pkg.tar.gz"),
                ("Tar archives", "*.tar.xz *.tar.gz *.tar.zst *.tar.bz2"),
                ("Debian", "*.deb"),
                ("AppImage", "*.AppImage"),
                ("RPM", "*.rpm"),
                ("All files", "*.*")
            ]
        )
        if path:
            self.file_var.set(path)
            self._on_file_change(None)
    
    def _build_args(self):
        """Build pkgdrop command line arguments from GUI state."""
        args = [str(self.script_path)]
        
        if self.chk_dry_run.get():
            args.append("-n")
        if self.chk_verbose.get():
            args.append("-V")
        if self.chk_force.get():
            args.append("-f")
        if self.chk_system.get():
            args.append("-S")
        if self.chk_extract.get():
            args.append("-x")
        
        return args
    
    def _run_pkgdrop(self, extra_args, description):
        """Run pkgdrop with the given extra arguments."""
        if not self.script_path.exists():
            messagebox.showerror("Error", f"pkgdrop script not found at:\n{self.script_path}")
            return
        
        file_path = self.file_var.get().strip()
        if not file_path and description != "List" and description != "Audit" and description != "Clean":
            messagebox.showwarning("Error", "Please select a package file first")
            return
        
        args = self._build_args() + extra_args
        if file_path:
            args.append(file_path)
        
        self.install_btn.configure(state=tk.DISABLED)
        self.uninstall_btn.configure(state=tk.DISABLED)
        self.upgrade_btn.configure(state=tk.DISABLED)
        self.audit_btn.configure(state=tk.DISABLED)
        self.list_btn.configure(state=tk.DISABLED)
        self.clean_btn.configure(state=tk.DISABLED)
        self.progress_var.set(0)
        
        def worker():
            try:
                self._log(f"=== {description.upper()} ===")
                self._log(f"Command: {' '.join(args)}")
                
                # Run with real-time output
                env = os.environ.copy()
                env["PKGDROP_LOG"] = str(self.log_path)
                
                proc = subprocess.Popen(
                    ["bash", str(self.script_path)] + extra_args + ([file_path] if file_path else []),
                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                    text=True, bufsize=1, env=env
                )
                
                # Stream output
                for line in proc.stdout:
                    line = line.rstrip()
                    if line:
                        self._log(line)
                
                proc.wait()
                
                if proc.returncode == 0:
                    self._log(f"=== {description} COMPLETED ===")
                else:
                    self._log(f"=== {description} FAILED (exit code {proc.returncode}) ===")
                
            except Exception as e:
                self._log(f"ERROR: {e}")
            finally:
                self.root.after(0, self._reset_buttons)
        
        threading.Thread(target=worker, daemon=True).start()
    
    def _install(self):
        file_path = self.file_var.get().strip()
        if not file_path:
            messagebox.showwarning("Error", "Please select a package file first")
            return
        self._run_pkgdrop([], "INSTALL")
    
    def _uninstall(self):
        # Ask for package name
        pkg = tk.simpledialog.askstring("Uninstall", "Enter package name to uninstall:")
        if pkg:
            self._run_pkgdrop(["-u", pkg], "UNINSTALL")
    
    def _upgrade(self):
        file_path = self.file_var.get().strip()
        pkg = tk.simpledialog.askstring("Upgrade", "Enter package name to upgrade:")
        if pkg:
            extra = ["-U", pkg]
            if self.file_var.get().strip():
                extra.append(file_path)
            self._run_pkgdrop(extra, "UPGRADE")
    
    def _audit(self):
        self._run_pkgdrop(["-a"], "AUDIT")
    
    def _list(self):
        self._run_pkgdrop(["-l"], "LIST")
    
    def _clean(self):
        if messagebox.askyesno("Clean", "Remove broken symlinks and orphaned files?"):
            self._run_pkgdrop(["-c"], "CLEAN")
    
    def _run_jev_triage(self):
        if not HAS_TOOLKIT:
            messagebox.showwarning("Jev Router", "Jev Router not available (toolkit not found)")
            return
        
        file_path = self.file_var.get().strip()
        if not file_path:
            messagebox.showwarning("Jev Triage", "Please select a package file first")
            return
        
        self._log("=== JEV TRIAGE ===")
        
        def worker():
            try:
                context = {
                    "task_type": "package_install",
                    "sensitive": True,
                    "package_file": file_path,
                    "required_capabilities": ["system_admin", "file_ops", "package_management", "dependency_resolution"]
                }
                from toolkit.jev_router import JevRouter
                router = JevRouter()
                router.setup_default_choices()
                router.setup_default_nouls()
                
                context_json = json.dumps(context)
                result = router.route("system_optimization", context)
                
                msg = f"Jev Triage Result:\n\n"
                if result.requires_human:
                    msg += "⚠ HUMAN REVIEW REQUIRED\n\n"
                msg += f"Model: {result.selected_option.name if result.selected_option else 'N/A'}\n"
                msg += f"Confidence: {result.final_confidence*100:.0f}%\n"
                msg += f"Reasoning: {result.reasoning}\n"
                if result.triggered_nouls:
                    msg += f"\nGuardrails: {', '.join(n.id for n in result.triggered_nouls)}"
                
                self.root.after(0, lambda: messagebox.showinfo("Jev Triage Result", msg))
            except Exception as e:
                self.root.after(0, lambda: messagebox.showerror("Jev Error", f"Jev triage failed: {e}"))
            
            threading.Thread(target=worker, daemon=True).start()
    
    def _view_backups(self):
        backup_root = Path.home() / ".local" / "share" / "pkgdrop" / "backups"
        if backup_root.exists():
            backups = sorted(backup_root.iterdir(), key=lambda p: p.stat().st_mtime, reverse=True)[:10]
            msg = "Recent pkgdrop backups:\n\n"
            for b in backups:
                msg += f"{b.name}\n"
        else:
            msg = "No backups found"
        messagebox.showinfo("Backup History", msg)
    
    def _log(self, message):
        self.root.after(0, lambda: self._append_log(message))
    
    def _append_log(self, message):
        self.log_text.configure(state=tk.NORMAL)
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.log_text.insert(tk.END, f"[{timestamp}] {message}\n")
        self.log_text.see(tk.END)
        self.log_text.configure(state=tk.DISABLED)
        
        # Also write to file
        try:
            self.log_path.parent.mkdir(parents=True, exist_ok=True)
            with open(self.log_path, "a", encoding="utf-8") as f:
                f.write(f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} | {message}\n")
        except:
            pass
    
    def _reset_buttons(self):
        self.install_btn.configure(state=tk.NORMAL)
        self.uninstall_btn.configure(state=tk.NORMAL)
        self.upgrade_btn.configure(state=tk.NORMAL)
        self.audit_btn.configure(state=tk.NORMAL)
        self.list_btn.configure(state=tk.NORMAL)
        self.clean_btn.configure(state=tk.NORMAL)
        self.progress_var.set(0)
    
    def _load_initial_info(self):
        self._log("pkgdrop GUI started")
        self._log(f"BackupEngine: {'ON' if HAS_TOOLKIT else 'OFF'}")
        self._log(f"Script: {self.script_path}")
        self._log(f"Root: {'YES' if os.geteuid() == 0 else 'NO'}")
        
        # Check for pkgdrop script
        if self.script_path.exists():
            self._log(f"pkgdrop script found: {self.script_path}")
        else:
            self._log(f"WARNING: pkgdrop script NOT found at {self.script_path}")


def main():
    root = tk.Tk()
    
    # Apply dark theme if toolkit available
    if HAS_TOOLKIT:
        apply_dark_theme(root)
    else:
        root.configure(bg=BG)
        style = ttk.Style(root)
        style.theme_use("clam")
        style.configure("Treeview", background=BG2, foreground=FG, fieldbackground=BG2,
                       borderwidth=0, font=FONT, rowheight=28)
        style.map("Treeview", background=[("selected", ACCENT)], foreground=[("selected", "#FFFFFF")])
        style.configure("Treeview.Heading", background=BG3, foreground=FG, font=FONT_BOLD,
                       borderwidth=1, relief="flat")
    
    app = PkgdropGUI(root)
    root.mainloop()


if __name__ == "__main__":
    main()