{ config, pkgs, ... }:

{

  programs.fish = {
    enable = true;
    
    shellAliases = {
      ll = "ls -lah";
      nix-switch = "sudo nixos-rebuild switch --flake /home/boris/nix";
      git-update = "git add ./ && git commit -m \"update\" && git push";
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
