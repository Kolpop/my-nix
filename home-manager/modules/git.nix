{ config, pkgs, ... }:

{

  programs.git = {
    enable = true;
    userName = "Kolpop";
    userEmail = "zknazev17@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

}
