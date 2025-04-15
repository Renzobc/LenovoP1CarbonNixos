# flake.nix
{
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/ad0b5ee";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "github:nix-community/home-manager/release-24.11";
    };

    # One can include out own flake as input.
  };
  # self is a reference to the flake itself
  outputs = inputs: let
    system = "x86_64-linux";
    stateVersion = "24.11";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;    
    };
  in {
    # configure home manager

    inputs.home-manager.nixosModules.home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    # nixos.System give all inputs to configuration.nix
nixosConfigurations."p1carbon" = inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ./configuration.nix
    ./renzo.nix
    ./renzobc.nix

    
    # nixpkgs.overlays = [
    #   (final: prev: {
    #     docker = import inputs.nixpkgs {
    #       inherit system;
    #       config.allowUnfree = true;
    #     };
    #   })
    # ];

    # nixpkgs.config.allowUnfree = true;
    # virtualisation.docker.package = pkgs.docker; # Uses the overlayed version
    
  ];

  specialArgs = {
    inherit stateVersion system;
  };
};

    formatter.${system} = pkgs.alejandra;
  };
}
