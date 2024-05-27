{
  buildNpmPackage,
  fetchFromGitHub,
  remarshal,
  ttfautohint-nox,
  nerd-font-patcher,
  stdenv,
  findutils,
  lib,
  darwin,
  privateBuildPlan ? null,
  extraParameters ? null,
  ...
}:
buildNpmPackage rec {
  version = "1.2.0";
  pname = "zed-mono";

  src = fetchFromGitHub {
    owner = "zackartz";
    repo = "zed-fonts";
    rev = "${version}";
    hash = "sha256-cGtkQ9BDY/nGUf81pwhOcEeLNyARHZMd9a++nw8CAE0=";
  };

  npmDepsHash = "sha256-M2GmTWEvNv485EdexDZoShuGeRmVvoGFV9EvQR3jE1c=";

  nativeBuildInputs =
    [
      remarshal
      ttfautohint-nox
      nerd-font-patcher
      findutils
    ]
    ++ lib.optionals stdenv.isDarwin [
      # libtool
      darwin.cctools
    ];

  buildPlan =
    if builtins.isAttrs privateBuildPlan
    then builtins.toJSON {buildPlans.${pname} = privateBuildPlan;}
    else privateBuildPlan;

  inherit extraParameters;
  passAsFile =
    ["extraParameters"]
    ++ lib.optionals
    (!(builtins.isString privateBuildPlan
      && lib.hasPrefix builtins.storeDir privateBuildPlan)) ["buildPlan"];

  configurePhase = ''
    runHook preConfigure
    ${lib.optionalString (builtins.isAttrs privateBuildPlan) ''
      remarshal -i "$buildPlanPath" -o private-build-plans.toml -if json -of toml
    ''}
    ${lib.optionalString (builtins.isString privateBuildPlan
      && (!lib.hasPrefix builtins.storeDir privateBuildPlan)) ''
      cp "$buildPlanPath" private-build-plans.toml
    ''}
    ${lib.optionalString (builtins.isString privateBuildPlan
      && (lib.hasPrefix builtins.storeDir privateBuildPlan)) ''
      cp "$buildPlan" private-build-plans.toml
    ''}
    ${lib.optionalString (extraParameters != null) ''
      echo -e "\n" >> params/parameters.toml
      cat "$extraParametersPath" >> params/parameters.toml
    ''}
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild
    npm run build --no-update-notifier -- --jCmd=$NIX_BUILD_CORES --verbose=9 ttf::zed-mono
    cd dist/zed-mono/ttf
    find . -type f -name "*.ttf" | xargs -P $NIX_BUILD_CORES -I {} nerd-font-patcher -c -s {}
    cd ../../../
    npm run build --no-update-notifier -- --jCmd=$NIX_BUILD_CORES --verbose=9 ttf::zed-sans
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -d "$fontdir"
    install "dist/zed-sans/ttf"/* "$fontdir"
    install "dist/zed-mono/ttf"/* "$fontdir"
    runHook postInstall
  '';

  enableParallelBuilding = true;

  # this is here because as of 2024-05-27 the offical build doesn't have good ligature support with kitty :/
  meta = with lib; {
    homepage = "https://zed.dev";
    downloadPage = "https://github.com/zed-industries/zed-fonts/releases";
    description = "Fonts for Zed Editor, based on Iosevka (with Nerd Font Patches)";
    longDescription = ''
      Zed Mono & Zed Sans are custom builds of Iosevka liscensed under the SIL Open Font License, Version 1.1.

      They are built for use in Zed. Zed Sans uses a quasi-proportional spacing to allow the font to still feel monospace while not having such wide gaps in a UI setting.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [
      zackartz
    ];
  };
}
