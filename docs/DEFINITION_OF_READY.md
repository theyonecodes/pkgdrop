# pkgdrop - Definition of Ready (DoR)

A task is **Ready** to be worked on when ALL of the following are true:

## Story Ready
- [ ] User story is written (As a / I want / So that)
- [ ] Acceptance criteria are defined
- [ ] Edge cases identified
- [ ] Dependencies identified (if any)

## Technical Ready
- [ ] Task is broken into steps (in index.html or TODO.md)
- [ ] Affected files identified
- [ ] Testing approach defined
- [ ] No blockers remain

## Environment Ready
- [ ] Previous task is Done
- [ ] CI is green on main
- [ ] No merge conflicts
- [ ] Local environment is clean

## Ready Checklist
```
Before starting any task, verify:
1. I understand what "done" looks like
2. I know which files to change
3. I know how to test it
4. I know what could go wrong
5. I have no blockers
```

## Blocked Task
A task is **Blocked** when:
- Depends on another task not yet done
- Requires external resource (API, key, permission)
- Unknown error that needs investigation
- Decision needed from product owner

**Action:** Add comment explaining blocker, move to Blocked column.
