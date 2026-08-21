// LT Panel Bridge - local companion web server for the LightTune mod suite.
//
// This is NOT a Steam Workshop mod and must not be copied into a PZ mods
// folder. It runs as a separate process on the admin's own PC, reads the
// state files LightTuneLib writes to the game's Lua sandbox folder, and
// serves the browser dashboard at http://localhost:4242.
//
// No npm install needed - only Node's built-in modules are used.

const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');
const os = require('os');

const PORT = 4242;
const LT_ROOT = path.join(os.homedir(), 'Zomboid', 'Lua', 'LightTune');
const STATE_DIR = path.join(LT_ROOT, 'state');
const CMD_DIR = path.join(LT_ROOT, 'cmd');
const PUBLIC_DIR = path.join(__dirname, 'public');
// Bridge-only settings (Discord webhook URL etc.) - lives next to server.js,
// never touches the game/Lua side. Distinct from STATE_DIR/CMD_DIR, which
// are the file-IPC channels shared with the PZ client.
const CONFIG_PATH = path.join(__dirname, 'config.json');

// Matches LightTune.registerCommandPoller's naming: only simple
// alphanumeric/underscore command names are allowed, so this can never be
// used to write outside CMD_DIR via a crafted URL.
const COMMAND_NAME_RE = /^[a-zA-Z0-9_]+$/;

const MIME_TYPES = {
    '.html': 'text/html; charset=utf-8',
    '.js': 'text/javascript; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
};

function readStateFile(name) {
    const filePath = path.join(STATE_DIR, name + '.json');
    try {
        const raw = fs.readFileSync(filePath, 'utf8');
        if (!raw.trim()) return null;
        return JSON.parse(raw);
    } catch (err) {
        if (err.code !== 'ENOENT') {
            console.error(`LT Panel Bridge: state/${name}.json okunamadi:`, err.message);
        }
        return null;
    }
}

function writeCommandFile(name, data) {
    fs.mkdirSync(CMD_DIR, { recursive: true });
    fs.writeFileSync(path.join(CMD_DIR, name + '.json'), JSON.stringify(data));
}

function readConfig() {
    try {
        const raw = fs.readFileSync(CONFIG_PATH, 'utf8');
        if (!raw.trim()) return {};
        return JSON.parse(raw);
    } catch (err) {
        return {};
    }
}

function writeConfig(data) {
    fs.writeFileSync(CONFIG_PATH, JSON.stringify(data));
}

const DISCORD_WEBHOOK_RE = /^https:\/\/(discord\.com|discordapp\.com)\/api\/webhooks\/\d+\/[A-Za-z0-9_-]+$/;

function sendDiscordMessage(webhookUrl, content) {
    return new Promise((resolve, reject) => {
        const body = JSON.stringify({ content });
        const url = new URL(webhookUrl);
        const req = https.request({
            hostname: url.hostname,
            path: url.pathname + url.search,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(body),
            },
        }, (res) => {
            res.on('data', () => {});
            res.on('end', () => {
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    resolve();
                } else {
                    reject(new Error('Discord ' + res.statusCode));
                }
            });
        });
        req.on('error', reject);
        req.write(body);
        req.end();
    });
}

function readJsonBody(req) {
    return new Promise((resolve, reject) => {
        let body = '';
        req.on('data', (chunk) => {
            body += chunk;
            if (body.length > 1e6) req.destroy(); // guard against a runaway body
        });
        req.on('end', () => {
            if (!body.trim()) return resolve({});
            try {
                resolve(JSON.parse(body));
            } catch (err) {
                reject(err);
            }
        });
        req.on('error', reject);
    });
}

function sendJson(res, status, data) {
    const body = JSON.stringify(data);
    res.writeHead(status, {
        'Content-Type': 'application/json; charset=utf-8',
        'Content-Length': Buffer.byteLength(body),
    });
    res.end(body);
}

