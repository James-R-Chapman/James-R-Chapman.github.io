#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$HOME/orgroam/notes/TryHackMe"
TARGET_DIR="$REPO_ROOT/_posts/tryhackme"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
find "$TARGET_DIR" -type f -name '*.md' -delete

slugify() {
  local input="$1"
  echo "$input" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

trim_quotes() {
  local value="$1"
  value="${value%\"}"
  value="${value#\"}"
  value="${value%\'}"
  value="${value#\'}"
  echo "$value"
}

extract_meta() {
  local frontmatter="$1"
  local key="$2"
  echo "$frontmatter" \
    | awk -F: -v k="$key" 'tolower($1)==k {sub(/^[^:]*:[[:space:]]*/, "", $0); print; exit}'
}

normalize_tags() {
  local raw="$1"
  raw="$(trim_quotes "$raw")"
  if [[ -z "$raw" ]]; then
    echo '["tryhackme"]'
    return
  fi

  if [[ "$raw" == \[*\] ]]; then
    echo "$raw"
    return
  fi

  local cleaned
  cleaned="$(echo "$raw" | tr ',|' ' ' | tr -s ' ')"
  local output=()
  local tag
  for tag in $cleaned; do
    tag="${tag//#/}"
    tag="$(slugify "$tag")"
    [[ -n "$tag" ]] && output+=("\"$tag\"")
  done

  if [[ "${#output[@]}" -eq 0 ]]; then
    echo '["tryhackme"]'
  else
    local joined
    joined="$(IFS=,; echo "${output[*]}")"
    echo "[$joined]"
  fi
}

count=0
while IFS= read -r -d '' file; do
  base="$(basename "$file")"
  rel_path="${file#${SOURCE_DIR}/}"

  file_slug="$(echo "$base" | sed -E 's/^[0-9]{8}T[0-9]{6}--//; s/^[0-9]{8}T?[0-9]{0,6}--//; s/__.*$//; s/\.md$//')"
  file_date="$(echo "$base" | sed -nE 's/^([0-9]{4})([0-9]{2})([0-9]{2}).*/\1-\2-\3/p')"
  file_id="$(echo "$base" | sed -nE 's/^([0-9]{8}T[0-9]{6}).*/\1/p')"

  frontmatter=""
  if [[ "$(head -n 1 "$file")" == "---" ]]; then
    frontmatter="$(awk 'NR==1 && $0=="---"{in_frontmatter=1;next} in_frontmatter && $0=="---"{exit} in_frontmatter{print}' "$file")"
  fi

  title="$(extract_meta "$frontmatter" "title")"
  title="$(trim_quotes "$title")"
  [[ -z "$title" ]] && title="$file_slug"
  [[ -z "$title" ]] && title="${base%.md}"

  raw_date="$(extract_meta "$frontmatter" "date")"
  raw_date="$(trim_quotes "$raw_date")"
  if [[ "$raw_date" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
    post_date="${BASH_REMATCH[1]}"
  elif [[ -n "$file_date" ]]; then
    post_date="$file_date"
  else
    post_date="2025-01-01"
  fi

  tags="$(normalize_tags "$(extract_meta "$frontmatter" "tags")")"
  hubs="$(trim_quotes "$(extract_meta "$frontmatter" "hubs")")"
  identifier="$(trim_quotes "$(extract_meta "$frontmatter" "identifier")")"
  source_id="$(trim_quotes "$(extract_meta "$frontmatter" "id")")"
  urls="$(trim_quotes "$(extract_meta "$frontmatter" "urls")")"

  slug="$(slugify "$title")"
  [[ -z "$slug" ]] && slug="$(slugify "$file_slug")"
  [[ -z "$slug" ]] && slug="post-$((count + 1))"

  suffix=""
  if [[ -n "$identifier" ]]; then
    suffix="-$identifier"
  elif [[ -n "$file_id" ]]; then
    suffix="-$file_id"
  fi

  out_file="$TARGET_DIR/${post_date}-${slug}${suffix}.md"

  body="$(awk '
    NR==1 && $0=="---" {in_frontmatter=1; next}
    in_frontmatter && $0=="---" {in_frontmatter=0; next}
    !in_frontmatter {print}
  ' "$file")"

  safe_title="${title//\"/\\\"}"
  safe_hubs="${hubs//\"/\\\"}"
  safe_rel="${rel_path//\"/\\\"}"
  safe_identifier="${identifier//\"/\\\"}"
  safe_source_id="${source_id//\"/\\\"}"
  safe_urls="${urls//\"/\\\"}"

  {
    echo "---"
    echo "layout: post"
    echo "title: \"$safe_title\""
    echo "date: $post_date"
    echo "tags: $tags"
    echo "categories: [tryhackme]"
    [[ -n "$safe_hubs" ]] && echo "hubs: \"$safe_hubs\""
    [[ -n "$safe_identifier" ]] && echo "identifier: \"$safe_identifier\""
    [[ -n "$safe_source_id" ]] && echo "source_id: \"$safe_source_id\""
    [[ -n "$safe_urls" ]] && echo "source_urls: \"$safe_urls\""
    echo "source_path: \"$safe_rel\""
    echo "---"
    echo
    echo "$body"
  } > "$out_file"

  count=$((count + 1))
done < <(find "$SOURCE_DIR" -type f -name '*.md' -print0 | sort -z)

echo "Generated $count post files in $TARGET_DIR"
