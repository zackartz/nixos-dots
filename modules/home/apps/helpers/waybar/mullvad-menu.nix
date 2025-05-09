{pkgs}: let
  script = ./mullvad-menu.sh;
in
  pkgs.writeScriptBin "mullvad-menu" ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.bash}/bin/bash ${script}
  ''
