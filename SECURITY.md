# Security policy

## Supported versions

Only the latest release on the default branch is supported.

## Reporting a vulnerability

Do not open a public issue for a suspected vulnerability. Use GitHub's private
security advisory form for this repository after it is published.

Include the affected version, impact, reproduction steps, and any suggested
mitigation. Please avoid including personal configuration, credentials, or
private video paths.

## Trust boundary

Omarchy plugins run unsandboxed with the current user's permissions. This
plugin reads Waypaper configuration, starts and controls mpvpaper, and removes
only the Waypaper IPC socket selected for the configured monitor. It does not
request elevated privileges or download and execute remote code.
