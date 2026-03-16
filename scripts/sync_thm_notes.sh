#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="${1:-$HOME/orgroam/notes/TryHackMe}"
DEST_DIR="${2:-$REPO_ROOT/documents/notes/TryHackMe}"
POSTS_DIR="${3:-$REPO_ROOT/_posts/tryhackme}"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

echo "Syncing notes:"
echo "  from: $SOURCE_DIR"
echo "    to: $DEST_DIR"

rsync -a --delete --prune-empty-dirs \
  --exclude '.DS_Store' \
  --include '*/' \
  --include '*.md' \
  --include '*.org' \
  --exclude '*' \
  "$SOURCE_DIR"/ "$DEST_DIR"/

echo "Building Jekyll posts in: $POSTS_DIR"
bash "$REPO_ROOT/scripts/build_thm_posts.sh" "$DEST_DIR" "$POSTS_DIR"

echo "Sync and build complete."
