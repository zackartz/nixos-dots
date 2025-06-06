# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  pkgs,
  inputs,
  config,
  specialArgs,
  system,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # nixpkgs.pkgs = lib.mkForce inputs.nixos-stable.legacyPackages.${system};

  nix.settings = {
    trusted-users = ["zoey"];
  };

  nix.optimise = {
    automatic = true;
    dates = ["03:45"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.nix-ld.enable = true;

  networking.hostName = "pluto"; # Define your hostname.

  services.web.nginx.enable = true;
  services.gh.enable = true;
  services.fail2ban = {
    enable = true;
    jails.DDOS = ''
      filter = nginx-limit-req
      action = iptables-allports[name=HTTP, protocol=all]
      logpath = /var/log/nginx/blocked.log
      findtime = 600
      maxretry = 20
      bantime = 3600
    '';
  };

  services.nginx.virtualHosts."node.nyc.zackmyers.io" = {
    forceSSL = true;
    enableACME = true;
  };

  services.atproto-pds = {
    enable = true;
    nginx = {
      enable = true;
      domain = "zoeys.computer";
      subdomainPrefix = "pds";
      useACME = true;
    };
    blobStorage = {
      type = "disk";
      diskPath = "/pds/blocks"; # or your preferred path
    };
    port = 3525; # or any other port you want to use
  };

  ui.fonts.enable = true;

  age.secrets = {
    zc_key = {
      owner = "zoeyscomputer-phx";
      group = "zoeyscomputer-phx";
      file = ./sec/zc_key.age;
    };
    zc_db_pass = {
      owner = "zoeyscomputer-phx";
      group = "zoeyscomputer-phx";
      file = ./sec/zc_db_pass.age;
    };
  };

  sites = {
    cv.enable = true;
    gitlab.enable = true;
    grafana.enable = true;
    mirror.enable = true;
    pterodactyl.enable = true;
    search.enable = true;
    map.enable = true;
    hydra.enable = false;
    cache.enable = true;
    minio.enable = true;
    immich.enable = true;
    polaris.enable = false;
    sourcehut.enable = false;
    forgejo.enable = true;
    zoeycomputer = {
      enable = true;
      domain = "zoeys.computer";
      phx = {
        database = {
          name = "zoeyscomputer";
          user = "zoeyscomputer";
          passwordFile = config.age.secrets.zc_db_pass.path; # Optional
          host = "localhost"; # Optional, defaults to localhost
        };
        secret_key_file = config.age.secrets.zc_key.path;
      };
    };
  };

  catppuccin.flavor = "mocha";

  zmio.blog.enable = true;
  zmio.blog.domain = "zackmyers.io";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  programs.zsh.enable = true;

  programs.mosh.enable = true;

  environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.agenix];

  users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zack = {
    isNormalUser = true;
    description = "zack";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
    packages = with pkgs; [];
    hashedPassword = "$6$rounds=2000000$673Iz4rM8Dr9yz7C$Xq5JXxE7ioUrpZmMf3uTrPN2ODrEu3Sph6EhWyPoM5Ty./FhgB9hU0mz1yYo8sUj7wdUMWfR98haVJ24Wv3BK/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICuUA9KTvcZ+ZTEO90y6VcmQyuwL30I2mOGsm8GZn7BF zack@mars"
    ];
  };

  users.users.zoey = {
    isNormalUser = true;
    description = "zoey";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
    hashedPassword = "$6$rounds=2000000$673Iz4rM8Dr9yz7C$Xq5JXxE7ioUrpZmMf3uTrPN2ODrEu3Sph6EhWyPoM5Ty./FhgB9hU0mz1yYo8sUj7wdUMWfR98haVJ24Wv3BK/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuw7D+qDzzxBKsfKEmMd7odc98m3ZEnqWYFtuKwvC9k zoey@earth"
    ];
  };

  users.users.alfie = {
    isNormalUser = true;
    description = "alfie";
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
    hashedPassword = "$6$rounds=2000000$iq6PHGbyILszBS.4$PNjQ8FHJAC6JwwjTns1gxfLrXH0m/yMdFE57O29mGBEKOYm0fDqd1XG/7GjdBgNsxYVVy3LgebOGifSMUwelu1";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtlZMJYa7JrZfUDSgJrxbahZClsbbCB8ahvIk3wmokAPSMzMunVmll0QAliYA+WV4A4zAlecCfVRvBDa3e2M3Yct54Oo6uNPNsPmKS6/5WN293p7r9j9jYLAAPe8OfC24dXb06BmLQ0kPdBWxd8sfINhcDKv+8vtncaTowG4k3UK0w9LJB+91uZM1lMK1MCppC1vbdvDMuJ4m3pidT/0bNEdFWUMXEu3G024d+u5fHyEVGwNWpbMshXRLPpfJtg4qPLXiyf/piE2gXiBdoFWDhspWT2NO8GEpgBTmdmR1qNviOcnJlxwGSNTvL1GYK5DAxqNZBm3GYAheNIpdikxpgUiS28Z4nCBNChLK2fFzS8Ol2OGK0qfe5fNEkjxsi624hG6xvEZqEXsVBV1tzH+cw5iC6jda03HXmMcZ23glI4fhE/RNR6yAMYjj1DwdiILMnWsW3H9YYPQmkRdY028WB6Lpr9k4pD7+O3PEekwEGLe9XahTHndrUMFv68eAgvC8= rotki@DESKTOP-J809N7P"
    ];
  };

  users.users.aspect = {
    isNormalUser = true;
    description = "aspect";
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
    hashedPassword = "$6$rounds=2000000$.jQCugUHZuUcjfEn$L1M3pmsEPCeqckEPa5t7pqKCxQyGwxmQvK/65c2.IAXE0bhsoGL3kN0F9WpLxcN/wLt7xcikz005GiKFF.AND.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA45PCi9tsGbGlVYq2Rt1jAD9/GDIDCsEfv88+4mAA2U imboo@FBISurvallienceVan3"
    ];
  };

  virtualisation.docker.enable = true;

  snowfallorg.users.zack = {
    create = true;
    admin = false;

    home = {
      enable = true;
    };
  };

  snowfallorg.users.zoey = {
    create = true;
    admin = false;

    home = {
      enable = true;
    };
  };

  snowfallorg.users.alfie = {
    create = true;
    admin = false;

    home = {
      enable = true;
    };
  };

  snowfallorg.users.aspect = {
    create = true;
    admin = false;
    home = {
      enable = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "zach@zacharymyers.com";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  networking.firewall.enable = true;
  networking.firewall.extraPackages = [pkgs.ipset];
  networking.firewall.extraCommands = ''
    ipset create blocked_ips hash:ip
    while IFS= read -r ip; do
      ipset add blocked_ips "$ip"
    done < ${./blocked.txt}
    iptables -A INPUT -m set --set blocked_ips src -j DROP
    iptables -A INPUT -m set --set blocked_ips src -j LOG --log-prefix "INPUT:DROP:" --log-level 6
  '';

  networking.firewall.extraStopCommands = ''
    iptables -D INPUT -m set --set blocked_ips src -j DROP || true
    iptables -A INPUT -m set --set blocked_ips src -j LOG --log-prefix "INPUT:DROP:" --log-level 6 || true
    ipset destroy blocked_ips || true
  '';

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [80 443 6969 2022 16262];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 25565;
      to = 25575;
    }
    {
      from = 24454;
      to = 24464;
    }
  ];
  networking.firewall.allowedUDPPorts = [80 443 6969 2022 16262];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
