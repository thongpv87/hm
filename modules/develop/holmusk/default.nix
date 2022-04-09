{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.module.develop.holmusk;
in
{
  options = {
    module.develop.holmusk.enable = mkOption {
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
      elmPackages.create-elm-app
      terraform_1
      ngrok
      packer
      cargo
    ];
  };
}
