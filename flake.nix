{
  description = "Iosevka Term SS08 Nerd Font";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = nixpkgs.lib.mkDerivation {
      pname = "iosevka-term-ss08-nerd-font";
      version = "v1.0.0";
      src = builtins.fetchTarball {
        url = "https://github.com/tstelzer/iosevka-term-ss08-patched/releases/download/${version}/release.tar.gz";
        sha256 = lib.fakeSha256;
      };

      installPhase = ''
        mkdir -p $out/share/fonts/truetype/
        cp -r $src/* $out/share/fonts/truetype/
      '';

      meta = with nixpkgs.lib; {
        description = "Nerd-font patched Iosevka Term SS08";
        license = licenses.ofl;
        platforms = platforms.all;
      };
    };
  };
}