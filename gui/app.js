let packages = [];
let currentView = 'dashboard';

const elements = {
    pageTitle: document.getElementById('pageTitle'),
    searchInput: document.getElementById('searchInput'),
    refreshBtn: document.getElementById('refreshBtn'),
    totalPackages: document.getElementById('totalPackages'),
    appimages: document.getElementById('appimages'),
    tarportables: document.getElementById('tarportables'),
    issues: document.getElementById('issues'),
    dashboardPackageList: document.getElementById('dashboardPackageList'),
    packagesTableBody: document.getElementById('packagesTableBody'),
    logContent: document.getElementById('logContent'),
    auditResults: document.getElementById('auditResults'),
    toastContainer: document.getElementById('toastContainer'),
    statusDot: document.getElementById('statusDot'),
    statusText: document.getElementById('statusText'),
    dropZone: document.getElementById('dropZone'),
    fileInput: document.getElementById('fileInput'),
    uninstallModal: document.getElementById('uninstallModal'),
    uninstallMessage: document.getElementById('uninstallMessage'),
};

async function loadPackages() {
    try {
        packages = await window.pkgdrop.listPackages();
        updateDashboard();
        updatePackagesTable();
        checkStatus();
    } catch (error) {
        showToast('error', 'Failed to load packages: ' + error.message);
    }
}

function updateDashboard() {
    elements.totalPackages.textContent = packages.length;
    elements.appimages.textContent = packages.filter(p => p.type === 'appimage').length;
    elements.tarportables.textContent = packages.filter(p => p.type === 'tarportable').length;

    const searchTerm = elements.searchInput.value.toLowerCase();
    const filtered = packages.filter(p =>
        p.name.toLowerCase().includes(searchTerm)
    );

    if (filtered.length === 0) {
        elements.dashboardPackageList.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-box-open"></i>
                <p>No packages found</p>
            </div>
        `;
        return;
    }

    elements.dashboardPackageList.innerHTML = filtered.slice(0, 10).map(pkg => `
        <div class="package-item">
            <div class="package-info">
                <div class="package-icon">
                    <i class="fas fa-box"></i>
                </div>
                <div class="package-details">
                    <h4>${escapeHtml(pkg.name)}</h4>
                    <span>v${escapeHtml(pkg.version)} - ${pkg.type}</span>
                </div>
            </div>
            <div class="package-actions">
                <button class="btn secondary" onclick="viewPackage('${escapeHtml(pkg.name)}')">
                    <i class="fas fa-eye"></i> Info
                </button>
                <button class="btn danger" onclick="showUninstallModal('${escapeHtml(pkg.name)}')">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        </div>
    `).join('');
}

function updatePackagesTable() {
    const searchTerm = elements.searchInput.value.toLowerCase();
    const typeFilter = document.getElementById('typeFilter')?.value || '';
    const sourceFilter = document.getElementById('sourceFilter')?.value || '';

    let filtered = packages.filter(p =>
        p.name.toLowerCase().includes(searchTerm)
    );

    if (typeFilter) {
        filtered = filtered.filter(p => p.type === typeFilter);
    }
    if (sourceFilter) {
        filtered = filtered.filter(p => p.source === sourceFilter);
    }

    elements.packagesTableBody.innerHTML = filtered.map(pkg => `
        <tr>
            <td>
                <div class="package-details">
                    <h4>${escapeHtml(pkg.name)}</h4>
                </div>
            </td>
            <td>v${escapeHtml(pkg.version)}</td>
            <td><span class="type-badge ${pkg.type}">${pkg.type}</span></td>
            <td>${pkg.source}</td>
            <td>
                <div class="package-actions">
                    <button class="btn secondary" onclick="viewPackage('${escapeHtml(pkg.name)}')">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn danger" onclick="showUninstallModal('${escapeHtml(pkg.name)}')">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

async function viewPackage(name) {
    const result = await window.pkgdrop.getPackageInfo(name);
    if (result.success) {
        showToast('info', result.output.substring(0, 500));
    } else {
        showToast('error', result.error);
    }
}

function showUninstallModal(name) {
    elements.uninstallMessage.textContent = `Are you sure you want to uninstall "${name}"? This action cannot be undone.`;
    elements.uninstallModal.classList.add('active');
    elements.uninstallModal.dataset.package = name;
}

async function uninstallPackage(name) {
    const result = await window.pkgdrop.uninstallPackage(name);
    elements.uninstallModal.classList.remove('active');

    if (result.success) {
        showToast('success', `Successfully uninstalled ${name}`);
        loadPackages();
    } else {
        showToast('error', `Failed to uninstall: ${result.error}`);
    }
}

async function runAudit() {
    elements.auditResults.innerHTML = '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Running audit...</div>';
    document.getElementById('pruneBtn').disabled = true;

    const result = await window.pkgdrop.runAudit();

    if (result.success) {
        elements.auditResults.innerHTML = `<pre>${escapeHtml(result.output)}</pre>`;
        document.getElementById('pruneBtn').disabled = false;

        const issuesMatch = result.output.match(/Total issues: (\d+)/);
        elements.issues.textContent = issuesMatch ? issuesMatch[1] : '0';
    } else {
        elements.auditResults.innerHTML = `<div class="empty-state"><i class="fas fa-exclamation-triangle"></i><p>${escapeHtml(result.error)}</p></div>`;
    }
}

async function pruneAudit() {
    if (!confirm('This will remove all orphaned entries. Continue?')) return;

    const result = await window.pkgdrop.pruneAudit();

    if (result.success) {
        showToast('success', 'Prune completed');
        runAudit();
    } else {
        showToast('error', `Prune failed: ${result.error}`);
    }
}

async function cleanBroken() {
    const result = await window.pkgdrop.cleanBroken();

    if (result.success) {
        showToast('success', 'Clean completed');
        loadPackages();
    } else {
        showToast('error', `Clean failed: ${result.error}`);
    }
}

async function installFiles(files) {
    elements.logContent.textContent = '';

    for (const file of files) {
        log(`Installing ${file.name}...`);

        const options = {
            extract: document.getElementById('extractMode')?.checked,
            force: document.getElementById('forceInstall')?.checked,
            yes: document.getElementById('yesToAll')?.checked
        };

        const result = await window.pkgdrop.installPackage(file.path, options);

        if (result.success) {
            log(`Success: ${file.name}`);
            showToast('success', `${file.name} installed`);
        } else {
            log(`Failed: ${result.error}`);
            showToast('error', `Failed to install ${file.name}`);
        }
    }

    loadPackages();
}

function log(message) {
    elements.logContent.textContent += message + '\n';
    elements.logContent.scrollTop = elements.logContent.scrollHeight;
}

function showToast(type, message) {
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    const icon = type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : type === 'warning' ? 'exclamation-triangle' : 'info-circle';
    toast.innerHTML = `<i class="fas fa-${icon}"></i><span>${escapeHtml(message)}</span>`;
    elements.toastContainer.appendChild(toast);
    setTimeout(() => toast.remove(), 5000);
}

function switchView(viewName) {
    document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));

    document.getElementById(`${viewName}View`)?.classList.add('active');
    document.querySelector(`[data-view="${viewName}"]`)?.classList.add('active');

    elements.pageTitle.textContent = viewName.charAt(0).toUpperCase() + viewName.slice(1);
    currentView = viewName;
}

