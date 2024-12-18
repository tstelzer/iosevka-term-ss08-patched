{ stdenv, fetchzip, fetchFromGitHub, lib, fontforge, python3, zip }:

let
  pname = "Iosevka-Term-SS08";
  version = "v1.0.1";
  iosevkaVersion = "32.2.1";
  iosevkaFontName = "PkgTTF-IosevkaTermSS08";
  nerdFontVersion = "v3.3.0";
  fontVariants = [ "Regular" ];
in stdenv.mkDerivation rec {
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
  nerdFontsRepo = /home/ts/dev/code/ryanoasis/nerd-fonts;

  buildInputs = [ fontforge python3 zip ];

  buildPhase = ''
    mkdir -p $TMPDIR/patched
    prefix=IosevkaTermSS08

    cp $nerdFontsRepo/font-patcher $TMPDIR/font-patcher
    sed -i "1 s|^.*$|#!${python3}/bin/python3|" $TMPDIR/font-patcher
    chmod +x $TMPDIR/font-patcher

    for variant in ${lib.concatStringsSep " " fontVariants}; do
        file_name="$prefix-$variant.ttf"
        input_file="$TMPDIR/$file_name"
        patched_file="$TMPDIR/patched/$file_name"

        cp "$src/$file_name" "$input_file"

        if [ -f "$input_file" ]; then
            $TMPDIR/font-patcher \
              --glyphdir $nerdFontsRepo/src/glyphs \
              --complete \
              --outputdir $TMPDIR/patched \
              --makegroups 0 \
              "$input_file"
        else
            echo "Missing font file for variant: $variant"
            exit 1
        fi
    done

    mkdir -p $out/release/share/fonts/truetype/${pname}
    mv $TMPDIR/patched/* $out/release/share/fonts/truetype/${pname}/
  '';

  installPhase = ''
    zip -r $out/${pname}-${version}.zip $out/release
  '';
}
