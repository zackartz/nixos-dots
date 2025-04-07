#! /bin/bash

# --- Configuration ---
bar="▁▂▃▄▅▆▇█"
# Number of bars Cava should output
num_bars=8
# Max height for ASCII output (should match length of bar string - 1)
ascii_max_range=$((${#bar} - 1))
# Temporary config file path (using PID $$ for uniqueness)
config_file="/tmp/polybar_cava_config_$$"

# --- Argument Handling ---
if [ $# -lt 1 ]; then
  # Print error message to stderr
  echo "Error: Please provide the PulseAudio source name as an argument." >&2
  echo "Usage: $0 <cava_pulse_source_name>" >&2
  echo "Example: $0 alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" >&2
  echo "You can find source names using: pactl list sources | grep 'Name:'" >&2
  exit 1
fi

# Assign the first argument to the pulse_source variable
pulse_source="$1"

# --- Functions ---

# Function to clean up the temporary config file on exit
cleanup() {
  rm -f "$config_file"
}

# --- Main Script ---

# Set trap to call cleanup function on script exit (including Ctrl+C)
trap cleanup EXIT

# Build the sed dictionary string to replace numbers with bar characters
dict="s/;//g;"
i=0
# Use modern arithmetic expansion and loop condition
while ((i < ${#bar})); do
  # Safely append to the dictionary string
  dict="${dict}s/$i/${bar:$i:1}/g;"
  # Use modern arithmetic increment
  ((i++))
done

# Create the Cava configuration file using printf for safety
# Note: Using the pulse_source variable passed as an argument
printf '%s\n' "
[general]
bars = $num_bars

[input]
method = pulse
source = \"$pulse_source\"

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
channels = mono
mono_option = average
ascii_max_range = $ascii_max_range
" >"$config_file" || {
  echo "Error: Failed to write Cava config." >&2
  exit 1
} # Exit if write fails

# Run Cava with the generated config and process its output
# Use 'exec cava' if you don't need the script to do anything after cava finishes
cava -p "$config_file" | while IFS= read -r line; do
  # Translate numbers to bars using sed
  echo "$line" | sed "$dict"
done

# The trap will handle cleanup automatically here
# If 'exec cava' was used above, this part is unreachable
exit 0
