#!/bin/bash
# Usage: ./generate_qr.sh <url>
# Requires: qrencode (sudo apt install qrencode)

if [ -z "$1" ]; then
  echo "Usage: $0 <url>"
  exit 1
fi

URL="$1"
OUT="qr.png"

echo "Generating QR code for: $URL"
qrencode -o "$OUT" "$URL"
echo "QR code saved to $OUT"