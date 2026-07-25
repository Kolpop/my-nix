{ config, pkgs, ... }:

{

  imports = [ ./happ-nixos/happ-module.nix ];

  services.happ.enable = true;

}
