{
    description = "Iosevka Term SS08 Nerd Font";
    outputs = { self, nixpkgs }:
        let
            name = "iosevka-term-ss08-nerd-font";
            version = "v1.0.1";
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in {
            packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
                inherit name version;
                src = pkgs.fetchzip {
                    url = "https://github.com/tstelzer/iosevka-term-ss08-patched/releases/download/${version}/Iosevka-Term-SS08-${version}.zip";
                    sha256 = "sha256-jwolBS3EXXzc44gPLP4R59b5qgPUjBOhTmQuFssJllI=";
                };

                installPhase = ''
                    cp -r $src/* $out/
                '';

                meta = with nixpkgs.lib; {
                    description = "Nerd-font patched Iosevka Term SS08";
                    license = licenses.ofl;
                    platforms = platforms.all;
                };
            };
        };
}
