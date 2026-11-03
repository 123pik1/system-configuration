{ pkgs, config, ... }:
{
  imports = [
    ../../modules/tool-sets/cli-tools.nix
    ../../modules/scripts.nix
    ../../modules/shell.nix
    ../../modules/neovim-conf.nix
  ];

  programs = {
    ssh = {
      enable = true;
    };
  };

  system.stateVersion = "24.05";

}
