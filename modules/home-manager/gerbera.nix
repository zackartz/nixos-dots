{
  config,
  lib,
  pkgs,
  ...
}: let
  # Custom function to create the Gerbera service
  mkGerberaService = name: cfg: {
    Unit = {
      Description = "Gerbera Media Server";
      After = ["network.target"];
      Wants = ["network.target"];
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      User = cfg.user;
      Group = cfg.group;
      ExecStart = "${pkgs.gerbera}/bin/gerbera -c ${cfg.configFile}";
      Restart = "on-failure";
    };
  };
in {
  # Define the systemd service for Gerbera
  systemd.user.services.gerbera = mkGerberaService "gerbera" {
    user = "zack"; # Run the service as user Zack
    group = "users"; # Assuming 'users' is the desired group
    configFile = "/home/zack/.config/gerbera/config.xml"; # Path to Gerbera's configuration file
  };

  xdg.configFile."gerbera/config.xml" = {
    text = ''      <?xml version="1.0" encoding="UTF-8"?>
            <config version="2">
              <server>
                <!-- Server settings -->
              </server>
              <storage>
                <directory location="/home/zack/Music" />
              </storage>
              <!-- Additional configuration here -->
            </config>'';
  };

  # Enable the service to start automatically
  systemd.user.startServices = true;
}
