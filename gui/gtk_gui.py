#!/usr/bin/env python3
import gi
import subprocess
import os
import sys
from pathlib import Path

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GLib

class PkgdropGUI(Gtk.Window):
    def __init__(self):
        super().__init__(title="pkgdrop GUI")
        self.set_default_size(600, 400)
        self.set_border_width(10)
        
        # Create main container
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(main_box)
        
        # Title
        title_label = Gtk.Label()
        title_label.set_markup("<big><b>pkgdrop GUI</b></big>")
        main_box.pack_start(title_label, False, False, 0)
        
        # Description
        desc_label = Gtk.Label(label="Manage your installed packages")
        main_box.pack_start(desc_label, False, False, 0)
        
        # Uninstall button
        self.uninstall_btn = Gtk.Button(label="Uninstall Package")
        self.uninstall_btn.connect("clicked", self.on_uninstall_clicked)
        main_box.pack_start(self.uninstall_btn, False, False, 0)
        
        # Installed packages section
        packages_label = Gtk.Label(label="Installed Packages:")
        main_box.pack_start(packages_label, False, False, 0)
        
        # Scrollable list of packages
        self.scrolled_window = Gtk.ScrolledWindow()
        self.scrolled_window.set_border_width(5)
        self.scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        main_box.pack_start(self.scrolled_window, True, True, 0)
        
        # Package list store
        self.list_store = Gtk.ListStore(str)
        self.tree_view = Gtk.TreeView(model=self.list_store)
        
        renderer = Gtk.CellRendererText()
        column = Gtk.TreeViewColumn("Package", renderer, text=0)
        self.tree_view.append_column(column)
        
        self.scrolled_window.add(self.tree_view)
        
        # Load installed packages
        self.load_installed_packages()
        
        # Window properties
        self.connect("destroy", Gtk.main_quit)
        
    def load_installed_packages(self):
        """Load installed packages from pkgdrop -l command"""
        self.list_store.clear()
        
        try:
            # Run pkgdrop -l to get installed packages
            result = subprocess.run(['pkgdrop', '-l'], 
                                  capture_output=True, 
                                  text=True, 
                                  check=True)
            
            # Parse output to extract package names
            lines = result.stdout.split('\n')
            packages = []
            
            for line in lines:
                # Look for lines with package names (format: "package v1.0.0 (type)")
                if '(' in line and ')' in line:
                    # Extract package name before the version info
                    parts = line.split(' ', 1)
                    if parts and parts[0]:
                        package_name = parts[0]
                        if package_name not in packages:
                            packages.append(package_name)
                
                # Also look for lines with just package names (format: "package (size)")
                elif '(' in line and ')' in line and 'v' not in line:
                    parts = line.split(' ', 1)
                    if parts and parts[0]:
                        package_name = parts[0]
                        if package_name not in packages:
                            packages.append(package_name)
            
            # Add packages to the list
            for pkg in packages:
                self.list_store.append([pkg])
                
        except subprocess.CalledProcessError:
            # If pkgdrop command fails, show a message
            self.list_store.append(["Could not load packages (pkgdrop not found or error)"])
        except Exception as e:
            self.list_store.append([f"Error loading packages: {str(e)}"])
    
    def on_uninstall_clicked(self, widget):
        """Handle uninstall button click"""
        # Get selected package from tree view
        selection = self.tree_view.get_selection()
        model, treeiter = selection.get_selected()
        
        if treeiter is not None:
            package_name = model[treeiter][0]
            
            # Confirm uninstall
            dialog = Gtk.MessageDialog(
                parent=self,
                flags=0,
                message_type=Gtk.MessageType.QUESTION,
                buttons=Gtk.ButtonsType.YES_NO,
                text=f"Uninstall {package_name}?"
            )
            dialog.format_secondary_text(f"This will remove {package_name} from your system.")
            response = dialog.run()
            dialog.destroy()
            
            if response == Gtk.ResponseType.YES:
                try:
                    # Run pkgdrop -u command
                    result = subprocess.run(['pkgdrop', '-u', package_name], 
                                          capture_output=True, 
                                          text=True, 
                                          check=True)
                    
                    # Show success message
                    success_dialog = Gtk.MessageDialog(
                        parent=self,
                        flags=0,
                        message_type=Gtk.MessageType.INFO,
                        buttons=Gtk.ButtonsType.OK,
                        text="Uninstallation successful"
                    )
                    success_dialog.format_secondary_text(f"{package_name} has been uninstalled.")
                    success_dialog.run()
                    success_dialog.destroy()
                    
                    # Refresh package list
                    self.load_installed_packages()
                    
                except subprocess.CalledProcessError as e:
                    # Show error message
                    error_dialog = Gtk.MessageDialog(
                        parent=self,
                        flags=0,
                        message_type=Gtk.MessageType.ERROR,
                        buttons=Gtk.ButtonsType.OK,
                        text="Uninstallation failed"
                    )
                    error_dialog.format_secondary_text(f"Error: {e.stderr}")
                    error_dialog.run()
                    error_dialog.destroy()
        
        else:
            # No package selected
            dialog = Gtk.MessageDialog(
                parent=self,
                flags=0,
                message_type=Gtk.MessageType.WARNING,
                buttons=Gtk.ButtonsType.OK,
                text="No package selected"
            )
            dialog.format_secondary_text("Please select a package from the list to uninstall.")
            dialog.run()
            dialog.destroy()

# Main application
if __name__ == "__main__":
    # Check if pkgdrop is available
    try:
        subprocess.run(['pkgdrop', '--version'], 
                      capture_output=True, 
                      check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        # Show error dialog if pkgdrop is not available
        dialog = Gtk.MessageDialog(
            None,
            0,
            Gtk.MessageType.ERROR,
            Gtk.ButtonsType.OK,
            "pkgdrop not found"
        )
        dialog.format_secondary_text("pkgdrop command-line tool is required for this GUI to work.\nPlease ensure pkgdrop is installed and available in your PATH.")
        dialog.run()
        dialog.destroy()
        sys.exit(1)
    
    # Create and show window
    app = PkgdropGUI()
    app.show_all()
    Gtk.main()