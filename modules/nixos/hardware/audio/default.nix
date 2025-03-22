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

      # extraConfig.pipewire.adjust-sample-rate = {
      #   "context.properties" = {
      #     "default.clock.rate" = 41000;
      #     "default.clock.allowed-rates" = [44100];
      #   };
      # };

      # wireplumber.extraConfig = {
      #   "custom" = {
      #       "monitor.alsa.rules" = [
      #         {
      #           matches = [
      #             {
      #               "node.name" = "alsa_output.usb-Focusrite_Scarlett_Solo_USB_Y76P5M4160A866-00.HiFi__Line1__sink";
      #             }
      #           ];
      #           actions = {
      #             update-props = {
      #               "audio.format" = "S32LE";
      #               "audio.rate" = 192000;
      #               "api.alsa.period-size" = 1024;
      #             };
      #           };
      #         }
      #         {
      #           matches = [
      #             {
      #               "node.name" = "alsa_input.pci-0000_0d_00.4.analog-stereo";
      #             }
      #           ];
      #           actions = {
      #             update-props = {
      #               "audio.format" = "S32LE";
      #               "audio.rate" = 192000;
      #               "api.alsa.period-size" = 1024;
      #             };
      #           };
      #         }
      #         {
      #           matches = [
      #             {
      #               "node.name" = "~alsa_output.*";
      #             }
      #           ];
      #           actions = {
      #             update-props = {
      #               "api.alsa.period-size" = 1024;
      #               "api.alsa.headroom" = 8192;
      #             };
      #           };
      #         }
      #       ];
      #     };
      #
      # "99-connect-tt" = {
      #   "wireplumber.components" = [
      #     {
      #       name = "auto-connect-tt.lua";
      #       type = "script/lua";
      #       provides = "custom.connect-tt";
      #     }
      #   ];
      #
      #   "wireplumber.profiles" = {
      #     main = {
      #       "custom.connect-tt" = "required";
      #     };
      #   };
      # };
      # };

      # wireplumber.extraScripts = {
      #   "auto-connect-tt.lua" = builtins.readFile ./auto-connect-tt.lua;
      # };
      # };
      #
      # # PulseAudio compatibility layer configuration for 44.1kHz
      # services.pipewire.extraConfig.pipewire-pulse."92-steam-config" = {
      #   context.modules = [
      #     {
      #       name = "libpipewire-module-protocol-pulse";
      #       args = {
      #         pulse.min.req = "32/44100";
      #         pulse.default.req = "32/44100";
      #         pulse.min.quantum = "32/44100";
      #         pulse.max.quantum = "8192/44100";
      #       };
      #     }
      #   ];
      # };
      #
      # environment.sessionVariables = {
      #   PIPEWIRE_LATENCY = "1024/44100";
    };
  };
}
