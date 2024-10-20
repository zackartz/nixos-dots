#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nix-prefetch-git nix-prefetch-github

# Define the package file
PACKAGE_FILE="default.nix"

# Function to get the latest version of zen-browser/desktop
get_latest_version() {
  curl --silent "https://api.github.com/repos/zen-browser/desktop/releases" |
    jq -r '[.[] | select(.prerelease==false)][0].tag_name'
}

# Get the latest version
latest_version=$(get_latest_version)

if [ -z "$latest_version" ] || [ "$latest_version" == "null" ]; then
  echo "Failed to get the latest version."
  exit 1
fi

echo "Latest version: $latest_version"

# Update the 'version' variable in the Nix expression
sed -i "/pname = \"zen-browser-unwrapped\";/,/version = \".*\";/s/version = \".*\";/version = \"$latest_version\";/" "$PACKAGE_FILE"

# Fetch the new 'src' hash
echo "Fetching new source hash..."
src_info=$(nix-prefetch-github zen-browser desktop --rev "$latest_version" --fetch-submodules)
src_hash=$(echo "$src_info" | jq -r .sha256)

echo "New source hash: $src_hash"

# Update 'rev' and 'hash' in the 'src' fetchFromGitHub
sed -i "/src = fetchFromGitHub {/,/};/{
    /owner = \"zen-browser\";/,/};/{
        s/rev = \".*\";/rev = \"$latest_version\";/
        s/hash = \".*\";/hash = \"$src_hash\";/
    }
}" "$PACKAGE_FILE"

# Clone the repository to extract 'firefoxVersion'
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

git clone --depth 1 --branch "$latest_version" https://github.com/zen-browser/desktop.git "$tmpdir"

# Extract 'firefoxVersion' from 'surfer.json'
firefoxVersion=$(jq --raw-output '.version.version' "$tmpdir/surfer.json")
echo "Firefox version: $firefoxVersion"

# Update the 'firefoxVersion' in the Nix expression
sed -i "s/firefoxVersion = \".*\";/firefoxVersion = \"$firefoxVersion\";/" "$PACKAGE_FILE"

# Fetch the new 'firefoxSrc' hash
firefox_url="mirror://mozilla/firefox/releases/$firefoxVersion/source/firefox-$firefoxVersion.source.tar.xz"
echo "Fetching Firefox source hash..."
firefox_hash=$(nix-prefetch-url --unpack "$firefox_url")

echo "Firefox source hash: $firefox_hash"

# Update the 'firefoxSrc' hash in the Nix expression
sed -i "/firefoxSrc = fetchurl {/,/};/{
    s/hash = \".*\";/hash = \"$firefox_hash\";/
}" "$PACKAGE_FILE"

echo "Update complete!"
