#!/bin/sh
# Put the DockWatch demo back to its original, vulnerable state, so it can be shown again.
# Linux and macOS:   sh reset-demo.sh      (Windows: double-click reset-demo.cmd)
#
# Applying DockWatch fixes changes docker-compose.yml and creates files (app/Dockerfile.hardened,
# secrets/, .gitignore, .dockwatch/). This copies the original files back from .original/ and
# deletes only those generated files.
DEMO="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$DEMO/.original/docker-compose.yml" ]; then
    echo "Reset FAILED: the original demo files are missing from $DEMO/.original"
    echo "Download DockWatch again to get a fresh copy of the demo."
    exit 1
fi
cp "$DEMO/.original/docker-compose.yml" "$DEMO/docker-compose.yml"
rm -rf "$DEMO/app"
cp -R "$DEMO/.original/app" "$DEMO/app"
[ -d "$DEMO/secrets" ] && rm -rf "$DEMO/secrets" && echo "removed secrets"
[ -f "$DEMO/.gitignore" ] && rm -f "$DEMO/.gitignore" && echo "removed .gitignore"
[ -d "$DEMO/.dockwatch" ] && rm -rf "$DEMO/.dockwatch" && echo "removed .dockwatch"
# restore the git timeline's working copy as well, when Git and the demo history are present
if [ -d "$DEMO/.git" ] && command -v git >/dev/null 2>&1; then
    git -C "$DEMO" checkout -- . >/dev/null 2>&1
fi
echo "Demo reset. Rescan it in DockWatch: it should show 100 / FAIL again."
