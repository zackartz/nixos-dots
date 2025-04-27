{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.audio;
in {
  options.hardware.audio = with types; {
    enable = mkBoolOpt false "Enable Audio";
  };

  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };

    systemd.user.services.cava-combine-inputs = {
      description = "Combine MOTU M4 Line Inputs L/R for Cava";

      # Ensure this runs after pipewire-pulse is started
      after = ["pipewire-pulse.service"];
      wants = ["pipewire-pulse.service"]; # Start pipewire-pulse if not already running

      # Make it part of the default user session target
      wantedBy = ["default.target"];

      # Service configuration details
      serviceConfig = {
        Type = "oneshot"; # Run the command once and exit
        # Use RemainAfterExit if you want the service to show as 'active' after running
        # RemainAfterExit = true;

        # Command to execute. Use full paths for robustness.
        # We use sh -c to run multiple commands sequentially.
        # pactl is provided by the pulseaudio package.
        ExecStart = "${pkgs.writeShellScriptBin "cava-start" ''
          echo "Attempting to load Cava combine modules..."
          # Load null sink (returns non-zero if it fails AND module doesn't exist)
          ${pkgs.pulseaudio}/bin/pactl load-module module-null-sink sink_name=cava-line-in sink_properties=device.description="Cava_Combined_LineIn"
          # Load loopbacks (returns non-zero on failure)
          ${pkgs.pulseaudio}/bin/pactl load-module module-loopback source="alsa_input.usb-MOTU_M4_M4MA03F7DV-00.HiFi__Line3__source" sink=cava-line-in latency_msec=10
          ${pkgs.pulseaudio}/bin/pactl load-module module-loopback source="alsa_input.usb-MOTU_M4_M4MA03F7DV-00.HiFi__Line4__source" sink=cava-line-in latency_msec=10
          echo "Finished loading Cava combine modules (ignore errors if already loaded)."
          # Exit successfully even if modules were already loaded (pactl might return 0)
          exit 0
        ''}/bin/cava-start";

        # Prevent service from restarting automatically
        Restart = "no";
      };
    };
  };
}
