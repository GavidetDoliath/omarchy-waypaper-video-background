# Marketplace submission draft

Do not submit this draft until the repository is public, the preview has been
reviewed, and the owner has explicitly confirmed every checklist item.

## Proposed listing

- Repository: `https://github.com/GavidetDoliath/omarchy-waypaper-video-background`
- Category: `Appearance`
- Tags: `media`, `quickshell`, `hyprland`
- Suggested missing tag: `wallpaper`
- Title: `[Plugin]: Waypaper Video`

## Issue body

```markdown
### Repository URL

https://github.com/GavidetDoliath/omarchy-waypaper-video-background

### Category

Appearance

### Tags

media, quickshell, hyprland

### Suggest a missing tag

wallpaper

### Maintainer notes

Waypaper is the graphical video picker. The Omarchy Quattro service supervises
its mpvpaper backend and provides lifecycle and pause/resume IPC controls.

### Submission checklist
- [ ] The repository is public and contains installation and removal instructions.
- [ ] I have documented the plugin license and any external dependencies.
- [ ] I confirm that I own or have permission to submit this plugin and its preview assets.
- [ ] The plugin does not overwrite user configuration without explicit consent.
- [ ] I understand that approval is for listing and is not a security review.
```

Check all five boxes only after the owner confirms them, then create the issue:

```sh
gh issue create \
  --repo HANCORE-linux/omarchy-plugin-marketplace \
  --title "[Plugin]: Waypaper Video" \
  --body-file /tmp/omarchy-plugin-submission.md
```
