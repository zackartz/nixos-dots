{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.polaris;

  polaris-web = pkgs.buildNpmPackage rec {
    pname = "polaris-web";
    version = "76";

    src = pkgs.fetchFromGitHub {
      owner = "agersant";
      repo = "polaris-web";
      rev = "build-${version}";
      hash = "sha256-mGsgW6lRqCt+K2RrF2s4zhvYzH94K+GEXGUCn5ngBTY=";
    };

    npmDepsHash = "sha256-MVqC6mMdiqtJzAB8J8xdxO5xCwiibBasA3BvN6EiBSM=";

    env.CYPRESS_INSTALL_BINARY = "0";

    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      cp -a dist $out/share/polaris-web

      runHook postInstall
    '';
  };

  polaris = pkgs.rustPlatform.buildRustPackage rec {
    pname = "polaris";
    version = "0.15.0";

    src = pkgs.fetchFromGitHub {
      owner = "agersant";
      repo = "polaris";
      tag = version;
      hash = "sha256-uwYNyco4IY6lF+QSVEOVVhZCJ4nRkj8gsgRA0UydLHU=";

      # The polaris version upstream in Cargo.lock is "0.0.0".
      # We're unable to simply patch it in the patch phase due to
      # rustPlatform.buildRustPackage fetching dependencies before applying patches.
      # If we patch it after fetching dependencies we get an error when
      # validating consistency between the final build and the prefetched deps.
      postFetch = ''
        # 'substituteInPlace' does not support multiline replacements?
        sed -i $out/Cargo.lock -z \
          -e 's/\[\[package\]\]\nname = "polaris"\nversion = "0.0.0"/[[package]]\nname = "polaris"\nversion = "'"${version}"'"/g'
      '';
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-EUUxKLLdXgNp7GWTWAkzdNHKogu4Voo8wjeFFzM9iEg=";

    # Compile-time environment variables for where to find assets needed at runtime
    env = {
      POLARIS_WEB_DIR = "${polaris-web}/share/polaris-web";
    };

    preCheck = ''
      # 'Err' value: Os { code: 24, kind: Uncategorized, message: "Too many open files" }
      ulimit -n 4096
      # to debug bumps
      export RUST_BACKTRACE=1
    '';

    checkFlags = [
      # requires network
      "--skip=server::test::settings::put_settings_golden_path"
    ];

    __darwinAllowLocalNetworking = true;

    doCheck = false;

    meta = with lib; {
      description = "Self-host your music collection, and access it from any computer and mobile device";
      longDescription = ''
        Polaris is a FOSS music streaming application, designed to let you enjoy your music collection
        from any computer or mobile device. Polaris works by streaming your music directly from your
        own computer, without uploading it to a third-party. There are no  kind of premium version.
        The only requirement is that your computer stays on while it streams your music!
      '';
      homepage = "https://github.com/agersant/polaris";
      license = licenses.mit;
      maintainers = with maintainers; [pbsds];
      platforms = platforms.unix;
      mainProgram = "polaris";
    };
  };
in {
  options.sites.polaris = with types; {
    enable = mkBoolOpt false "Enable Music (Polaris)";

    domain = mkStringOpt "music.zoeys.cloud" "The domain of the music instance";
  };

  config = mkIf cfg.enable {
    services.polaris2 = {
      enable = true;
      package = polaris;
      # group = "users";
      # user = "zoey";
      openFirewall = true;
      settings = {
        mount_dirs = [
          {
            name = "local";
            source = "/home/zoey/Music/";
          }
        ];
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.polaris.port}";
      };
    };
  };
}
