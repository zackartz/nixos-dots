{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.grafana;
in {
  options.sites.grafana = with types; {
    enable = mkBoolOpt false "Enable grafana";

    domain = mkStringOpt "monitor.zackmyers.io" "The domain for grafana";
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      domain = cfg.domain;
      port = 2342;
      addr = "127.0.0.1";
      protocol = "http";
      analytics.reporting.enable = false;

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          }
          # {
          #   name = "Loki";
          #   type = "loki";
          #   access = "proxy";
          #   url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
          # }
        ];
      };
    };

    services.prometheus = {
      enable = true;
      port = 9001;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = ["systemd"];
          port = 9002;
        };
      };

      scrapeConfigs = [
        {
          job_name = "chrysalis";
          scrape_interval = "10s";
          static_configs = [
            {
              targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
            }
          ];
        }
      ];
    };

    # services.loki = {
    #   enable = true;
    #   configuration = {
    #     server.http_listen_port = 3030;
    #     auth_enabled = false;
    #
    #     ingester = {
    #       lifecycler = {
    #         address = "127.0.0.1";
    #         ring = {
    #           kvstore = {
    #             store = "inmemory";
    #           };
    #           replication_factor = 1;
    #         };
    #       };
    #       chunk_idle_period = "1h";
    #       max_chunk_age = "1h";
    #       chunk_target_size = 999999;
    #       chunk_retain_period = "30s";
    #     };
    #
    #     schema_config = {
    #       configs = [
    #         {
    #           from = "2022-06-06";
    #           store = "boltdb-shipper";
    #           object_store = "filesystem";
    #           schema = "v11";
    #           index = {
    #             prefix = "index_";
    #             period = "24h";
    #           };
    #         }
    #       ];
    #     };
    #
    #     storage_config = {
    #       boltdb_shipper = {
    #         active_index_directory = "/var/lib/loki/boltdb-shipper-active";
    #         cache_location = "/var/lib/loki/boltdb-shipper-cache";
    #         cache_ttl = "24h";
    #       };
    #
    #       filesystem = {
    #         directory = "/var/lib/loki/chunks";
    #       };
    #     };
    #
    #     limits_config = {
    #       reject_old_samples = true;
    #       reject_old_samples_max_age = "168h";
    #     };
    #
    #     table_manager = {
    #       retention_deletes_enabled = false;
    #       retention_period = "0s";
    #     };
    #
    #     compactor = {
    #       working_directory = "/var/lib/loki";
    #       compactor_ring = {
    #         kvstore = {
    #           store = "inmemory";
    #         };
    #       };
    #     };
    #   };
    # };

    # services.promtail = {
    #   enable = true;
    #   configuration = {
    #     server = {
    #       http_listen_port = 3031;
    #       grpc_listen_port = 0;
    #     };
    #     positions = {
    #       filename = "/tmp/positions.yaml";
    #     };
    #     clients = [
    #       {
    #         url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
    #       }
    #     ];
    #     scrape_configs = [
    #       {
    #         job_name = "journal";
    #         journal = {
    #           max_age = "12h";
    #           labels = {
    #             job = "systemd-journal";
    #             host = "pluto";
    #           };
    #         };
    #         relabel_configs = [
    #           {
    #             source_labels = ["__journal__systemd_unit"];
    #             target_label = "unit";
    #           }
    #         ];
    #       }
    #     ];
    #   };
    #   # extraFlags
    # };

    services.nginx.virtualHosts.${config.services.grafana.domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
    };
  };
}
