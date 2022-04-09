{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [ ./modules ];
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
	 htop fortune
  ];

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    bash.profileExtra = ''
       ${lib.fileContents ./shell_profile}
    '';
  };

  module = {
  	 develop.haskell.enable = false;
	 develop.holmusk.enable = true;
	 fonts.enable = true;
	 shell.enable = true;
	 emacs.enable = true;
  };

  home.sessionVariables = {
  };

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      max-jobs = 10;
      cores = 0;
      sandbox = true;
      system-features = [ "big-parallel" "kvm" "recursive-nix" "benchmark" ];
    };
  };
}
