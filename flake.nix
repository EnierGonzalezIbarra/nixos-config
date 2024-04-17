{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Sugar candy for nix
    sddm-sugar-candy-nix.url = "github:MacKenzie779/sddm-sugar-candy-nix";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    matugen.url = "github:InioX/matugen";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";
    stm.url = "github:Aylur/stm";
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
  let
    inherit (self) outputs;
  in {
    name = "Enier Gonzalez Ibarra";
    username = "enier";
    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./home-manager/ags {inherit inputs;};
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          # asztal = self.packages.x86_64-linux.default;
        };
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
      proxiedNixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Use redsocks to implement a proxy <
        modules = [
          ./nixos/proxy.nix
          ./nixos/configuration.nix
          ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
     homeConfigurations = {
       "enier@nixos" = home-manager.lib.homeManagerConfiguration {
         pkgs = nixpkgs.legacyPackages.x86_64-linux;  #Home-manager requires 'pkgs' instance
         extraSpecialArgs = {
           inherit inputs outputs;
           # asztal = self.packages.x86_64-linux.default;
         };
          # > Our main home-manager configuration file <
         modules = [./home-manager/home.nix];
       };
     };
  };
}
