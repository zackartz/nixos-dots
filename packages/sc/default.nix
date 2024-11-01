{
  writeShellScriptBin,
  lib,
  pkgs,
  ...
}:
writeShellScriptBin "sc" ''

  # Take a screenshot with grim and slurp
  ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" /tmp/screenshot.png

  # Upload the screenshot and store the response
  response=$(${lib.getExe pkgs.curl} -s \
       -X POST \
       -H "Accept: application/json" \
       -H "Authorization: Bearer Z4MYrYtJUb3Y8VvJynkWAw9eBVU3kvvW9gQ50--hROw" \
       -F "file=@/tmp/screenshot.png" \
       https://zoeys.computer/api/images/create)

  # Extract the URL using jq and copy to clipboard
  echo "$response" | ${lib.getExe pkgs.jq} -r '.url' | ${pkgs.wl-clipboard}/bin/wl-copy

  # Clean up the temporary file
  rm /tmp/screenshot.png

  # Notify user
  echo "Screenshot uploaded and URL copied to clipboard!"
''
