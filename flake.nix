{
  description = "NixOS flake for P1 Carbon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/ad0b5ee";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs: let
    system = "x86_64-linux";
    stateVersion = "24.11";
    unstablePkgs = import nixpkgs-unstable { 
      inherit system; 
      config.allowUnfree = true;
    };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.p1carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        ./configuration.nix
        {
        nixpkgs.overlays = [
              (final: prev: {
                vscode = unstablePkgs.vscode;
              })
            ];
        }
        ./renzo.nix
        ./renzobc.nix
      ];

      specialArgs = {
        inherit stateVersion system;
      };
    };

    formatter.${system} = pkgs.alejandra;
  };
}
