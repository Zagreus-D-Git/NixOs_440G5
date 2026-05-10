{
  description = "HP ProBook 440 G5 — NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # home-manager pinned to same release — disabled for now, uncomment when needed
    # home-manager = {
    #   url = "github:nix-community/home-manager/release-25.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.probook440g5 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hardware-configuration.nix
        ./modules/boot.nix
        ./modules/hardware.nix
        ./modules/performance.nix
        ./modules/desktop.nix
        ./modules/services.nix
        ./modules/packages.nix
        ./modules/users.nix
      ];
    };
  };
}
