{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    omp

    ollama

    poppler-utils

    #########
    # other #
    #########

    yt-dlp

    yazi

    # md viewer:
    glow

    # music
    cmus

    # system tellers
    btop

    # text file converter
    pandoc

    fzf
    ctags

    #######
    # fun #
    #######

    lolcat

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
