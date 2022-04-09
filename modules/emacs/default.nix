{ config, lib, pkgs, emacs-overlay, ... }:
with lib;
let
  cfg = config.module.emacs;
in
{
  options = {
    module.emacs = {
      enable = mkOption {
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ sqlite ispell multimarkdown libgccjit ];
    nixpkgs.overlays = [ emacs-overlay ];
    programs.emacs = {
      enable = true;
      package = pkgs.emacsGcc;
      extraPackages = (epkgs: with epkgs; [ vterm ]);
    };

    services = {
      emacs = {
        enable = false;
        socketActivation.enable = true;
        client.enable = true;
      };
    };
  };
}
