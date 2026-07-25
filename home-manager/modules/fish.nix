{ config, pkgs, ... }:

{

  programs.fish = {
    enable = true;
    
    shellAliases = {
      ll = "ls -lah";
      nix-switch = "sudo nixos-rebuild switch --flake /home/boris/nix";
    };

    plugins = [
      {
	name = "fzf-fish";
	src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
	name = "bobthefish";
	src = pkgs.fishPlugins.bobthefish.src;
      }
    ];
  };

}
