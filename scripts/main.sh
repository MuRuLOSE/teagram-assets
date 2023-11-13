#!/bin/bash

clear

if sudo -v >/dev/null 2>&1; then
    SUDOCMD="sudo"
else
    SUDOCMD=""
fi

LOG_FILE="install.log"
echo "[INFO] Starting installation" > "$LOG_FILE"
echo "[DEBUG] SUDOCMD: $SUDOCMD" >> "$LOG_FILE"

if [[ "$teagram" == "reset" ]]; then
    echo "[INFO] Resetting teagram..." >> "$LOG_FILE"
    eval "$SUDOCMD apt purge -y python3"
fi

if ! command -v python3 &>/dev/null || ! command -v python3-pip &>/dev/null; then
    echo "[INFO] Installing Python and pip..." >> "$LOG_FILE"
    eval "$SUDOCMD $PKGINSTALL python3 python3-pip"
fi

if [[ -f requirements.txt ]]; then
    echo "[INFO] Installing requirements.txt..." >> "$LOG_FILE"
    echo "[INFO] Installing libraries..."
    pip3 install -r requirements.txt
else
    echo "[WARNING] requirements.txt not found. Skipping library installation." >> "$LOG_FILE"
fi

if ! command -v $PYTHON &>/dev/null; then
    echo "[ERROR] Python version $PYTHON not found. Please install the required version." >> "$LOG_FILE"
    exit 1
fi

read -p "Do you want to update packages? (Y/n): " update_choice
if [[ "$update_choice" == "y" ]]; then
    echo "[INFO] Updating and upgrading all packages..." >> "$LOG_FILE"
    echo "[INFO] Updating..."
    eval "$SUDOCMD $UPD"
else
    echo "[INFO] Skipping package update as per user choice."
fi

echo "[INFO] First start teagram..." >> "$LOG_FILE"
echo "[INFO] First start..."
clear
$PYTHON -m teagram
