#!/bin/bash
set -e

REPO="nuxy1466-blip/STAR_REJOIN"
URL="https://github.com/$REPO/releases/latest/download/STAR_REJOIN.zip"
DIR="$HOME/star-tool"
TMP="$HOME/.star_tmp"

echo "[*] ติดตั้งแพ็กเกจที่จำเป็น..."
if command -v pkg >/dev/null 2>&1; then
    pkg update -y >/dev/null 2>&1 || true
    pkg install -y python curl unzip
elif command -v apt >/dev/null 2>&1; then
    sudo apt update -y >/dev/null 2>&1 || true
    sudo apt install -y python3 python3-pip curl unzip
fi

echo "[*] กำลังโหลดจาก Releases..."
rm -rf "$TMP" && mkdir -p "$TMP"
curl -L --fail -o "$TMP/STAR_REJOIN.zip" "$URL"

echo "[*] กำลังแตกไฟล์..."
mkdir -p "$DIR"
unzip -o "$TMP/STAR_REJOIN.zip" -d "$DIR" >/dev/null

# ถ้าใน zip มีโฟลเดอร์ซ้อน ให้ย้ายไฟล์ขึ้นมา
if [ ! -f "$DIR/STAR_REJOIN.py" ]; then
    F=$(find "$DIR" -name "STAR_REJOIN.py" | head -n 1)
    [ -n "$F" ] && cp -r "$(dirname "$F")"/. "$DIR"/
fi

# ติดตั้ง requirements ถ้ามี
if [ -f "$DIR/requirements.txt" ]; then
    pip install -r "$DIR/requirements.txt" || true
fi

rm -rf "$TMP"

echo "[✓] ติดตั้งเสร็จแล้ว"
echo "รันด้วย: cd ~/star-tool && python STAR_REJOIN.py"