function serveStatic(req, res, urlPath) {
    const relPath = urlPath === '/' ? '/index.html' : urlPath;
    const filePath = path.join(PUBLIC_DIR, relPath);

    // Prevent escaping the public/ directory via "..".
    if (!filePath.startsWith(PUBLIC_DIR)) {
        res.writeHead(403);
        res.end('Forbidden');
        return;
    }

    fs.readFile(filePath, (err, content) => {
        if (err) {
            res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
            res.end('404 - bulunamadi: ' + relPath);
            return;
        }
        const ext = path.extname(filePath);
        res.writeHead(200, { 'Content-Type': MIME_TYPES[ext] || 'application/octet-stream' });
        res.end(content);
    });
}

const server = http.createServer((req, res) => {
    const urlPath = req.url.split('?')[0];

    if (urlPath === '/api/players') {
        const state = readStateFile('players') || { updatedAt: null, players: [] };
        sendJson(res, 200, state);
        return;
    }

    if (urlPath === '/api/damagelog') {
        const state = readStateFile('damagelog') || { updatedAt: null, entries: [] };
        sendJson(res, 200, state);
        return;
    }

    if (urlPath === '/api/ping') {
        const state = readStateFile('ping');
        sendJson(res, 200, { connected: state !== null, state });
        return;
    }

    if (req.method === 'GET' && urlPath === '/api/settings') {
        const config = readConfig();
        sendJson(res, 200, { discordWebhookUrl: config.discordWebhookUrl || '' });
        return;
    }

    if (req.method === 'POST' && urlPath === '/api/settings') {
        readJsonBody(req).then((data) => {
            const url = (data.discordWebhookUrl || '').trim();
            if (url && !DISCORD_WEBHOOK_RE.test(url)) {
                sendJson(res, 400, { error: 'gecersiz Discord webhook adresi' });
                return;
            }
            const config = readConfig();
            config.discordWebhookUrl = url;
            writeConfig(config);
            sendJson(res, 200, { ok: true });
        }).catch((err) => {
            sendJson(res, 400, { error: 'invalid JSON body: ' + err.message });
        });
        return;
    }

    if (req.method === 'POST' && urlPath === '/api/settings/discord/test') {
        const config = readConfig();
        if (!config.discordWebhookUrl) {
            sendJson(res, 400, { error: 'once bir webhook adresi kaydet' });
            return;
        }
        sendDiscordMessage(config.discordWebhookUrl, 'LT Panel Bridge test mesaji - baglanti calisiyor.')
            .then(() => sendJson(res, 200, { ok: true }))
            .catch((err) => sendJson(res, 502, { error: err.message }));
        return;
    }

    // Generic state channel: GET /api/state/<name> reads state/<name>.json
    // as-is. Used by features (cameraman toggle, later spectator settings)
    // that don't need their own bespoke endpoint like /api/players does.
    if (req.method === 'GET' && urlPath.startsWith('/api/state/')) {
        const name = urlPath.slice('/api/state/'.length);
        if (!COMMAND_NAME_RE.test(name)) {
            sendJson(res, 400, { error: 'invalid state name' });
            return;
        }
        sendJson(res, 200, readStateFile(name) || {});
        return;
    }

    // Generic command channel: POST /api/cmd/<name> with a JSON body writes
    // cmd/<name>.json, which the matching LightTune.registerCommandPoller
    // on the game client picks up within its poll interval. Reused by every
    // web-panel action (teleport now, cameraman/spectator toggles later).
    if (req.method === 'POST' && urlPath.startsWith('/api/cmd/')) {
        const name = urlPath.slice('/api/cmd/'.length);
        if (!COMMAND_NAME_RE.test(name)) {
            sendJson(res, 400, { error: 'invalid command name' });
            return;
        }
        readJsonBody(req).then((data) => {
            writeCommandFile(name, data);
            sendJson(res, 200, { ok: true });
        }).catch((err) => {
            sendJson(res, 400, { error: 'invalid JSON body: ' + err.message });
        });
        return;
    }

    serveStatic(req, res, urlPath);
});

// Bind to loopback only - without this, Node listens on all network
// interfaces by default, meaning anyone else on the same LAN (or the
// internet, if the router/firewall forwards the port) could open this
// panel too. 127.0.0.1 makes it reachable only from this same PC.
server.listen(PORT, '127.0.0.1', () => {
    console.log('LT Ayarlari paneli calisiyor: http://localhost:' + PORT + '/');
    console.log('Durum klasoru: ' + STATE_DIR);
});
