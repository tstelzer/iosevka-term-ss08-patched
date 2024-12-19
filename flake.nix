{
  description = "Iosevka Term SS08 Nerd Font";
  outputs =
    { self, nixpkgs }:
    let
      name = "iosevka-term-ss08-nerd-font";
      version = "v1.0.2";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      default = pkgs.stdenv.mkDerivation {
        inherit name version;
        src = pkgs.fetchzip {
          url = "https://github.com/tstelzer/iosevka-term-ss08-patched/releases/download/${version}/Iosevka-Term-SS08-${version}.zip";
          sha256 = "sha256-RzZ8sKJ3anvrA51VGJYVrgzwPbAUcbqK/fG397yW/q0=";
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
