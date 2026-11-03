{ pkgs, ... }:
{
  # nix-on-droid używa `environment.packages` zamiast `environment.systemPackages`
  environment.packages = with pkgs; [
    # podstawowe narzędzia
    git
    curl
    wget
    unzip
    fzf
    glow
    lazygit
    fastfetch

    # edytor
    neovim
  ];

  system.stateVersion = "24.05";
}
