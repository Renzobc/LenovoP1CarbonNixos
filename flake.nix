# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # One can include out own flake as input.
  };
  # self is a reference to the flake itself
  outputs = inputs: let
    system = "x86_64-linux";
    stateVersion = "24.05";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # nixos.System give all inputs to configuration.nix
    nixosConfigurations."p1carbon" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./configuration.nix
        ./renzo.nix
        ./renzobc.nix
      ];
      specialArgs = {
        inherit stateVersion pkgs system;
      };
    };
    formatter.${system} = pkgs.alejandra;
  };
}
