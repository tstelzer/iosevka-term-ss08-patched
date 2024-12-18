{
    description = "Iosevka Term SS08 Nerd Font";
    outputs = { self, nixpkgs }:
        let
            pname = "iosevka-term-ss08-nerd-font";
            version = "v1.0.1";
        in {
            inherit pname version;
            default = nixpkgs.lib.mkDerivation {
                src = builtins.fetchZip {
                    url = "https://github.com/tstelzer/iosevka-term-ss08-patched/releases/download/${version}/Iosevka-Term-SS08-${version}.zip";
                    sha256 = nixpkgs.lib.fakeSha256;
                };

                installPhase = ''
                    install -m444 -Dt $out/share/fonts/truetype/${pname} $src/**/*.ttf
                '';

                meta = with nixpkgs.lib; {
                    description = "Nerd-font patched Iosevka Term SS08";
                    license = licenses.ofl;
                    platforms = platforms.all;
                };
            };
        };
}
