# Testing

## Local release verification

Verified on 2026-08-16 with Omarchy 4.0.0:

- `omarchy plugin validate` passes for the repository root.
- `qmllint` passes with the installed Omarchy Shell import path.
- `bash -n` passes for all shell entry points.
- `start-mpvpaper.sh --check` resolves an isolated Waypaper fixture without
  starting a renderer.
- `omarchy plugin add file://... --yes` clones the repository into an isolated
  HOME using the permanent manifest ID.
- The installed checkout has the same commit as its source, the expected Git
  origin, and a clean worktree.
- `omarchy plugin update <id> --yes` recognizes the clone as up to date.
- `omarchy plugin remove <id> --yes` removes the isolated Git checkout.
- A clean reinstall succeeds after removal and does not create `shell.json`.

The install lifecycle uses a test-only `omarchy-shell` stub so the live user
shell is neither rescanned nor reconfigured.

## Manual release matrix

Complete these checks before the public `v1.0.0` release:

- [x] Existing local Waypaper configuration resolves successfully.
- [x] Manifest, QML, and shell syntax validation.
- [x] Isolated Git add, update, remove, and reinstall lifecycle.
- [ ] Install from the final public GitHub URL.
- [ ] Enable on a second Omarchy Quattro user or machine.
- [ ] Select videos with `fit`, `fill`, sound off, and sound on.
- [ ] Test one monitor and a multi-monitor setup.
- [ ] Confirm pause, resume, restart, shell restart, disable, and rollback.
- [ ] Review marketplace automated validation and security-baseline results.
