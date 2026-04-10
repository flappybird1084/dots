#!/usr/bin/env bash
# macOS: OCR whatever image is currently in the clipboard using Tesseract,
# print the extracted text to stdout.

set -euo pipefail

# Requirements:
#   brew install tesseract pngpaste
# Optional (for better accuracy / other languages):
#   brew install tesseract-lang

tmpdir="$(mktemp -d)"
img="$tmpdir/clip.png"

cleanup() { rm -rf "$tmpdir"; }
trap cleanup EXIT

# Save clipboard image to a PNG file
if ! pngpaste "$img" >/dev/null 2>&1; then
  echo "No image found in clipboard (or pngpaste couldn't read it)." >&2
  exit 1
fi

# Run OCR and print result
tesseract "$img" stdout 2>/dev/null
