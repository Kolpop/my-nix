{ config, pkgs, ... }:

{

  programs.fish.enable = true;

  users.users.boris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ]; # Enable ‘sudo’ for the user.

    shell = pkgs.fish;

    packages = with pkgs; [];
  };

}
