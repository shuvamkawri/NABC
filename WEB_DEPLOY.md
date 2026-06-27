# NABC Web — Build & Server Deployment Guide

This is the **Flutter Web** build of the NABC attendee app (`nabc_web`, v1.0.0+1).
It is a **static site**: HTML + JS + assets. Any static web host (Nginx, Apache,
S3/CloudFront, Netlify, GitHub Pages, etc.) can serve it. There is **no Node/PHP
server to run** — just upload files.

---

## 1. What to build

Run from the project root (`nabc_web/`). **Use PowerShell or CMD on Windows, not
Git Bash** — Git Bash mangles the `/NABC/` path.

```powershell
flutter clean
flutter build web --release --base-href=/NABC/
```

Output goes to `build\web\`. **That folder's CONTENTS are what you upload.**

### ⚠️ `--base-href` MUST match the URL sub-path the app is served from

| App is served at…                          | Use base-href      |
|--------------------------------------------|--------------------|
| `https://example.com/NABC/`  (sub-folder)  | `--base-href=/NABC/` |
| `https://nabc.example.com/`  (domain root) | `--base-href=/`    |

If the base-href is wrong, **every asset 404s and you get a blank white page.**
Confirm after building — `build/web/index.html` should contain
`<base href="/NABC/">` (or `/` for root hosting).

---

## 2. What to upload to the server

Upload the **entire contents** of `build\web\` (not the folder itself) into the
web root (or sub-folder) that matches the base-href:

```
index.html
flutter_bootstrap.js
flutter.js
flutter_service_worker.js
main.dart.js            ← the compiled app (~3 MB)
manifest.json
version.json
favicon.png
assets/                 ← fonts, images, app assets
canvaskit/              ← Flutter rendering engine (wasm)
icons/                  ← PWA icons
```

- Upload **all** of it — `main.dart.js`, `assets/`, and `canvaskit/` are required.
- Preserve the folder structure exactly.
- On each redeploy, **replace old files** (don't just merge) so stale hashed
  assets don't linger.

---

## 3. Server configuration

### a) MIME types
Make sure the server sends correct content types (most do by default):
- `.js`   → `application/javascript`
- `.wasm` → `application/wasm`  (CanvasKit — some servers need this added)
- `.json` → `application/json`

### b) SPA routing (single-page app fallback)
The app is a single-page app. If users will deep-link or refresh on an in-app
route, configure the server to **fall back to `index.html`** for unknown paths.

**Nginx** (serving at `/NABC/`):
```nginx
location /NABC/ {
    alias /var/www/nabc_web/;   # folder holding index.html
    try_files $uri $uri/ /NABC/index.html;
}
```

**Apache** (`.htaccess` in the app folder):
```apache
RewriteEngine On
RewriteBase /NABC/
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /NABC/index.html [L]
```

### c) GitHub Pages only
If deploying to GitHub Pages, also add an empty **`.nojekyll`** file at the root
so Jekyll doesn't strip files. (Not needed for Nginx/Apache.)

### d) Caching
`index.html` and `flutter_service_worker.js` should be served with **no/low
cache** (`Cache-Control: no-cache`) so updates appear immediately; the hashed
files under `assets/`/`canvaskit/` can be cached long-term.

---

## 4. ⚠️ CRITICAL: Backend API must be HTTPS

The app talks to the backend API, default:

```
http://45.79.175.205:3000/api-attendee
```

This is **plain HTTP**. If the web app is served over **HTTPS** (which any real
server/domain will be), the browser **blocks these calls as "mixed content"** —
login, events, bookings, banners, feedback, and chat will all silently fail.

**You must do ONE of these for the live site to work:**

1. **Give the backend an HTTPS URL** (TLS cert / domain), then build with:
   ```powershell
   flutter build web --release --base-href=/NABC/ --dart-define=API_BASE=https://api.yourdomain.com/api-attendee
   ```
2. **Reverse-proxy the API behind the same HTTPS domain** (recommended). E.g. in
   Nginx, proxy `https://yourdomain/api/` → `http://45.79.175.205:3000/api-attendee`,
   then build with `--dart-define=API_BASE=/api` (same-origin, no mixed content,
   no CORS issue).

   ```nginx
   location /api/ {
       proxy_pass http://45.79.175.205:3000/api-attendee/;
   }
   ```

The API base is read at build time via `String.fromEnvironment('API_BASE', …)`
in `lib/services/*.dart`. Changing it requires a **rebuild** (it is compiled in,
not a runtime config).

> Note: `bin/server.dart` is a small Dart proxy for local testing only. It does
> **not** run on a static host — do not rely on it in production. Use the Nginx/
> Apache reverse proxy above instead.

---

## 5. Quick checklist for the tech team

- [ ] Decide the URL path → set the matching `--base-href`.
- [ ] `flutter clean && flutter build web --release --base-href=…`
- [ ] Make the backend reachable over **HTTPS** (direct cert or reverse proxy)
      and set `--dart-define=API_BASE=…` accordingly, then rebuild.
- [ ] Upload **all** contents of `build/web/` to the web root/sub-folder.
- [ ] Add SPA fallback to `index.html` in the server config.
- [ ] Verify `.wasm` MIME type is served.
- [ ] Hard-refresh (Ctrl+F5) and confirm login + data load over HTTPS.