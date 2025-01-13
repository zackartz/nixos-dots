{
  writeShellScriptBin,
  lib,
  pkgs,
  ...
}:
writeShellScriptBin "sc" ''

  ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" /tmp/screenshot.png

  response=$(${lib.getExe pkgs.curl} -s \
       -X POST \
       -H "Accept: application/json" \
       -H "Authorization: Bearer Z4MYrYtJUb3Y8VvJynkWAw9eBVU3kvvW9gQ50--hROw" \
       -F "file=@/tmp/screenshot.png" \
       https://zoeys.computer/api/images/create)

  echo "$response" | ${lib.getExe pkgs.jq} -r '.url' | ${pkgs.wl-clipboard}/bin/wl-copy

  rm /tmp/screenshot.png

  echo "Screenshot uploaded and URL copied to clipboard!"
''
