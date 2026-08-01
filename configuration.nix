{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nixos/bundle.nix
    ./packages.nix
  ];

  networking.hostName = "AZERTY"; # Define your hostname.

  services.gvfs.enable = true;

  time.timeZone = "Asia/Yekaterinburg";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  i18n.defaultLocale = "ru_RU.UTF-8";

  system.stateVersion = "26.05"; # Мацуда не смей
}
