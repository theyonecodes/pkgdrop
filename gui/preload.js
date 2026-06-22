const { ipcRenderer, shell } = require('electron');
const { exec } = require('child_process');

// Expose functions to the renderer process
window.api = {
  // List installed packages
  listPackages: () => {
    return new Promise((resolve, reject) => {
      exec('pkgdrop -l', (error, stdout, stderr) => {
        if (error) {
          reject(error);
          return;
        }
        
        // Parse the output to extract package names
        const lines = stdout.split('\n');
        const packages = [];
        
        for (const line of lines) {
          // Look for lines with package names (format: "package v1.0.0 (type)")
          const match = line.match(/^([a-zA-Z0-9\-_.]+)(\s+v[0-9.]+)?\s*\(([a-zA-Z]+)\)/);
          if (match) {
            packages.push(match[1]);
          }
          
          // Also look for lines with just package names (format: "package (size)")
          const simpleMatch = line.match(/^([a-zA-Z0-9\-_.]+)\s*\(/);
          if (simpleMatch && !match) {
            packages.push(simpleMatch[1]);
          }
        }
        
        resolve(packages);
      });
    });
  },
  
  // Uninstall package
  uninstallPackage: (packageName) => {
    return new Promise((resolve, reject) => {
      exec(`pkgdrop -u ${packageName}`, (error, stdout, stderr) => {
        if (error) {
          reject(error);
          return;
        }
        resolve(stdout);
      });
    });
  },
  
  // Show file dialog
  showDialog: () => {
    return ipcRenderer.invoke('show-file-dialog');
  },
  
  // Update package list
  updatePackageList: () => {
    return ipcRenderer.invoke('list-packages');
  }
};