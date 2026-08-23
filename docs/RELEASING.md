# Publishing LT Panel Bridge

This repository publishes portable Windows ZIP archives through GitHub
Releases. The application does not require `npm install`; Node.js 18 or later
is the only runtime dependency.

## Before publishing

1. Update the version in `package.json` and `README.md`.
2. Add the new version to `CHANGELOG.md`.
3. Run `npm run check`.
4. Start the bridge and verify `http://localhost:4242` locally.
5. Confirm that `config.json`, logs, credentials and Discord webhook URLs are
   not present in the repository or release archive.

## Automated release

1. Commit the tested source files.
2. Create an annotated version tag such as `v1.1.0`.
3. Push the commit and tag to GitHub.
4. The release workflow creates and uploads:
   - `LTPanelBridge.zip`
   - `LTPanelBridge.sha256`
5. Copy the matching release notes from `docs/releases/` into the GitHub
   Release description if needed.

## Release archive contents

The downloadable ZIP contains only the files required by end users:

- `LICENSE`
- `README.md`
- `SECURITY.md`
- `CHANGELOG.md`
- `package.json`
- `server.js`
- `start-lt-panel.bat`
- `public/`

The `.github/`, `docs/` and `tools/` directories are maintainer resources and
are intentionally excluded from the downloadable application.
