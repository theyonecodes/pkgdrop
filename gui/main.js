const { app, BrowserWindow, Menu, dialog } = require('electron');
const path = require('path');
const { exec } = require('child_process');

function createWindow () {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    },
    icon: path.join(__dirname, 'icon.png')
  });

  win.loadFile('index.html');
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

// Create menu
const template = [
  {
    label: 'File',
    submenu: [
      { label: 'Exit', accelerator: 'CmdOrCtrl+Q', click: () => app.quit() }
    ]
  },
  {
    label: 'Tools',
    submenu: [
      {
        label: 'Uninstall Package',
        click: () => {
          dialog.showOpenDialog({
            properties: ['openDirectory'],
            title: 'Select package to uninstall'
          }).then(result => {
            if (!result.canceled && result.filePaths.length > 0) {
              const dir = result.filePaths[0];
              const packageName = path.basename(dir);
              exec(`pkgdrop -u ${packageName}`, (error, stdout, stderr) => {
                if (error) {
                  dialog.showErrorBox('Error', `Failed to uninstall ${packageName}: ${error.message}`);
                } else {
                  dialog.showMessageBox({
                    type: 'info',
                    message: `Successfully uninstalled ${packageName}`
                  });
                }
              });
            }
          });
        }
      }
    ]
  }
];

const menu = Menu.buildFromTemplate(template);
Menu.setApplicationMenu(menu);