{
  stdenv,
  fetchzip,
  fetchFromGitHub,
  lib,
  fontforge,
  python3,
  zip,
  nerd-font-patcher,
}:

let
  pname = "Iosevka-Term-SS08";
  version = "v1.0.3";
  iosevkaVersion = "32.3.1";
  iosevkaFontName = "PkgTTF-IosevkaTermSS08";
  # nerdFontVersion = "v3.3.0";
  fontVariants = [
    "Bold"
    "BoldItalic"
    "Medium"
    "MediumItalic"
    "Regular"
    "Italic"
    "Light"
    "LightItalic"
    "Thin"
    "ThinItalic"
  ];
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${iosevkaVersion}/${iosevkaFontName}-${iosevkaVersion}.zip";
    sha256 = "sha256-sjB5G1PeMV0DD4yEy1ps0tvdPN7tBI1O6wWylB/TtlU=";
    stripRoot = false;
  };

  # Use a local Nerd Fonts repository for faster development
  # Replace with the fetchTarball section below for production
  # nerdFontsRepo = fetchTarball {
  #   url = "https://github.com/ryanoasis/nerd-fonts/archive/${nerdFontVersion}.tar.gz";
  #   sha256 = "sha256-oGcczfkPSB2JjwCTOuH9ewo2XLhmBBPOxI9iwB5NkmI=";
  # };
  # nerdFontsRepo = /home/ts/dev/code/ryanoasis/nerd-fonts;

  nativeBuildInputs = [
    nerd-font-patcher
    fontforge
    zip
    python3
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $TMPDIR/patched
    chmod -R u+rwX $TMPDIR/patched
    prefix="IosevkaTermSS08"

    for variant in ${lib.concatStringsSep " " fontVariants}; do
        file_name="$prefix-$variant.ttf"
        input_file="$TMPDIR/$file_name"
        patched_file="$TMPDIR/patched/$file_name"
        cp "$src/$file_name" "$input_file"

        nerd-font-patcher \
            --complete \
            --makegroups 4 \
            --no-progressbars \
            --quiet \
            --outputdir $TMPDIR/patched \
            "$input_file"
    done

    mkdir -p $out/release/share/fonts/truetype/${pname}
    mv $TMPDIR/patched/* $out/release/share/fonts/truetype/${pname}/

    runHook postBuild
  '';

  installPhase = ''
    zip -r $out/${pname}-${version}.zip $out/release
  '';
}
