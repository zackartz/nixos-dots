{
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  makeWrapper,
  pkg-config,
  libinput,
  wlroots_0_18,
  wayland,
  pixman,
  xorg,
  libdrm,
  fetchFromGitHub,
  stdenv,
  ninja,
  scdoc,
  validatePkgConfig,
  libGL,
  mesa,
  lib,
  libglvnd,
  meson,
}: let
  scenefx = stdenv.mkDerivation (finalAttrs: {
    pname = "scenefx";
    version = "0.2.1";

    src = fetchFromGitHub {
      owner = "wlrfx";
      repo = "scenefx";
      rev = "87c0e8b6d5c86557a800445e8e4c322f387fe19c";
      hash = "sha256-BLIADMQwPJUtl6hFBhh5/xyYwLFDnNQz0RtgWO/Ua8s=";
    };

    strictDeps = true;

    depsBuildBuild = [pkg-config];

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      scdoc
      validatePkgConfig
      wayland-scanner
    ];

    buildInputs = [
      libdrm
      libGL
      libxkbcommon
      pixman
      wayland
      wayland-protocols
      wlroots_0_18
      mesa
    ];

    meta = {
      description = "Drop-in replacement for the wlroots scene API that allows wayland compositors to render surfaces with eye-candy effects";
      homepage = "https://github.com/wlrfx/scenefx";
      license = lib.licenses.mit;
      mainProgram = "scenefx";
      pkgConfigModules = ["scenefx"];
      platforms = lib.platforms.all;
    };
  });
in
  stdenv.mkDerivation {
    pname = "mwc-wlr";
    version = "unstable-0.1.0";

    src = fetchFromGitHub {
      owner = "dqrk0jeste";
      repo = "mwc";
      rev = "15c6a00e3ee85bce1bff812b69652b1e3211f637";
      hash = "sha256-YJPkBuyyVXpGMQaOrCP1ECsF+kndFCIm/Fr2FR8fjt4=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      wayland-scanner
      makeWrapper
      pkg-config
      meson
      ninja
      mesa
      libglvnd.dev
      scenefx
    ];

    outputs = [
      "out"
    ];

    buildInputs = [
      wayland-protocols
      libxkbcommon
      wlroots_0_18
      libinput
      wayland
      mesa
      libglvnd.dev
      xorg.libxcb
      libdrm
      pixman
    ];

    strictDeps = true;

    depsBuildBuild = [
      pkg-config
    ];

    installPhase = ''
      ls
      mkdir -p $out/bin
      mkdir -p $out/share
      cp -r mwc $out/bin/
      cp -r mwc-ipc $out/bin/
      cp -r $src/default.conf $out/share/

      runHook postInstall
    '';

    postInstall = ''
      wrapProgram $out/bin/mwc --set MWC_DEFAULT_CONFIG_PATH "$out/share/default.conf"
    '';

    # HUUUUUUUUUGE thanks to https://github.com/dqrk0jeste ^^^

    __structuredAttrs = true;

    meta = {
      description = "tiling wayland compositor based on wlroots.";
      homepage = "https://github.com/dqrk0jeste/mwc";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [s0me1newithhand7s];
      platforms = ["x86_64-linux"];
    };
  }
