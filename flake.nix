{
  description = "123pik1's flake nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      nixvim,
      sops-nix,
      ...
    }@inputs:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
    in
    {
      nixosConfigurations = {
        pik-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            useHomeManager = true;
          };
          modules = [
            ./hosts/laptop/configuration.nix
            { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
            home-manager.nixosModules.home-manager
            nixvim.nixosModules.nixvim
            ./users/pik/default.nix
            sops-nix.nixosModules.sops
          ];
        };

        server = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            useHomeManager = false;
          };
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
            home-manager.nixosModules.home-manager
            ./hosts/server/configuration.nix
            nixvim.nixosModules.nixvim

            ./users/pik/default.nix
            sops-nix.nixosModules.sops
          ];
        };


      };
      devShells.${system} = {
        default = import ./shells/tauri.nix {inherit pkgs;};
        nids = import ./shells/ml-nids.nix { inherit pkgs; };
        java = import ./shells/java.nix {inherit pkgs;};
        angular = import ./shells/angular.nix {inherit pkgs; };
        svelte = import ./shells/svelte.nix {inherit pkgs;};
        latex = import ./shells/latex.nix {inherit pkgs;};
        android = import ./shells/android.nix {inherit pkgs;};
        rust = import ./shells/rust.nix {inherit pkgs;};
        cpp = import ./shells/cpp.nix {inherit pkgs;};
        tauri = import ./shells/tauri.nix {inherit pkgs;};
      };
    };

}
