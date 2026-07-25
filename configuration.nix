# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixos/bundle.nix
      ./packages.nix
    ];

  networking.hostName = "AZERTY"; # Define your hostname.

  time.timeZone = "Asia/Yekaterinburg";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  i18n.defaultLocale = "ru_RU.UTF-8";

  system.stateVersion = "26.05"; # Did you read the comment?

}