function checkStatus() {
    window.pkgdrop.listPackages().then(result => {
        elements.statusDot.className = 'fas fa-circle';
        elements.statusDot.style.color = 'var(--success)';
        elements.statusText.textContent = 'pkgdrop online';
    }).catch(() => {
        elements.statusDot.className = 'fas fa-circle offline';
        elements.statusDot.style.color = 'var(--danger)';
        elements.statusText.textContent = 'pkgdrop offline';
    });
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

document.addEventListener('DOMContentLoaded', () => {
    loadPackages();

    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', () => switchView(item.dataset.view));
    });

    elements.refreshBtn.addEventListener('click', loadPackages);

    elements.searchInput.addEventListener('input', () => {
        if (currentView === 'dashboard') updateDashboard();
        if (currentView === 'packages') updatePackagesTable();
    });

    document.getElementById('typeFilter')?.addEventListener('change', updatePackagesTable);
    document.getElementById('sourceFilter')?.addEventListener('change', updatePackagesTable);

    document.getElementById('installBtn')?.addEventListener('click', () => switchView('install'));
    document.getElementById('runAuditBtn')?.addEventListener('click', runAudit);
    document.getElementById('runAuditBtn2')?.addEventListener('click', runAudit);
    document.getElementById('pruneBtn')?.addEventListener('click', pruneAudit);
    document.getElementById('cleanBtn')?.addEventListener('click', cleanBroken);

    elements.dropZone.addEventListener('click', () => elements.fileInput.click());
    elements.dropZone.addEventListener('dragover', e => {
        e.preventDefault();
        elements.dropZone.classList.add('dragover');
    });
    elements.dropZone.addEventListener('dragleave', () => {
        elements.dropZone.classList.remove('dragover');
    });
    elements.dropZone.addEventListener('drop', e => {
        e.preventDefault();
        elements.dropZone.classList.remove('dragover');
        installFiles(e.dataTransfer.files);
    });
    elements.fileInput.addEventListener('change', e => {
        installFiles(e.target.files);
        e.target.value = '';
    });

    document.getElementById('cancelUninstall')?.addEventListener('click', () => {
        elements.uninstallModal.classList.remove('active');
    });
    document.getElementById('confirmUninstall')?.addEventListener('click', () => {
        uninstallPackage(elements.uninstallModal.dataset.package);
    });

    setInterval(checkStatus, 30000);
});

window.viewPackage = viewPackage;
window.showUninstallModal = showUninstallModal;