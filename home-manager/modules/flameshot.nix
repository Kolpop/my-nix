{ config, pkgs, ... }:

{

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
	showDesktopNotification = false;
      };
    };
  };


}
