{
  description = "Home Manager configuration of Thong Pham";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacsCommunity.url = "github:nix-community/emacs-overlay";
  };

  outputs = { home-manager, emacsCommunity, ... }:
    let
      system = "aarch64-darwin";
      username = "thongpv87";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./home.nix;
        homeDirectory = "/Users/${username}";

        inherit system username;

        # Update the state version as needed.
        # See the changelog here:
        # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
        stateVersion = "22.05";

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
	extraSpecialArgs = {
	    emacs-overlay = emacsCommunity.overlay;
	};
      };
    };
}
