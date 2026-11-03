{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # git
    git
    gh
    lazygit

    # for security of secret values in configuration
    sops

    # cli for trash
    trash-cli

    # fetch system info
    onefetch
    fastfetch

    # zip
    unzip
  ];
}
