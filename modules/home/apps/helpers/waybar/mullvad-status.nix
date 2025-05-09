{pkgs}:
pkgs.writeShellScriptBin "mullvad-status-waybar" ''
  exec ${pkgs.bash}/bin/bash ${./mullvad-status.sh} | jq -c
''
