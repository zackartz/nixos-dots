#!/usr/bin/env bash
set -euo pipefail

# Helper: pick a relay (country [city] [hostname]) via fuzzel + jq
pick_relay() {
  local api="$API_RESPONSE"
  local country_list country_sel country_code
  local city_list city_sel city_code loc_key
  local host_list host_sel

  # Build "Country Name (cc)" array
  mapfile -t country_list < <(
    jq -r '
      .locations
      | to_entries[]
      | "\(.value.country) (\(.key|split("-")[0]))"
    ' <<<"$api" | sort -u
  )
  country_sel=$(printf '%s\n' "${country_list[@]}" |
    fuzzel --dmenu --prompt="Select country:")
  [[ -z "$country_sel" ]] && return 1
  country_code=$(grep -oP '(?<=\()[^)]+(?=\))' <<<"$country_sel")

  # Build "City Name (ccc)" array for that country
  mapfile -t city_list < <(
    jq -r --arg cc "$country_code" '
      .locations
      | to_entries[]
      | select(.key|startswith("\($cc)-"))
      | "\(.value.city) (\(.key|split("-")[1]))"
    ' <<<"$api" | sort -u
  )
  if ((${#city_list[@]})); then
    city_sel=$(printf '%s\n' "${city_list[@]}" |
      fuzzel --dmenu --prompt="Select city in $country_sel:")
    [[ -z "$city_sel" ]] && return 1
    city_code=$(grep -oP '(?<=\()[^)]+(?=\))' <<<"$city_sel")
    loc_key="$country_code-$city_code"
  fi

  # Optional hostname picker
  mapfile -t host_list < <(
    jq -r --arg loc "${loc_key:-}" '
      ( .openvpn.relays[]
      , .wireguard.relays[]
      , .bridge.relays[] )
      | select(.location == $loc)
      | .hostname
    ' <<<"$api" | sort -u
  )
  if ((${#host_list[@]})); then
    host_sel=$(printf '%s\n' "${host_list[@]}" |
      fuzzel --dmenu --prompt="Select hostname (optional):")
    # if they pick a hostname, we switch to pure-hostname mode
    [[ -n "$host_sel" ]] && {
      RELAY_CMD_ARGS=("$host_sel")
      return 0
    }
  fi

  # Assemble country [city]
  RELAY_CMD_ARGS=("$country_code")
  [[ -n "${city_code-}" ]] && RELAY_CMD_ARGS+=("$city_code")
  return 0
}

# Ensure mullvad CLI exists
if ! command -v mullvad >/dev/null 2>&1; then
  echo "Mullvad CLI not found" | fuzzel --dmenu
  exit 1
fi

# Fetch status and API once
STATUS_RAW=$(mullvad status 2>/dev/null || echo "Disconnected")
API_RESPONSE=$(curl -s "https://api.mullvad.net/app/v1/relays")

# Determine state and current relay (if any)
if [[ $STATUS_RAW == Connecting* ]]; then
  STATE=Connecting
elif grep -q "^Connected" <<<"$STATUS_RAW"; then
  STATE=Connected
else
  STATE=Disconnected
fi

# Try to parse the current relay hostname for Connected/Connecting
if [[ $STATE != Disconnected ]]; then
  CURRENT_RELAY=$(grep -E 'Relay:' <<<"$STATUS_RAW" |
    sed -E 's/.*Relay:[[:space:]]*//')
fi

# Main menu
case $STATE in
Connected | Connecting)
  # Offer Disconnect or Change Location
  CHOICE=$(printf "Disconnect\nChange Location" |
    fuzzel --dmenu --prompt="$STATE ${CURRENT_RELAY:-}")
  case "$CHOICE" in
  Disconnect)
    mullvad disconnect
    ;;
  "Change Location")
    if pick_relay; then
      mullvad relay set location "${RELAY_CMD_ARGS[@]}"
    fi
    ;;
  esac
  ;;
Disconnected)
  # Offer Connect or Connect to Location
  CHOICE=$(printf "Connect\nConnect to Location" |
    fuzzel --dmenu --prompt="Disconnected")
  case "$CHOICE" in
  Connect)
    mullvad connect
    ;;
  "Connect to Location")
    if pick_relay; then
      mullvad relay set location "${RELAY_CMD_ARGS[@]}"
      mullvad connect
    fi
    ;;
  esac
  ;;
esac

