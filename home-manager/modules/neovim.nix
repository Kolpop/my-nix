{ pkgs, inputs, ... }:

{

  programs.neovim = {
    enable = true;
    package = with pkgs; [
      inputs.neovim.packages.${pkgs.system}.default
    ];
  };

}
