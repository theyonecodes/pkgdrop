# Sprint Backlog

## Sprint 1: Core Installation System (2025-01-09 to 2025-01-16)

### Goal
Implement core installation logic and basic CLI usage

### Story Points: 8

### Tasks

#### Phase 1: Foundation (2 pts)
- [ ] Create project structure (docs, src, deploy folders)
- [ ] Set up README.md with project overview
- [ ] Add license file (MIT)
- [ ] Add CHANGELOG.md

#### Phase 2: Basic Script (3 pts)
- [ ] Create pkgdrop script skeleton
- [ ] Implement file type detection function (extension + magic bytes)
- [ ] Add logging/debug mode support
- [ ] Add help/usage output

#### Phase 3: Package Handlers (3 pts)
- [ ] Implement pacman handler (pacman -U)
- [ ] Implement tar.xz handler (extract + symlink)
- [ ] Implement .deb handler (debtap wrapper)
- [ ] Implement AppImage handler (move to bin)
- [ ] Add error handling for each handler

### Daily Standup Notes
**Day 1 (Jan 9):** Project structure created, starting script skeleton  
**Day 2 (Jan 10):** Type detection working, pacman handler in progress  
**Day 3 (Jan 11):** All handlers implemented, testing begins  
**Day 4 (Jan 12):** Bug fixes, documentation updates  
**Day 5 (Jan 13):** Final testing, release preparation  

### Definer
- Project Manager: theyonecodes
- Start Date: 2025-01-09
- End Date: 2025-01-16
- Status: PLANNING