# Tiny web desktop

Alpine + Openbox + Epiphany + xterm + noVNC + nginx login + file upload/download.
Open your URL, log in, get a Linux desktop in the browser.

## Deploy on Railway

1. Fork or use this repo, then Railway -> New Project -> Deploy from GitHub repo.
2. Variables:
   - `DESKTOP_PASSWORD`  your login password (if empty, one is generated and printed in the deploy logs)
   - `DESKTOP_USER`      optional, default `admin`
   - `PORT`              `8080`
3. Settings -> Networking -> Generate Domain, target port `8080`.
4. Add a Volume mounted at `/home/desk` to keep uploaded files.

Never commit passwords to the repo; set them in Railway Variables.

## Using it
- Desktop: `https://YOUR-APP.up.railway.app`
- Files (upload/download): `https://YOUR-APP.up.railway.app/files/`
- Right-click the desktop for Terminal / Browser / Files.

Needs roughly 700 MB - 1 GB RAM with the browser open.
