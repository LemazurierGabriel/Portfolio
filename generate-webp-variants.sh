#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# generate-webp-variants.sh
# Génère les variantes WebP (480w, 900w, 1400w) pour chaque image du dossier images/
# Prérequis : cwebp ou ffmpeg installé
#   macOS  : brew install webp
#   Ubuntu : apt install webp
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail
WIDTHS=(480 900 1400)
SRC_DIR="images"

for src in "$SRC_DIR"/*.png "$SRC_DIR"/*.jpg "$SRC_DIR"/*.jpeg; do
  [ -f "$src" ] || continue
  base="${src%.*}"
  for w in "${WIDTHS[@]}"; do
    out="${base}-${w}.webp"
    if command -v cwebp &>/dev/null; then
      cwebp -resize "$w" 0 -q 82 "$src" -o "$out"
    elif command -v ffmpeg &>/dev/null; then
      ffmpeg -y -i "$src" -vf "scale=${w}:-1" -c:v libwebp -quality 82 "$out"
    else
      echo "Erreur : ni cwebp ni ffmpeg trouvé" >&2; exit 1
    fi
    echo "✓ $out"
  done
done
echo "Toutes les variantes générées."
