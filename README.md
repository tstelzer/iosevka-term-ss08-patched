## With flakes

```nix
# your host flake.nix
{
    inputs = {
        # ... other inputs
        iosevka-term-ss08-patched.url = "github:tstelzer/iosevka-term-ss08-patched";
    };
    outputs = { /* ... other inputs ... */ iosevka-term-ss08-patched, ... } @inputs:
        let
            # ... other bindings
            specialArgs = {
                inherit inputs;
                iosevka-term-ss08-patched = iosevka-term-ss08-patched.default;
            };
        in {
                nixosConfigurations = {
                    my-cool-system = nixpkgs.lib.nixosSystem {
                        inherit system specialArgs;
                        modules = [
                            # ...
                        ];
                    };
        };
}
```
