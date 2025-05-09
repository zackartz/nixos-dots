#!/usr/bin/env bash
set -euo pipefail

# Get status (fall back to “Disconnected” on error)
STATUS=$(mullvad status 2>/dev/null || echo "Disconnected")

if echo "$STATUS" | grep -q "^Connected"; then
  # Extract relay hostname
  SERVER=$(echo "$STATUS" |
    sed -n 's/^[[:space:]]*Relay:[[:space:]]*//p' |
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # Grab the entire Visible location line (location + IPs)
  FULL_LOC=$(echo "$STATUS" |
    sed -n 's/^[[:space:]]*Visible location:[[:space:]]*//p')

  # Split off the human‐readable location (before first dot)
  LOCATION=${FULL_LOC%%.*}

  # The part after the first “. ” is the IP info
  IPS=${FULL_LOC#*. }

  TOOLTIP="Connected via ${SERVER} (${IPS})"

  # Emit JSON for Waybar
  echo '{"text": "'"${LOCATION}"'"
          , "tooltip": "'"${TOOLTIP}"'"
          , "class": "connected"
          }'
else
  echo '{"text": "Disconnected"
          , "tooltip": "Mullvad: Disconnected"
          , "class": "disconnected"
          }'
fi
