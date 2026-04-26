#!/usr/bin/env bash
set -euo pipefail

latest_v="$(ls -1d V*/ 2>/dev/null | sed 's#/##' | grep -E '^V[0-9]+$' | sort -V | tail -n1 || true)"
if [[ -z "$latest_v" ]]; then
  echo "No V[n] folder found in repository root."
  exit 1
fi

version=""
if [[ -n "${RELEASE_VERSION:-}" ]]; then
  version="${RELEASE_VERSION#v}"
fi

if [[ -z "$version" ]]; then
  msg="$(git log -1 --pretty=%B)"
  version="$(printf '%s' "$msg" | sed -nE 's/.*\bv([0-9]+\.[0-9]+\.[0-9]+)\b.*/\1/p' | head -n1)"
fi

if [[ -z "$version" ]]; then
  latest_tag="$(gh release list --limit 1 --json tagName --jq '.[0].tagName' 2>/dev/null || true)"
  if [[ -n "$latest_tag" ]]; then
    version="${latest_tag#v}"
    echo "No SemVer found in commit message; falling back to latest release tag: $latest_tag"
  fi
fi

if [[ -z "$version" ]]; then
  echo "Cannot resolve release version. Provide workflow_dispatch input 'version' or use a commit message containing vX.Y.Z"
  exit 1
fi

if ! printf '%s' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "Invalid SemVer: $version"
  exit 1
fi

tag="v$version"
asset_dir='.release-assets'
rm -rf "$asset_dir"
mkdir -p "$asset_dir"

add_asset() {
  local src="$1"
  local dst="$2"
  if [[ -f "$src" ]]; then
    cp "$src" "$asset_dir/$dst"
  fi
}

add_asset "$latest_v/Install/windows/sapi.exe" "sapi.exe"
add_asset "$latest_v/Install/windows/sapi-install.exe" "sapi-install.exe"
add_asset "$latest_v/Install/plugin/sapi-lang.vsix" "sapi-lang.vsix"
add_asset "$latest_v/Install/linux/sapi" "sapi-linux-x64"
add_asset "$latest_v/Install/linux/sapi-install.sh" "sapi-install-linux-x64.sh"
add_asset "$latest_v/Documentation/sapi.html" "sapi.html"

if [[ -z "$(ls -A "$asset_dir")" ]]; then
  echo "No assets were collected from $latest_v"
  exit 1
fi

notes_file="$asset_dir/release-notes.md"
cat > "$notes_file" <<EOF
Automated release for Sapi v${version}.

Included assets are uploaded from ${latest_v}:
- Windows CLI and installer
- VS Code plugin (sapi-lang.vsix)
- Linux x64 binary and installer
- sapi.html documentation
EOF

shopt -s nullglob
files=("$asset_dir"/*)
shopt -u nullglob

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No files available for release upload."
  exit 1
fi

if gh release view "$tag" >/dev/null 2>&1; then
  gh release upload "$tag" "${files[@]}" --clobber
  gh release edit "$tag" --title "Sapi v${version}" --notes-file "$notes_file" --latest
else
  gh release create "$tag" "${files[@]}" --title "Sapi v${version}" --notes-file "$notes_file" --latest
fi

echo "Release $tag published/updated successfully."
