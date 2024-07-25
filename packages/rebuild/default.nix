{writeShellScriptBin, ...}:
writeShellScriptBin "rebuild" ''
  set -e
  pushd ~/nixos/
  alejandra . &>/dev/null
  git add .
  git pull origin main
  echo "[REBUILD]: rebuilding nixos"
  nh os switch
  popd
''
