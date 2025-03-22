# yoinked from https://gitlab.com/funaali/dotfiles/-/blob/3c74966cc4501c548aac0ee83cf5982510dd615c/modules/nixos/custom-opts.nix#L50, thanks!
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.march;
in {
  options.hardware.march = with types; {
    arch = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "GCC -march=";
    };

    system = mkOption {
      type = types.str;
      default = "x86_64-linux";
    };

    enableNativeOptimizations = mkOption {
      type = types.bool;
      default = false;
      description = "Enable -march=<arch> optimizations for all packages";
    };

    enableNativeOptimizationsByDefault = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Architectures for which native optimizations are enabled by default.
      '';
    };

    TCPBBRCongestionControl = mkEnableOption "TCP BBR congestion control";

    cpu.vcores = mkOption {
      type = types.int;
      default = 0;
      description = "Teh number of virtual CPU cores. Used to calculate heuristics.";
    };

    memory.total = mkOption {
      type = types.int;
      default = 0;
      description = "Total amount of RAM in the system (gigabytes). Used to calculate heuristics.";
    };
  };

  config = mkMerge [
    # Enable nix to build for the system arch and its inferiors.
    (mkIf (cfg.arch != null) {
      # taken from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/nix.nix
      nix.settings.system-features = map (x: "gccarch-${x}") ((systems.architectures.inferiors.${cfg.arch} or []) ++ [cfg.arch]) ++ ["big-parallel"];
    })

    # Set nix cores and max jobs based on cores and installed memory.
    (mkIf (cfg.cpu.vcores + cfg.memory.total > 0) (
      let
        minMemoryPerCore = 2;
        jobsOvercommitFactor = 4;
        cores = min 16 (min (cfg.cpu.vcores / 2) (cfg.memory.total / minMemoryPerCore));
        max-jobs = jobsOvercommitFactor * cfg.memory.total / (cores * minMemoryPerCore);
      in {
        nix.settings = {
          inherit cores max-jobs;
        };
      }
    ))

    # Native arch optimizations
    (mkIf (cfg.enableNativeOptimizations || elem cfg.arch cfg.enableNativeOptimizationsByDefault) {
      assertions = [
        {
          message = "custom.arch can't be null when custom.enableNativeOptimizations is true!";
          assertion = cfg.enableNativeOptimizations -> cfg.arch != null;
        }
      ];

      nixpkgs.hostPlatform = mkOverride 1 {
        system = cfg.system;
        gcc.arch = cfg.arch;
        gcc.tune = cfg.arch;
      };
    })

    # Enable TCP BBR congestion control
    (mkIf cfg.TCPBBRCongestionControl {
      boot.kernelModules = ["tcp_bbr"];
      boot.kernel.sysctl = {
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
    })

    # Settings if total memory is defined
    (mkIf (cfg.memory.total > 0) {
      services.earlyoom.freeMemThreshold = min 1 (max 5 (200 / cfg.memory.total));
    })
  ];
}
