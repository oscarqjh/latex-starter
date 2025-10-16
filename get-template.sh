#!/usr/bin/env bash
set -euo pipefail

# Cross-platform Bash installer for LaTeX templates from this repo.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/oscarqjh/latex-starter/main/get-template.sh | bash -s -- [template-name] [destination-dir]
#
# Environment overrides:
#   OWNER_REPO   GitHub owner/repo, default: oscarqjh/latex-starter
#   BRANCH       Git branch or tag, default: main
#   TEMPLATES_DIR Repository templates folder, default: templates

OWNER_REPO="${OWNER_REPO:-oscarqjh/latex-starter}"
BRANCH="${BRANCH:-main}"
TEMPLATES_DIR="${TEMPLATES_DIR:-templates}"

API_BASE="https://api.github.com/repos/${OWNER_REPO}"
RAW_BASE="https://raw.githubusercontent.com/${OWNER_REPO}/${BRANCH}"

print_err() { printf "[get-template] %s\n" "$*" 1>&2; }

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    print_err "Missing required command: $1"
    exit 1
  fi
}

# jq is optional; we fall back to basic parsing if not available.
has_jq() { command -v jq >/dev/null 2>&1; }

fetch_templates() {
  # Returns a newline-separated list of template directory names under ${TEMPLATES_DIR}
  local contents_json
  contents_json=$(curl -fsSL "${API_BASE}/contents/${TEMPLATES_DIR}?ref=${BRANCH}")
  if has_jq; then
    echo "$contents_json" | jq -r '.[] | select(.type=="dir") | .name'
    return
  fi
  # Fallback parser for JSON without jq
  echo "$contents_json" | tr '\n' ' ' | sed 's/},/}\n/g' | awk '
    BEGIN { RS="\n" }
    /"type"\s*:\s*"dir"/ {
      match($0, /"name"\s*:\s*"([^\"]+)"/, m);
      if (m[1] != "") print m[1];
    }'
}

select_template_interactive() {
  local templates template idx choice
  mapfile -t templates < <(fetch_templates)
  if [ ${#templates[@]} -eq 0 ]; then
    print_err "No templates found under '${TEMPLATES_DIR}' in ${OWNER_REPO}@${BRANCH}."
    exit 1
  fi
  printf "Available templates (from %s/%s):\n" "$OWNER_REPO" "$TEMPLATES_DIR"
  for idx in "${!templates[@]}"; do
    printf "  %2d) %s\n" "$((idx+1))" "${templates[$idx]}"
  done
  while true; do
    if [ -t 0 ]; then
      if ! read -r -p "Enter a number to select a template: " choice; then
        print_err "No input detected. Re-run with a template argument, e.g.:"
        print_err "  curl -fsSL https://raw.githubusercontent.com/${OWNER_REPO}/${BRANCH}/get-template.sh | bash -s -- ${templates[0]}"
        exit 2
      fi
    else
      print_err "Non-interactive shell detected. Re-run with a template argument, e.g.:"
      print_err "  curl -fsSL https://raw.githubusercontent.com/${OWNER_REPO}/${BRANCH}/get-template.sh | bash -s -- ${templates[0]}"
      exit 2
    fi
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#templates[@]} ]; then
      template="${templates[$((choice-1))]}"
      echo "$template"
      return
    fi
    print_err "Invalid choice. Please enter a number between 1 and ${#templates[@]}."
  done
}

download_template_files() {
  # Args: template_name destination_dir
  local template_name="$1"
  local dest_dir="$2"

  # Use the Git Trees API to list all files under templates/<template_name>
  local tree_json
  tree_json=$(curl -fsSL "${API_BASE}/git/trees/${BRANCH}?recursive=1")

  local paths
  if has_jq; then
    mapfile -t paths < <(echo "$tree_json" | jq -r --arg p "${TEMPLATES_DIR}/${template_name}/" '.tree[] | select(.type=="blob" and (.path|startswith($p))) | .path')
  else
    # Fallback parsing: extract blob paths and filter prefix
    paths=()
    while IFS= read -r line; do
      paths+=("$line")
    done < <(echo "$tree_json" | tr '\n' ' ' | sed 's/},/}\n/g' | awk '
      BEGIN { RS="\n" }
      /"type"\s*:\s*"blob"/ {
        if (match($0, /"path"\s*:\s*"([^\"]+)"/, m)) {
          print m[1];
        }
      }' | awk -v p="${TEMPLATES_DIR}/${template_name}/" 'index($0,p)==1')
  fi

  if [ ${#paths[@]} -eq 0 ]; then
    print_err "No files found for template '${template_name}'."
    exit 1
  fi

  mkdir -p "$dest_dir"
  local base_prefix="${TEMPLATES_DIR}/${template_name}/"
  for p in "${paths[@]}"; do
    local rel_path="${p#${base_prefix}}"
    local target_path="${dest_dir}/${rel_path}"
    mkdir -p "$(dirname "$target_path")"
    local url="${RAW_BASE}/${p}"
    printf "Downloading %s -> %s\n" "$url" "$target_path"
    curl -fsSL "$url" -o "$target_path"
  done

  printf "\nTemplate '%s' downloaded to '%s'.\n" "$template_name" "$dest_dir"
  printf "Next steps:\n  - Open '%s' in your LaTeX editor (VS Code + LaTeX Workshop recommended)\n  - Compile the project to produce a PDF\n" "$dest_dir"
}

main() {
  # Parse args
  local template_name="${1:-}"
  local destination_dir="${2:-}"

  if [ -z "$template_name" ]; then
    template_name=$(select_template_interactive)
  fi

  if [ -z "$destination_dir" ]; then
    destination_dir="$template_name"
  fi

  # Basic validation
  case "$template_name" in
    *..*|/*|*\\*) print_err "Invalid template name."; exit 1 ;;
  esac

  download_template_files "$template_name" "$destination_dir"
}

main "$@"


