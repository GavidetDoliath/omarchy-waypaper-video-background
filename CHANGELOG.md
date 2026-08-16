# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-08-16

### Added

- Optional, reversible integration with Omarchy's `Super+Ctrl+Space`
  background selector.
- Mixed theme-image and Waypaper-video discovery with cached filmstrip video
  thumbnails.
- Persistent media selection through Waypaper while keeping still-image lock
  backgrounds synchronized with Omarchy.

## [1.0.1] - 2026-08-16

### Changed

- Shortened the public display name from `Waypaper Video Background` to
  `Waypaper Video` while keeping the repository, plugin ID, and IPC target
  stable.

## [1.0.0] - 2026-08-16

### Added

- Omarchy Quattro service supervision for Waypaper's mpvpaper backend.
- Capped exponential restart backoff after unexpected renderer failures.
- IPC commands for status, lifecycle, pause/resume, and opening Waypaper.
- Configuration validation that does not start the renderer.
- English and French installation, rollback, security, and troubleshooting
  documentation.
