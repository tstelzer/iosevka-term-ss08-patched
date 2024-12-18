{
    description = "Iosevka Term SS08 Nerd Font";
    outputs = { self, nixpkgs }:
        let
            pname = "iosevka-term-ss08-nerd-font";
            version = "v1.0.0";
        in {
            inherit pname version;
            defaultPackage.x86_64-linux = nixpkgs.lib.mkDerivation {
                src = builtins.fetchTarball {
                    url = "https://github.com/tstelzer/iosevka-term-ss08-patched/releases/download/${version}/Iosevka-Term-SS08-${version}.zip.tar.gz";
                    sha256 = "04lzjsf804ffpghlhrvncx2bcqz00i208hga1qf62xxak7pp8261";
                };

                installPhase = ''
                    install -D $src/**/*.ttc $out/share/fonts/truetype/${pname}/
                '';

                meta = with nixpkgs.lib; {
                    description = "Nerd-font patched Iosevka Term SS08";
                    license = licenses.ofl;
                    platforms = platforms.all;
                };
            };
        };
}
