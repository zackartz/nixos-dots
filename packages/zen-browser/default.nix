let
  pkgs = import <nixpkgs> {};
  # I don't know if it needs gcc
in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      # TODO: Install from cargo? Or use this instead?
      rust-cbindgen
      # TODO: Install from cargo? Or use this instead?
      rust-bindgen

      alsa-lib
      cargo
      clang
      gcc
      libpulseaudio
      libclang
      llvm
      pkg-config
      python3
      rustc
    ];
  }
