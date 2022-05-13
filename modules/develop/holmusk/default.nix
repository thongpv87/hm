{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.module.develop.holmusk;
  awsProfiles = {
    sit = "staging-FoodDX";
    uat = "prd-FoodDX";
    prd = "prd-FoodDX";
  };

  aliases = {
    aws-sit = "aws --profile=staging-FoodDX";
    aws-uat = "aws --profile=prd-FoodDX";
    aws-prd = "aws --profile=prd-FoodDX";
  };


  getEc2InstanceIdByTag =  pkgs.writeShellScriptBin "getEc2InstanceIdByTag" ''
    env=$1
    tag=$2

    case $env in
      sit) profile=staging-FoodDX;;
      uat) profile=prd-FoodDX;;
      prd) profile=prd-FoodDX;;
    esac

    aws --profile=$profile ec2 describe-instances --filters "Name=tag:Name,Values=$tag" --query "Reservations[].Instances[].InstanceId" | jq -r ".[0]"
  '';

  ssm-env = env:
    let
      profile = awsProfiles.${env};
    in pkgs.writeShellScriptBin "ssm-${env}" ''
        tag=$1
        instance_id=$(aws --profile=${profile} ec2 describe-instances --filters "Name=tag:Name,Values=$tag" --query "Reservations[].Instances[]" | jq -r '.[] | select(.State.Name == "running").InstanceId')
        aws --profile=${profile} ssm start-session --target $instance_id
    '';
in
{
  options = {
    module.develop.holmusk.enable = mkOption {
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #nodejs
      elmPackages.create-elm-app
      jq
      #terraform_1
      ngrok
      packer
      cargo
    ] ++ map ssm-env ["sit" "uat" "prd"];

    programs.zsh.shellAliases = aliases;
  };
}
