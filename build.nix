{ stdenv, fetchzip, fetchFromGitHub, lib, fontforge, python3, zip }:

let
  pname = "Iosevka-Term-SS08";
  version = "v1.0.0";
  iosevkaVersion = "32.2.1";
  iosevkaFontName = "PkgTTC-SGr-IosevkaTermSS08";
  nerdFontVersion = "v3.3.0";
  # Define the font variants to process
  fontVariants = [ "Regular" "Bold" ];
in stdenv.mkDerivation rec {
  inherit pname version;

  # Fetch the Iosevka font archive
  src = fetchzip {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${iosevkaVersion}/${iosevkaFontName}-${iosevkaVersion}.zip";
    sha256 = "sha256-vvf//5GTxCREEyOwJpuPWyybljvpDiySuVZFK8xgeGE=";
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
    mkdir -p $out/share/fonts/truetype/${pname}

    # Process only selected TTCs
    for variant in ${lib.concatStringsSep " " fontVariants}; do
      if [ -f $src/SGr-IosevkaTermSS08-$variant.ttc ]; then
        cp $src/SGr-IosevkaTermSS08-$variant.ttc $TMPDIR/font-$variant.ttc
      else
        echo "Missing font variant: $variant"
        exit 1
      fi
    done

    # Set up the Nerd Fonts repository
    cp -r ${nerdFontsRepo}/src/glyphs $TMPDIR/glyphs
    cp ${nerdFontsRepo}/font-patcher $TMPDIR/font-patcher
    chmod +x $TMPDIR/font-patcher

    # Fix the Python shebang in the font-patcher script
    sed -i "1 s|^.*$|#!${python3}/bin/python3|" $TMPDIR/font-patcher

    # Patch each TTC individually
    for variant in ${lib.concatStringsSep " " fontVariants}; do
      echo "Patching $variant..."
      output_file="$TMPDIR/patched/Iosevka-$variant.ttc"
      $TMPDIR/font-patcher --glyphdir $TMPDIR/glyphs \
        --complete \
        --outputdir $TMPDIR/patched \
        --makegroups 0 \
        $TMPDIR/font-$variant.ttc || { echo "Failed to patch $variant"; exit 1; }
      mv "$TMPDIR/patched/Iosevka Nerd Font.ttc" "$output_file" || {
        echo "Failed to rename output for $variant"
        exit 1
      }
    done

    # Verify and move patched fonts to the output directory
    echo "Generated fonts:"
    ls $TMPDIR/patched || { echo "No fonts generated in $TMPDIR/patched"; exit 1; }
    mv $TMPDIR/patched/*.ttc $out/share/fonts/truetype/${pname}/ || {
      echo "No fonts were moved!"
      exit 1
    }
  '';

  installPhase = ''
    # Prepare the release directory
    mkdir -p $out/release
    cp -r $out/share/fonts $out/release/
    cd $out/release

    # Create a release zip archive
    zip -r ${pname}-${version}.zip *
    echo "Release package created at $out/release/${pname}-${version}.zip"
  '';
}
