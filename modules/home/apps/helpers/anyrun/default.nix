{
  options,
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.helpers.anyrun;
in {
  options.apps.helpers.anyrun = with types; {
    enable = mkBoolOpt false "Enable Anyrun";
  };

  config =
    mkIf cfg.enable {
    };
  #   programs.anyrun = {
  #     enable = true;
  #     config = {
  #       plugins = [
  #         inputs.anyrun.packages.${pkgs.system}.applications
  #         inputs.anyrun.packages.${pkgs.system}.shell
  #         inputs.anyrun.packages.${pkgs.system}.websearch
  #         inputs.anyrun.packages.${pkgs.system}.rink
  #         inputs.anyrun.packages.${pkgs.system}.stdin
  #       ];
  #       x = {fraction = 0.5;};
  #       y = {absolute = 0;};
  #       hideIcons = false;
  #       ignoreExclusiveZones = false;
  #       layer = "overlay";
  #       hidePluginInfo = true;
  #       closeOnClick = true;
  #       showResultsImmediately = false;
  #       maxEntries = null;
  #     };
  #     extraCss = ''
  #       *{
  #           all: unset;
  #           color: #cdd6f4;
  #           font-family: "JetBrainsMono Nerd Font";
  #           font-weight: bold;
  #       }
  #       #window{
  #           background-color: transparent;
  #       }
  #       #entry{
  #           background-color: #1e1e2e;
  #           border-radius: 15px;
  #           border: 3px solid #11111b;
  #           font-size: 16px;
  #           margin-top: 10px;
  #           padding: 1px 15px;
  #       }
  #       #match {
  #           margin-bottom: 2px;
  #           margin-top: 2px;
  #           padding: 1px 15px;
  #       }
  #       #match-desc{
  #           color: #bac2de;
  #           font-size: 12px;
  #           font-weight: normal;
  #       }
  #       #match:selected {
  #           background: #313244;
  #           border-radius: 15px;
  #       }
  #       #plugin{
  #           background-color: #1e1e2e;
  #           border-radius: 15px;
  #           border: 3px solid #11111b;
  #           margin-top:10px;
  #           padding: 10px 1px;
  #       }
  #       #plugin > *{
  #           all:unset;
  #       }
  #     '';
  #
  #     extraConfigFiles."applications.ron".text = ''
  #       Config(
  #         desktop_actions: false,
  #         max_entries: 5,
  #         terminal: Some("Kitty"),
  #       )
  #     '';
  #
  #     extraConfigFiles."shell.ron".text = ''
  #       Config(
  #           prefix: ">",
  #       )
  #     '';
  #
  #     extraConfigFiles."websearch.ron".text = ''
  #       Config(
  #         prefix: "",
  #         // Options: Google, Ecosia, Bing, DuckDuckGo, Custom
  #         //
  #         // Custom engines can be defined as such:
  #         // Custom(
  #         //   name: "Searx",
  #         //   url: "searx.be/?q={}",
  #         // )
  #         //
  #         // NOTE: `{}` is replaced by the search query and `https://` is automatically added in front.
  #         engines: [DuckDuckGo]
  #       )
  #     '';
  #   };
  # };
}
