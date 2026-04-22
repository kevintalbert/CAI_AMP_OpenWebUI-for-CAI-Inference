#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Open WebUI — Cloudera Machine Learning / AI Inference Service entry point
# ─────────────────────────────────────────────────────────────────────────────
# NOTE: written for /bin/sh compatibility — no bashisms so the shebang
# is purely a preference; the platform may invoke this with sh directly.
# ─────────────────────────────────────────────────────────────────────────────
set -e

# ── Resolve app root ──────────────────────────────────────────────────────────
# Use $0 (sh-compatible) instead of BASH_SOURCE, which is bash-only.
# The platform runs ./entry.sh from the repo root, so dirname $0 is the repo.
APP_DIR="${APP_DIR:-$(cd "$(dirname "$0")" && pwd)}"
cd "$APP_DIR"

PORT="${CDSW_APP_PORT:-8080}"

echo "=================================================="
echo " Open WebUI (CML AI Inference)"
echo "=================================================="
echo " App dir : $APP_DIR"
echo " Python  : $(python3 --version 2>&1)"
echo " Port    : $PORT"
echo "=================================================="
echo ""

# ── Step 0: Install Python dependencies (idempotent) ─────────────────────────
# The platform may or may not auto-install requirements.txt before calling
# this script. We do it ourselves to be safe; pip skips already-installed pkgs.
if [ -f "$APP_DIR/requirements.txt" ]; then
    echo "[0/3] Installing Python dependencies..."
    pip install --quiet -r "$APP_DIR/requirements.txt" || {
        echo "      WARNING: pip install had errors — continuing anyway"
    }
    echo "      done"
    echo ""
fi

# ── Step 1: Workaround for Open WebUI / google.colab import path ─────────────
# See https://github.com/open-webui/open-webui/discussions/5190#discussioncomment-10963146
echo "[1/3] Ensuring local google.colab shim directory..."
PY_VER="$(python3 -c 'import sys; print("%d.%d" % (sys.version_info.major, sys.version_info.minor))')"
mkdir -p "$APP_DIR/.local/lib/python${PY_VER}/site-packages/google/colab"
echo "      done"
echo ""

# ── Step 2: Launch Open WebUI ─────────────────────────────────────────────────
echo "[2/3] Starting Open WebUI on 0.0.0.0:$PORT"
echo ""

# Strip trailing /chat/completions from the inference base URL (same as run_app.py).
OPENAI_API_BASE_URLS="$(echo "${INFERENCE_SERVICE_BASE_URL:-}" | sed 's/\/chat\/completions$//')"
export OPENAI_API_BASE_URLS

OPENAI_API_KEYS="$(grep -o '"access_token":"[^"]*' "/tmp/jwt" | sed 's/"access_token":"//')"
export OPENAI_API_KEYS

export WEBUI_AUTH=False

exec open-webui serve --host 0.0.0.0 --port "$PORT"
