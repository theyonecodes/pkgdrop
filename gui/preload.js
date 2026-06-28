const { ipcRenderer, shell } = require('electron');
const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');

window.pkgdrop = {
    listPackages: () => {
        return new Promise((resolve, reject) => {
            exec('pkgdrop -l 2>/dev/null', (error, stdout, stderr) => {
                if (error) {
                    resolve([]);
                    return;
                }

                const packages = [];
                const lines = stdout.split('\n');
                let inRegistry = false;
                let inFilesystem = false;

                for (const line of lines) {
                    const trimmed = line.trim();

                    if (trimmed.includes('Installed packages (registry):')) {
                        inRegistry = true;
                        inFilesystem = false;
                        continue;
                    }
                    if (trimmed.includes('Installed packages (filesystem):')) {
                        inRegistry = false;
                        inFilesystem = true;
                        continue;
                    }
                    if (trimmed.startsWith('Installed packages')) {
                        inRegistry = false;
                        inFilesystem = false;
                        continue;
                    }

                    if ((inRegistry || inFilesystem) && trimmed.includes('v') && trimmed.includes('(')) {
                        for (const type of ['appimage', 'tarportable', 'appimage-extract', 'debtap', 'alien', 'pacman']) {
                            if (trimmed.includes(`(${type})`)) {
                                const parts = trimmed.rsplit(' v', 1);
                                if (parts.length === 2) {
                                    const name = parts[0].trim();
                                    const verWithType = parts[1];
                                    const version = verWithType.split('(')[0].trim().replace(/\.$/, '');
                                    packages.push({
                                        name,
                                        version,
                                        type,
                                        source: inRegistry ? 'registry' : 'filesystem'
                                    });
                                }
                                break;
                            }
                        }
                    }
                }

                resolve(packages);
            });
        });
    },

    installPackage: (filePath, options = {}) => {
        return new Promise((resolve, reject) => {
            let cmd = 'pkgdrop';
            if (options.extract) cmd += ' --extract';
            if (options.force) cmd += ' --force';
            if (options.yes) cmd += ' --yes';
            cmd += ` "${filePath}"`;

            exec(cmd, { timeout: 300000 }, (error, stdout, stderr) => {
                resolve({
                    success: !error,
                    output: stdout,
                    error: stderr || error?.message
                });
            });
        });
    },

    uninstallPackage: (name) => {
        return new Promise((resolve, reject) => {
            exec(`pkgdrop -u "${name}" -y 2>&1`, (error, stdout, stderr) => {
                resolve({
                    success: !error,
                    output: stdout,
                    error: stderr
                });
            });
        });
    },

    runAudit: () => {
        return new Promise((resolve, reject) => {
            exec('pkgdrop -a 2>&1', { timeout: 60000 }, (error, stdout, stderr) => {
                resolve({
                    success: !error,
                    output: stdout,
                    error: stderr
                });
            });
        });
    },

    pruneAudit: () => {
        return new Promise((resolve, reject) => {
            exec('pkgdrop -a --prune 2>&1', { timeout: 120000 }, (error, stdout, stderr) => {
                resolve({
                    success: !error,
                    output: stdout,
                    error: stderr
                });
            });
        });
    },

    cleanBroken: () => {
        return new Promise((resolve, reject) => {
            exec('pkgdrop -c 2>&1', (error, stdout, stderr) => {
                resolve({
                    success: !error,
                    output: stdout,
                    error: stderr
                });
            });
        });
    },

    getPackageInfo: (name) => {
        return new Promise((resolve, reject) => {
            exec(`pkgdrop -i "${name}" 2>&1`, (error, stdout, stderr) => {
                resolve({
                    success: !error,
                    output: stdout,
                    error: stderr
                });
            });
        });
    },

    selectFile: () => {
        return new Promise((resolve) => {
            ipcRenderer.invoke('select-file').then(result => {
                resolve(result);
            }).catch(() => resolve(null));
        });
    },

    showItemInFolder: (filePath) => {
        shell.showItemInFolder(filePath);
    }
};