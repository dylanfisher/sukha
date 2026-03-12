#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
repo_name="$(basename "$repo_root")"
addon_xml="$repo_root/addon.xml"

if [[ ! -f "$addon_xml" ]]; then
  echo "error: addon.xml not found at $addon_xml" >&2
  exit 1
fi

default_remote_host="root@192.168.1.128"

if [[ $# -gt 2 ]]; then
  echo "usage: $0 [user@kodi-host] [remote-dir]" >&2
  echo "example: $0 $default_remote_host /storage/downloads" >&2
  exit 1
fi

remote_host="${1:-$default_remote_host}"
remote_dir="${2:-/storage/downloads}"

version="$(sed -n 's/.*version=\"\\([^\"]*\\)\".*/\\1/p' "$addon_xml" | head -n 1)"
if [[ -z "$version" ]]; then
  echo "error: unable to determine add-on version from addon.xml" >&2
  exit 1
fi

dist_dir="$repo_root/dist"
zip_name="${repo_name}-${version}.zip"
zip_path="$dist_dir/$zip_name"

mkdir -p "$dist_dir"
rm -f "$zip_path"

parent_dir="$(dirname "$repo_root")"
(
  cd "$parent_dir"
  zip -qr "$zip_path" "$repo_name" \
    -x "$repo_name/.git/*" \
    -x "$repo_name/dist/*" \
    -x "$repo_name/.DS_Store" \
    -x "$repo_name/**/.DS_Store"
)

ssh "$remote_host" "mkdir -p '$remote_dir'"
scp "$zip_path" "$remote_host:$remote_dir/"

printf 'Copied %s to %s:%s/\n' "$zip_name" "$remote_host" "$remote_dir"
