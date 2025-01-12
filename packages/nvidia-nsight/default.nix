{
  stdenv,
  fetchurl,
  fetchpatch,
  fetchFromGitLab,
  dpkg,
  lib,
  makeWrapper,
  autoPatchelfHook,
  libglvnd,
  xorg,
  qt6,
  alsa-lib,
  fontconfig,
  freetype,
  autoreconfHook,
  pkg-config,
  lerc,
  libdeflate,
  libjpeg,
  libwebp,
  xz,
  zlib,
  zstd,
  sphinx,
  glib,
  vulkan-loader,
  addDriverRunpath,
  ...
}: let
  version = "2024.3.0.24333";
  pathVersion = "2024.3.0.0";

  rpath = lib.makeLibraryPath [
    stdenv.cc.cc.lib
    libglvnd
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    xorg.libXfixes
    qt6.qtbase
    qt6.qtwayland
    qt6.qtwebengine
    qt6.qtcharts
    qt6.qtsvg
    libtiff
    alsa-lib
    fontconfig

    freetype
    glib
    vulkan-loader
  ];

  libtiff = stdenv.mkDerivation rec {
    pname = "libtiff";
    version = "4.3.0";

    src = fetchurl {
      url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
      sha256 = "1j3snghqjbhwmnm5vz3dr1zm68dj15mgbx1wqld7vkl7n2nfaihf";
    };

    # FreeImage needs this patch
    patches = [./headers.patch];

    outputs = ["bin" "dev" "dev_private" "out" "man" "doc"];

    postFixup = ''
      moveToOutput include/tif_dir.h $dev_private
      moveToOutput include/tif_config.h $dev_private
      moveToOutput include/tiffiop.h $dev_private
    '';

    # If you want to change to a different build system, please make
    # sure cross-compilation works first!
    nativeBuildInputs = [autoreconfHook pkg-config];

    propagatedBuildInputs = [libjpeg xz zlib]; #TODO: opengl support (bogus configure detection)

    buildInputs = [libdeflate]; # TODO: move all propagatedBuildInputs to buildInputs.

    enableParallelBuilding = true;

    doCheck = true;

    meta = with lib; {
      description = "Library and utilities for working with the TIFF image file format";
      homepage = "https://libtiff.gitlab.io/libtiff";
      changelog = "https://libtiff.gitlab.io/libtiff/v${version}.html";
      maintainers = with maintainers; [qyliss];
      license = licenses.libtiff;
      platforms = platforms.unix;
    };
  };

  src = fetchurl {
    url = "https://developer.nvidia.com/downloads/assets/tools/secure/nsight-graphics/2024_3_0/linux/NVIDIA_Nsight_Graphics_${version}.deb";
    sha256 = "sha256-8hGB2WFwbDIPTbNHfeJ7vYWOaGCIZ421KUjNoEbePqg=";
  };
in
  stdenv.mkDerivation {
    pname = "nvidia-nsight";
    inherit version;

    system = "x86_64-linux";
    inherit src;

    nativeBuildInputs = [
      dpkg
      makeWrapper
      qt6.wrapQtAppsHook
      autoPatchelfHook
      addDriverRunpath
    ];

    autoPatchelfIgnoreMissingDeps = ["libcuda.so.1" "libcudart.so.1"];

    buildInputs = [
      libglvnd
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
      xorg.libXfixes
      qt6.qtbase
      qt6.qtwayland
      qt6.qtwebengine
      qt6.qtcharts
      qt6.qtsvg
      libtiff
      alsa-lib
      fontconfig
      freetype
      glib
      vulkan-loader
    ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r opt/nvidia $out/

      # Fix permissions
      chmod +x $out/nvidia/nsight-graphics-for-linux/nsight-graphics-for-linux-${pathVersion}/host/linux-desktop-nomad-x64/ngfx
      chmod +x $out/nvidia/nsight-graphics-for-linux/nsight-graphics-for-linux-${pathVersion}/host/linux-desktop-nomad-x64/ngfx.bin

      # Create bin directory
      mkdir -p $out/bin

      # Wrap the main executable
      makeWrapper $out/nvidia/nsight-graphics-for-linux/nsight-graphics-for-linux-${pathVersion}/host/linux-desktop-nomad-x64/ngfx-ui \
        $out/bin/nsight-graphics \
        --prefix LD_LIBRARY_PATH : ${rpath}:$out/nvidia/nsight-graphics-for-linux/nsight-graphics-for-linux-${pathVersion}/host/linux-desktop-nomad-x64

      # Create Vulkan layer directory
      mkdir -p $out/share/vulkan/implicit_layer.d

      # Copy Vulkan layer manifests
      cp -r $out/nvidia/nsight-graphics-for-linux/nsight-graphics-for-linux-${pathVersion}/target/linux-desktop-nomad-x64/*/vulkan/implicit_layer.d/* \
        $out/share/vulkan/implicit_layer.d/

      # Create the .desktop file
      mkdir -p $out/share/applications

      cat > $out/share/applications/nsight-graphics.desktop <<EOF
      [Desktop Entry]
      Version=1.0
      Name=NVIDIA Nsight Graphics
      Comment=Graphics debugging and profiling tool for Direct3D, Vulkan, OpenGL, OpenVR, and Oculus SDK
      Exec=$out/bin/nsight-graphics
      Icon=nsight-graphics
      Terminal=false
      Type=Application
      Categories=Development;Graphics;Tools;
      EOF

      runHook postInstall
    '';

    meta = with lib; {
      description = "NVIDIA Nsight Graphics is a standalone developer tool with ray-tracing support that enables you to debug, profile, and export frames built with Direct3D, Vulkan, OpenGL, OpenVR, and the Oculus SDK.";
      homepage = "https://developer.nvidia.com/nsight-graphics";
      license = licenses.unfree;
      maintainers = with maintainers; [panaeon jraygauthier];
      platforms = ["x86_64-linux"];
    };
  }
