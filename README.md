# LT Panel Bridge

Current version: **v1.1.0**

LT Panel Bridge is the local companion application for the LightTune Project
Zomboid mod ecosystem. It reads the state exported by LightTuneLib and provides
the administrator with a browser-based control panel at
`http://localhost:4242`.

> LT Panel Bridge is not a Steam Workshop mod. Do not copy it into
> `Zomboid/mods`. Run it as a separate application on the same Windows account
> that runs Project Zomboid.

## Download

Download the latest packaged build from
[GitHub Releases](https://github.com/Light-Tune/LTPanelBridge/releases/latest).
Use `LTPanelBridge.sha256` if you want to verify the downloaded ZIP.

## Requirements

- Windows 10 or later
- [Node.js](https://nodejs.org/) 18 or later (the current LTS release is recommended)
- LightTuneLib and at least one supported LightTune Workshop mod
- An administrator account in the Project Zomboid server

No `npm install` step is required. The bridge uses only built-in Node.js
modules.

## Installation

1. Download `LTPanelBridge.zip` from the latest GitHub Release.
2. Extract the ZIP to a permanent folder.
3. Install and enable LightTuneLib and the supported LightTune mods in Project
   Zomboid.
4. Sign in to the server with your administrator account.
5. Double-click `start-lt-panel.bat` in the extracted folder.
6. Open `http://localhost:4242` in your browser.
7. In Project Zomboid, open the admin panel and select **LT Settings**. The
   connection indicator in the browser turns green once LightTuneLib starts
   exporting state.

You can also start the bridge from a terminal:

```powershell
node server.js
```

## How it works

LightTuneLib writes local JSON state and command files under:

```text
%UserProfile%\Zomboid\Lua\LightTune\
```

LT Panel Bridge reads and writes only inside that LightTune folder and serves
the web interface on `127.0.0.1`. The panel is therefore reachable only from
the same computer by default. No state is uploaded to LightTune or another
remote service.

The browser panel defaults to English. Use the language selector in the
upper-right corner to switch between English, Turkish, Spanish, Brazilian
Portuguese, Russian and Simplified Chinese. The selection is stored only in
the browser. The panel includes only the sections registered by installed and
active LightTune feature mods.

## Optional Discord webhook

The panel can store a Discord webhook URL for supported notifications. The URL
is saved locally in the LightTune configuration folder. Treat it as a secret:
do not publish it, commit it, or include it in support screenshots.

## Troubleshooting

- **The page does not open:** Confirm that Node.js 18+ is installed and keep the
  command window open while using the panel.
- **The bridge is running but the indicator stays red:** Run Project Zomboid on
  the same Windows account, join as an administrator, enable LightTuneLib, and
  open **LT Settings** in the in-game admin panel.
- **A feature panel is missing:** Make sure its LightTune Workshop mod is
  installed and enabled on both the client and server.
- **Port 4242 is already in use:** Close the other LT Panel Bridge instance, or
  start this one with a different `PORT` environment variable.
- **Old layout still appears:** Refresh the page. If necessary, clear site data
  for `localhost:4242`; panel sizes and positions are stored in the browser.

## Updating

Stop the old bridge, download the newest Release ZIP, extract it over a clean
folder, and run `start-lt-panel.bat` again. Project Zomboid save data is not
stored inside the application folder.

## Building a release

The repository includes `.github/workflows/release.yml`. Pushing a version tag
such as `v1.1.0` builds `LTPanelBridge.zip`, creates a SHA-256 checksum, and
publishes both files to GitHub Releases.

Release preparation and publishing steps are documented in
[`docs/RELEASING.md`](docs/RELEASING.md). Release-specific notes are stored in
[`docs/releases/`](docs/releases/).

## Repository structure

```text
LTPanelBridge/
├─ .github/workflows/   GitHub Actions release automation
├─ docs/                Maintainer and release documentation
├─ public/              Browser panel and interface translations
├─ tools/               Maintainer-only helper scripts
├─ server.js            Local bridge server
└─ start-lt-panel.bat   Windows launcher
```

## Security

See [SECURITY.md](SECURITY.md) for the supported version and private reporting
guidance.

## License

LT Panel Bridge is released under the [MIT License](LICENSE).
