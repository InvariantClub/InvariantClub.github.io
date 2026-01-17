{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt = {
        # JS
        programs.biome.enable = true;
        # Nix
        programs.nixpkgs-fmt.enable = true;
      };
    };
}
