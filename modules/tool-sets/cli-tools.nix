{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    antigravity-cli

    #########
    # other #
    #########

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

  ];
}
