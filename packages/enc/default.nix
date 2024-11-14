{
  writeShellScriptBin,
  gnupg,
  neovim,
  coreutils,
  wl-clipboard,
  xclip,
}:
writeShellScriptBin "enc" ''
  #!${coreutils}/bin/env zsh

  # Check if recipients were provided
  if [[ $# -eq 0 ]]; then
      echo "Usage: $0 recipient1@example.com [recipient2@example.com ...]"
      exit 1
  fi

  # Create a temporary file
  temp_file=$(${coreutils}/bin/mktemp)
  trap "${coreutils}/bin/rm -f $temp_file $temp_file.asc" EXIT

  # Create recipient arguments for gpg
  recipients=()
  recipients+=("-r" "0x5F873416BCF59F35")
  for recipient in "$@"; do
      recipients+=("-r" "$recipient")
  done

  # Open neovim with the temp file
  ${neovim}/bin/nvim \
       -c "set noswapfile" \
       -c "set filetype=" \
       "$temp_file"

  # Check if the temp file has content after nvim closes
  if [[ -s "$temp_file" ]]; then
      # Encrypt the content with gpg and copy to clipboard
      if [[ -n "$WAYLAND_DISPLAY" ]]; then
          ${gnupg}/bin/gpg --encrypt \
              --armor \
              --trust-model always \
              "''${recipients[@]}" \
              "$temp_file"

          cat "$temp_file".asc | ${wl-clipboard}/bin/wl-copy --type text/plain
          echo "Encrypted content copied to Wayland clipboard"
      elif [[ -n "$DISPLAY" ]]; then
          ${gnupg}/bin/gpg --encrypt \
              --armor \
              --trust-model always \
              "''${recipients[@]}" \
              "$temp_file"
          cat "$temp_file.asc" | ${xclip}/bin/xclip -selection clipboard
          echo "Encrypted content copied to X11 clipboard"
      else
          echo "No display detected, cannot copy to clipboard"
          exit 1
      fi
  else
      echo "No content was saved, exiting."
  fi
''
