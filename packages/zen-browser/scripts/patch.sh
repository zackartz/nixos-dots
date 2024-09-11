ENGINE_DIR=$(pwd)/engine
SRC_DIR=$(pwd)/src

# Create a directory if it doesn't exist
mkdirp() {
  mkdir -p "$1"
}

# Append to a file
append_to_file_sync() {
  local file="$1"
  local text="$2"
  echo -e "$text" >>"$file"
}

# Copy or symlink files
copy_manual() {
  local name="$1"
  local src_path="$SRC_DIR/$name"
  local dest_path="$ENGINE_DIR/$name"

  echo "Processing file: $name"

  # Ensure the parent directory exists
  mkdirp "$(dirname "$dest_path")"

  # Remove existing non-symlink file
  if [ -e "$dest_path" ] && [ ! -L "$dest_path" ]; then
    echo "Removing existing file at $dest_path"
    rm -f "$dest_path"
  fi

  if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
    # Create symlink
    echo "Creating symlink: $src_path -> $dest_path"
    ln -s "$src_path" "$dest_path"
  else
    # On Windows or other platforms without symlink permissions
    echo "Copying file: $src_path -> $dest_path"
    cp "$src_path" "$dest_path"
  fi

  # Add to .gitignore if not already present
  if ! grep -q "$name" "$ENGINE_DIR/.gitignore"; then
    echo "Adding $name to .gitignore"
    append_to_file_sync "$ENGINE_DIR/.gitignore" "\n$name"
  fi
}

# Apply folder patches
apply_folder_patches() {
  # Get all files from the source directory, excluding .patch files and node_modules
  local all_files=($(find "$SRC_DIR" -type f ! -name "*.patch" ! -path "*/node_modules/*"))

  for file in "${all_files[@]}"; do
    relative_path="${file#$SRC_DIR/}"
    copy_manual "$relative_path"
  done
}

# Apply internal patches
apply_internal_patches() {
  for patch in $(find $PATCHES_DIR -type f -name "*.patch"); do
    echo "Applying internal patch: $patch"
    git apply --directory "$ENGINE_DIR" "$patch"
  done
}

# Apply git patches
apply_git_patches() {
  for patch in $(find $SRC_DIR -type f -name "*.patch"); do
    echo "Applying git patch: $patch $ENGINE_DIR"
    echo "git apply --directory "$ENGINE_DIR" "$patch""
    git apply --verbose "$patch"
  done
}

cd engine || exit
apply_git_patches
cd .. || exit
apply_folder_patches
