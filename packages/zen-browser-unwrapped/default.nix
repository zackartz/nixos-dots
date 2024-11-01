{
  buildNpmPackage,
  buildPackages,
  fetchFromGitHub,
  fetchurl,
  lib,
  overrideCC,
  stdenv,
  # build time
  autoconf,
  cargo,
  dump_syms,
  git,
  gnum4,
  nodejs,
  patchelf,
  pkg-config,
  pkgsBuildBuild,
  pkgsCross,
  python3,
  runCommand,
  rsync,
  rustc,
  rust-cbindgen,
  rustPlatform,
  unzip,
  vips,
  wrapGAppsHook3,
  writeShellScript,
  # runtime
  alsa-lib,
  atk,
  cairo,
  cups,
  dbus,
  dbus-glib,
  ffmpeg,
  fontconfig,
  freetype,
  gdk-pixbuf,
  gtk3,
  glib,
  icu73,
  jemalloc,
  libGL,
  libGLU,
  libdrm,
  libevent,
  libffi,
  libglvnd,
  libjack2,
  libjpeg,
  libkrb5,
  libnotify,
  libpng,
  libpulseaudio,
  libstartup_notification,
  libva,
  libvpx,
  libwebp,
  libxkbcommon,
  libxml2,
  makeWrapper,
  mesa,
  nasm,
  nspr,
  nss_latest,
  pango,
  pciutils,
  pipewire,
  sndio,
  udev,
  xcb-util-cursor,
  xorg,
  zlib,
  # Generic changes the compatibility mode of the final binaries.
  #
  # Enabling generic will make the browser compatible with more devices at the
  # cost of disabling hardware-specific optimizations. It is highly recommended
  # to leave `generic` disabled.
  generic ? false,
  debugBuild ? false,
  # On 32bit platforms, we disable adding "-g" for easier linking.
  enableDebugSymbols ? !stdenv.hostPlatform.is32bit,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  ffmpegSupport ? true,
  gssSupport ? true,
  jackSupport ? stdenv.hostPlatform.isLinux,
  jemallocSupport ? !stdenv.hostPlatform.isMusl,
  pipewireSupport ? waylandSupport && webrtcSupport,
  pulseaudioSupport ? stdenv.hostPlatform.isLinux,
  sndioSupport ? stdenv.hostPlatform.isLinux,
  waylandSupport ? true,
  privacySupport ? false,
  # WARNING: NEVER set any of the options below to `true` by default.
  # Set to `!privacySupport` or `false`.
  crashreporterSupport ? !privacySupport && !stdenv.hostPlatform.isRiscV && !stdenv.hostPlatform.isMusl,
  geolocationSupport ? !privacySupport,
  webrtcSupport ? !privacySupport,
}: let
  surfer = buildNpmPackage {
    pname = "surfer";
    version = "1.4.21";

    src = fetchFromGitHub {
      owner = "zen-browser";
      repo = "surfer";
      rev = "7f6da82ec44d210875b9a9c40b2169df0c88ff44";
      hash = "sha256-QfckIXxg5gUNvoofM39ZEiKkYV62ZJduHKVd171HQBw=";
    };

    patches = [./surfer-dont-check-update.patch];

    npmDepsHash = "sha256-p0RVqn0Yfe0jxBcBa/hYj5g9XSVMFhnnZT+au+bMs18=";
    makeCacheWritable = true;

    SHARP_IGNORE_GLOBAL_LIBVIPS = false;
    nativeBuildInputs = [pkg-config];
    buildInputs = [vips];
  };

  llvmPackages0 = rustc.llvmPackages;
  llvmPackagesBuildBuild0 = pkgsBuildBuild.rustc.llvmPackages;

  llvmPackages = llvmPackages0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  llvmPackagesBuildBuild = llvmPackagesBuildBuild0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };

  buildStdenv = overrideCC llvmPackages.stdenv (
    llvmPackages.stdenv.cc.override {bintools = buildPackages.rustc.llvmPackages.bintools;}
  );

  wasiSysRoot = runCommand "wasi-sysroot" {} ''
    mkdir -p "$out"/lib/wasm32-wasi
    for lib in ${pkgsCross.wasi32.llvmPackages.libcxx}/lib/*; do
      ln -s "$lib" "$out"/lib/wasm32-wasi
    done
  '';

  firefox-l10n = fetchFromGitHub {
    owner = "mozilla-l10n";
    repo = "firefox-l10n";
    rev = "cb528e0849a41c961f7c1ecb9e9604fc3167e03e";
    hash = "sha256-KQtSLDDPo6ffQwNs937cwccMasUJ/bnBFjY4LxrNGFg=";
  };
in
  buildStdenv.mkDerivation rec {
    pname = "zen-browser-unwrapped";
    version = "1.0.1-a.13";

    src = fetchFromGitHub {
      owner = "zen-browser";
      repo = "desktop";
      rev = "${version}";
      leaveDotGit = true;
      fetchSubmodules = true;
      hash = "sha256-z1YIdulvzkbSa266RZwBbYbeHqY22RvdHAdboR9uqig=";
    };

    firefoxVersion = (lib.importJSON "${src}/surfer.json").version.version;
    firefoxSrc = fetchurl {
      url = "mirror://mozilla/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
      hash = "sha256-en3z+Xc3RT76okPKnbr5XQ8PgzxdyK+stXBO4W7wYNA=";
    };

    SURFER_COMPAT = generic;

    nativeBuildInputs =
      [
        autoconf
        cargo
        git
        gnum4
        llvmPackagesBuildBuild.bintools
        makeWrapper
        nasm
        nodejs
        pkg-config
        python3
        rsync
        rust-cbindgen
        rustPlatform.bindgenHook
        rustc
        surfer
        unzip
        wrapGAppsHook3
        lib.custom.pkgs-unstable.xorg.xvfb
      ]
      ++ lib.optionals crashreporterSupport [
        dump_syms
        patchelf
      ];

    buildInputs =
      [
        atk
        cairo
        cups
        dbus
        dbus-glib
        ffmpeg
        fontconfig
        freetype
        gdk-pixbuf
        gtk3
        glib
        icu73
        libGL
        libGLU
        libevent
        libffi
        libglvnd
        libjpeg
        libnotify
        libpng
        libstartup_notification
        libva
        libvpx
        libwebp
        libxml2
        mesa
        nspr
        nss_latest
        pango
        pciutils
        pipewire
        udev
        xcb-util-cursor
        xorg.libX11
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXft
        xorg.libXi
        xorg.libXrender
        xorg.libXt
        xorg.libXtst
        xorg.pixman
        xorg.xorgproto
        xorg.libxcb
        xorg.libXrandr
        xorg.libXcomposite
        xorg.libXfixes
        xorg.libXScrnSaver
        zlib
      ]
      ++ lib.optional alsaSupport alsa-lib
      ++ lib.optional jackSupport libjack2
      ++ lib.optional pulseaudioSupport libpulseaudio
      ++ lib.optional sndioSupport sndio
      ++ lib.optional gssSupport libkrb5
      ++ lib.optional jemallocSupport jemalloc
      ++ lib.optionals waylandSupport [
        libdrm
        libxkbcommon
      ];

    configureScript = writeShellScript "configureMozconfig" ''
      for flag in $@; do
        echo "ac_add_options $flag" >> mozconfig
      done
    '';

    configureFlags =
      [
        "--disable-bootstrap"
        "--disable-updater"
        "--enable-default-toolkit=cairo-gtk3${lib.optionalString waylandSupport "-wayland"}"
        "--enable-system-pixman"
        "--with-distribution-id=org.nixos"
        "--with-libclang-path=${llvmPackagesBuildBuild.libclang.lib}/lib"
        "--with-system-ffi"
        "--with-system-icu"
        "--with-system-jpeg"
        "--with-system-libevent"
        "--with-system-libvpx"
        "--with-system-nspr"
        "--with-system-nss"
        "--with-system-png" # needs APNG support
        "--with-system-webp"
        "--with-system-zlib"
        "--with-wasi-sysroot=${wasiSysRoot}"
        "--host=${buildStdenv.buildPlatform.config}"
        "--target=${buildStdenv.hostPlatform.config}"
      ]
      ++ [
        (lib.enableFeature alsaSupport "alsa")
        (lib.enableFeature ffmpegSupport "ffmpeg")
        (lib.enableFeature geolocationSupport "necko-wifi")
        (lib.enableFeature gssSupport "negotiateauth")
        (lib.enableFeature jackSupport "jack")
        (lib.enableFeature jemallocSupport "jemalloc")
        (lib.enableFeature pulseaudioSupport "pulseaudio")
        (lib.enableFeature sndioSupport "sndio")
        (lib.enableFeature webrtcSupport "webrtc")
        # --enable-release adds -ffunction-sections & LTO that require a big amount
        # of RAM, and the 32-bit memory space cannot handle that linking
        (lib.enableFeature (!debugBuild && !stdenv.hostPlatform.is32bit) "release")
        (lib.enableFeature enableDebugSymbols "debug-symbols")
      ];

    preConfigure = ''
      export LLVM_PROFDATA=llvm-profdata
      export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=system
      export WASM_CC=${pkgsCross.wasi32.stdenv.cc}/bin/${pkgsCross.wasi32.stdenv.cc.targetPrefix}cc
      export WASM_CXX=${pkgsCross.wasi32.stdenv.cc}/bin/${pkgsCross.wasi32.stdenv.cc.targetPrefix}c++
      export ZEN_RELEASE=1
      surfer ci --brand alpha --display-version ${version}
      export HOME="$TMPDIR"
      git config --global user.email "nixbld@localhost"
      git config --global user.name "nixbld"
      install -D ${firefoxSrc} .surfer/engine/firefox-${firefoxVersion}.source.tar.xz
      surfer download
      surfer import
      patchShebangs engine/mach engine/build engine/tools
    '';

    preBuild = ''
      cp -r ${firefox-l10n} l10n/firefox-l10n
      for lang in $(cat ./l10n/supported-languages); do
        rsync -av --progress l10n/firefox-l10n/"$lang"/ l10n/"$lang" --exclude .git
      done
      sh scripts/copy-language-pack.sh en-US
      for lang in $(cat ./l10n/supported-languages); do
        sh scripts/copy-language-pack.sh "$lang"
      done
      Xvfb :2 -screen 0 1024x768x24 &
      export DISPLAY=:2
    '';

    buildPhase = ''
      runHook preBuild
      surfer build
      runHook postBuild
    '';

    preInstall = ''
      cd engine/obj-*
    '';

    meta = {
      mainProgram = "zen";
      description = "Firefox based browser with a focus on privacy and customization";
      homepage = "https://www.zen-browser.app/";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [matthewpi];
      platforms = lib.platforms.unix;
    };

    enableParallelBuilding = true;
    requiredSystemFeatures = ["big-parallel"];

    passthru = {
      binaryName = meta.mainProgram;
      inherit alsaSupport;
      inherit jackSupport;
      inherit pipewireSupport;
      inherit sndioSupport;
      inherit nspr;
      inherit ffmpegSupport;
      inherit gssSupport;
      inherit gtk3;
      inherit wasiSysRoot;
    };
  }
