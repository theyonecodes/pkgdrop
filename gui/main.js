const { app, BrowserWindow, Menu, dialog, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');

let mainWindow;

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 1200,
        height: 800,
        minWidth: 900,
        minHeight: 600,
        backgroundColor: '#0f0f14',
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            preload: path.join(__dirname, 'preload.js')
        },
        icon: path.join(__dirname, 'icon.png'),
        titleBarStyle: 'default',
        show: false
    });

    mainWindow.loadFile(path.join(__dirname, 'index.html'));

    mainWindow.once('ready-to-show', () => {
        mainWindow.show();
    });

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
}

app.whenReady().then(() => {
    createWindow();

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow();
        }
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

const template = [
    {
        label: 'File',
        submenu: [
            {
                label: 'Install Package...',
                accelerator: 'CmdOrCtrl+O',
                click: async () => {
                    const result = await dialog.showOpenDialog(mainWindow, {
                        properties: ['openFile', 'multiSelections'],
                        filters: [
                            { name: 'Packages', extensions: ['AppImage', 'tar.xz', 'tar.gz', 'tar.zst', 'tar.bz2', 'deb', 'rpm', 'pkg.tar.zst', 'pkg.tar.xz'] },
                            { name: 'All Files', extensions: ['*'] }
                        ]
                    });
                    if (!result.canceled && result.filePaths.length > 0) {
                        mainWindow.webContents.send('files-selected', result.filePaths);
                    }
                }
            },
            { type: 'separator' },
            {
                label: 'Exit',
                accelerator: 'CmdOrCtrl+Q',
                click: () => app.quit()
            }
        ]
    },
    {
        label: 'View',
        submenu: [
            { label: 'Reload', accelerator: 'CmdOrCtrl+R', click: () => mainWindow.reload() },
            { label: 'Toggle DevTools', accelerator: 'F12', click: () => mainWindow.webContents.toggleDevTools() },
            { type: 'separator' },
            { label: 'Zoom In', accelerator: 'CmdOrCtrl+Plus', click: () => mainWindow.webContents.setZoomLevel(mainWindow.webContents.getZoomLevel() + 0.5) },
            { label: 'Zoom Out', accelerator: 'CmdOrCtrl+-', click: () => mainWindow.webContents.setZoomLevel(mainWindow.webContents.getZoomLevel() - 0.5) },
            { label: 'Reset Zoom', accelerator: 'CmdOrCtrl+0', click: () => mainWindow.webContents.setZoomLevel(0) }
        ]
    },
    {
        label: 'Tools',
        submenu: [
            {
                label: 'Run System Audit',
                accelerator: 'CmdOrCtrl+A',
                click: () => mainWindow.webContents.send('run-audit')
            },
            {
                label: 'Clean Broken Symlinks',
                click: () => mainWindow.webContents.send('clean-broken')
            },
            { type: 'separator' },
            {
                label: 'Refresh Package List',
                accelerator: 'F5',
                click: () => mainWindow.webContents.send('refresh-packages')
            }
        ]
    },
    {
        label: 'Help',
        submenu: [
            {
                label: 'About pkgdrop',
                click: () => {
                    dialog.showMessageBox(mainWindow, {
                        type: 'info',
                        title: 'About pkgdrop',
                        message: 'pkgdrop - Universal Package Installer',
                        detail: 'Version 3.0.0\n\nA universal package installer for Arch Linux.\n\nSupports: AppImage, tar.xz, .deb, .rpm, pacman packages'
                    });
                }
            }
        ]
    }
];

const menu = Menu.buildFromTemplate(template);
Menu.setApplicationMenu(menu);

ipcMain.handle('select-file', async () => {
    const result = await dialog.showOpenDialog(mainWindow, {
        properties: ['openFile', 'multiSelections'],
        filters: [
            { name: 'Packages', extensions: ['AppImage', 'tar.xz', 'tar.gz', 'tar.zst', 'tar.bz2', 'deb', 'rpm', 'pkg.tar.zst', 'pkg.tar.xz'] }
        ]
    });
    return result.canceled ? [] : result.filePaths;
});

ipcMain.handle('show-message', async (event, options) => {
    return dialog.showMessageBox(mainWindow, options);
});

ipcMain.handle('show-error', async (event, title, message) => {
    dialog.showErrorBox(title, message);
});