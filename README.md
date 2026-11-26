# Tiny web desktop (Alpine + Openbox + Epiphany + noVNC + nginx login)

Deploy: push to GitHub -> Railway "Deploy from GitHub repo".

Variables:
- DESKTOP_USER      (default: admin)
- DESKTOP_PASSWORD  (required)
- PORT              (set by Railway automatically)

Add a Volume mounted at /home/desk to keep files between deploys.

Open https://your-app.up.railway.app -> login -> desktop.
Upload/download files: https://your-app.up.railway.app/files/
Right-click the desktop for the menu (Terminal, Epiphany, Files).
