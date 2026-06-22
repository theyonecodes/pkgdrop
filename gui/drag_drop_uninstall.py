#!/usr/bin/env python3
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import subprocess
import os
import sys
from pathlib import Path

class PkgdropUninstaller(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("pkgdrop Uninstaller")
        self.geometry("800x600")
        self.minsize(600, 400)
        
        # Configure grid
        self.grid_columnconfigure(0, weight=1)
        self.grid_rowconfigure(1, weight=1)
        
        # Title
        title_label = tk.Label(self, text="pkgdrop Uninstaller", font=("Helvetica", 16, "bold"))
        title_label.grid(row=0, column=0, pady=(10, 20), sticky="n")
        
        # Drag and drop area
        self.drop_frame = tk.Frame(self, bd=2, relief="raised", bg="#f0f0f0")
        self.drop_frame.grid(row=1, column=0, padx=20, pady=(0, 20), sticky="nsew")
        self.drop_frame.grid_columnconfigure(0, weight=1)
        self.drop_frame.grid_rowconfigure(0, weight=1)
        
        # Drag and drop instructions
        self.drop_label = tk.Label(
            self.drop_frame, 
            text="Drag and drop package files here\nor click to select files",
            font=("Helvetica", 12),
            bg="#f0f0f0",
            fg="#666"
        )
        self.drop_label.pack(expand=True, pady=50)
        
        # Button to open file dialog
        self.browse_btn = tk.Button(
            self.drop_frame, 
            text="Browse Files...", 
            command=self.browse_files,
            font=("Helvetica", 10)
        )
        self.browse_btn.pack(pady=10)
        
        # File list
        self.file_list_label = tk.Label(self, text="Selected files:", font=("Helvetica", 11, "bold"))
        self.file_list_label.grid(row=2, column=0, padx=20, pady=(0, 10), sticky="w")
        
        self.file_listbox = tk.Listbox(self, selectmode=tk.SINGLE, height=6)
        self.file_listbox.grid(row=3, column=0, padx=20, pady=(0, 20), sticky="nsew")
        
        # Scrollbar for file list
        scrollbar = tk.Scrollbar(self, orient="vertical", command=self.file_listbox.yview)
        scrollbar.grid(row=3, column=1, sticky="ns")
        self.file_listbox.configure(yscrollcommand=scrollbar.set)
        
        # Uninstall button
        self.uninstall_btn = tk.Button(
            self, 
            text="Uninstall Selected Package", 
            command=self.uninstall_selected,
            font=("Helvetica", 12),
            bg="#4a90e2", 
            fg="white",
            state="disabled"
        )
        self.uninstall_btn.grid(row=4, column=0, padx=20, pady=(0, 20), sticky="ew")
        
        # Status bar
        self.status_var = tk.StringVar()
        self.status_var.set("Ready")
        self.status_bar = tk.Label(self, textvariable=self.status_var, relief="sunken", anchor="w")
        self.status_bar.grid(row=5, column=0, sticky="ew", padx=20, pady=(0, 10))
        
        # Bind events
        self.drop_frame.bind("<DragEnter>", self.on_drag_enter)
        self.drop_frame.bind("<DragLeave>", self.on_drag_leave)
        self.drop_frame.bind("<Drop>", self.on_drop)
        self.drop_frame.bind("<Button-1>", self.on_click)
        
        # Allow drag and drop
        self.drop_frame.drop_target_register(tk.DND_FILES)
        self.drop_frame.dnd_bind('<<Drop>>', self.on_drop)
        
        # Check if pkgdrop is available
        if not self.is_pkgdrop_available():
            messagebox.showerror("Error", "pkgdrop command not found. Please ensure pkgdrop is installed and in PATH.")
            self.uninstall_btn.config(state="disabled")
            self.status_var.set("pkgdrop not found")
        
        # Load any existing installed packages
        self.load_installed_packages()
    
    def is_pkgdrop_available(self):
        try:
            subprocess.run(["pkgdrop", "--version"], 
                         capture_output=True, 
                         check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False
    
    def load_installed_packages(self):
        try:
            result = subprocess.run(["pkgdrop", "-l"], 
                                  capture_output=True, 
                                  text=True, 
                                  check=True)
            # This is just for informational purposes
            # We'll display installed packages in a separate dialog if needed
        except subprocess.CalledProcessError:
            pass
    
    def on_drag_enter(self, event):
        self.drop_frame.configure(bg="#e0e0e0")
        self.drop_label.configure(text="Drop files here to uninstall")
    
    def on_drag_leave(self, event):
        self.drop_frame.configure(bg="#f0f0f0")
        self.drop_label.configure(text="Drag and drop package files here\nor click to select files")
    
    def on_drop(self, event):
        files = self.tk.splitlist(event.data)
        for file in files:
            if os.path.isfile(file):
                self.add_file(file)
    
    def on_click(self, event):
        self.browse_files()
    
    def browse_files(self):
        files = filedialog.askopenfilenames(
            title="Select package files to uninstall",
            filetypes=[
                ("Package files", "*.AppImage *.tar.xz *.tar.gz *.tar.zst *.tar.bz2 *.deb *.rpm *.pkg.tar.*"),
                ("AppImage files", "*.AppImage"),
                ("Tar files", "*.tar.xz *.tar.gz *.tar.zst *.tar.bz2"),
                ("Debian packages", "*.deb"),
                ("RPM packages", "*.rpm"),
                ("Pacman packages", "*.pkg.tar.*"),
                ("All files", "*.*")
            ]
        )
        
        for file in files:
            self.add_file(file)
    
    def add_file(self, file_path):
        # Get just the filename
        filename = os.path.basename(file_path)
        
        # Check if file already exists in list
        existing_items = self.file_listbox.get(0, tk.END)
        if filename in existing_items:
            return
        
        # Add to listbox
        self.file_listbox.insert(tk.END, filename)
        
        # Enable uninstall button if we have at least one file
        if self.file_listbox.size() > 0:
            self.uninstall_btn.config(state="normal")
        
        # Update status
        self.status_var.set(f"Selected {self.file_listbox.size()} file(s)")
    
    def uninstall_selected(self):
        selected = self.file_listbox.curselection()
        if not selected:
            messagebox.showwarning("No selection", "Please select a package to uninstall.")
            return
        
        # Get selected filename
        filename = self.file_listbox.get(selected[0])
        
        # Ask for confirmation
        if not messagebox.askyesno(
            "Confirm Uninstall", 
            f"Are you sure you want to uninstall {filename}?\n\nThis will remove the package from your system."
        ):
            return
        
        # Disable button during uninstall
        self.uninstall_btn.config(state="disabled")
        self.status_var.set("Uninstalling...")
        self.update()
        
        try:
            # Extract package name from filename (remove extension)
            name = os.path.splitext(filename)[0]
            
            # Run pkgdrop uninstall command
            result = subprocess.run([
                "pkgdrop", "-u", name
            ], 
            capture_output=True, 
            text=True, 
            check=True)
            
            # Success
            messagebox.showinfo("Success", f"Successfully uninstalled {filename}")
            
            # Remove from list
            self.file_listbox.delete(selected[0])
            
            # Update status
            if self.file_listbox.size() == 0:
                self.uninstall_btn.config(state="disabled")
            self.status_var.set(f"Uninstalled {filename} successfully")
            
        except subprocess.CalledProcessError as e:
            error_msg = e.stderr.strip() if e.stderr else str(e)
            messagebox.showerror("Error", f"Failed to uninstall {filename}: {error_msg}")
            self.status_var.set(f"Error: {error_msg}")
        except Exception as e:
            messagebox.showerror("Error", f"Unexpected error: {str(e)}")
            self.status_var.set(f"Error: {str(e)}")
        
        # Re-enable button
        if self.file_listbox.size() > 0:
            self.uninstall_btn.config(state="normal")
        else:
            self.uninstall_btn.config(state="disabled")

if __name__ == "__main__":
    # Check if we're running on a system with GUI
    if not os.environ.get('DISPLAY'):
        print("No display found. Please run this in a graphical environment.")
        sys.exit(1)
    
    # Create and run the application
    app = PkgdropUninstaller()
    app.mainloop()