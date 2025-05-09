{pkgs}:
pkgs.writeShellScriptBin "mullvad-server-list" ''
  #!${pkgs.runtimeShell}
  set -euo pipefail

  # Check if mullvad is installed
  if ! command -v mullvad >/dev/null 2>&1; then
      echo "Mullvad CLI not found" | fuzzel --dmenu
      exit 1
  fi

  # Get the list of countries
  COUNTRIES=$(mullvad relay list | grep -E "^[[:space:]]+[[:alpha:]]" | sed 's/^[[:space:]]*//g')

  # If no argument is provided, show the list of countries
  if [ $# -eq 0 ]; then
      echo "$COUNTRIES" | sort | fuzzel --dmenu --prompt="Select country: "
      exit 0
  fi

  COUNTRY="$1"

  # If country is provided but no city, show cities for that country
  if [ $# -eq 1 ]; then
      CITIES=$(mullvad relay list | grep -A 100 "^[[:space:]]*$COUNTRY" | grep -E "^[[:space:]]{4}[[:alpha:]]" | sed 's/^[[:space:]]*//g' | head -n $(mullvad relay list | grep -A 100 "^[[:space:]]*$COUNTRY" | grep -E "^[[:space:]]{4}[[:alpha:]]" | wc -l))

      if [ -z "$CITIES" ]; then
          # If no cities found, show servers for this country
          SERVERS=$(mullvad relay list | grep -A 100 "^[[:space:]]*$COUNTRY" | grep -E "^[[:space:]]{8}[a-z0-9]+" | sed 's/^[[:space:]]*//g' | cut -d' ' -f1-2)
          echo "$SERVERS" | fuzzel --dmenu --prompt="Select server in $COUNTRY: "
      else
          echo "$CITIES" | fuzzel --dmenu --prompt="Select city in $COUNTRY: "
      fi
      exit 0
  fi

  # If both country and city are provided, show servers in that city
  CITY="$2"
  SERVERS=$(mullvad relay list | grep -A 100 "^[[:space:]]*$COUNTRY" | grep -A 100 "^[[:space:]]*$CITY" | grep -E "^[[:space:]]{8}[a-z0-9]+" | sed 's/^[[:space:]]*//g')

  # Extract server information and load (where available)
  SERVER_INFO=""
  while read -r server; do
      # Get server details
      SERVER_NAME=$(echo "$server" | awk '{print $1}')
      SERVER_TYPE=$(echo "$server" | awk '{print $2}')

      # Get server load if available (using 'mullvad relay list --location all')
      LOAD_INFO=$(mullvad relay list --location all | grep "$SERVER_NAME" | grep -o '[0-9]\+%' || echo "N/A")

      # Add server with load info to the list
      SERVER_INFO="${SERVER_INFO}${SERVER_NAME} (${SERVER_TYPE}) - Load: ${LOAD_INFO}"$'\n'
  done <<< "$SERVERS"

  # Display the server list with load information
  echo "$SERVER_INFO" | grep -v "^$" | fuzzel --dmenu --prompt="Select server in $CITY: "
''
