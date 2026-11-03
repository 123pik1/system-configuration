{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #############
    # languages #
    #############
    nixd
    nixfmt

    lua
    luajit

    python3
    python313Packages.pydbus
    python313Packages.black
    python3Packages.requests
    pkgs.python3Packages.httpie

    # processing json inputs
    jq

    # java
    jdk21

    # C
    libgcc
    clang-tools
    gcc
    ftxui

    # make
    gnumake

    # for working clang
    bear

    # typst
    typst
    typship
  ];
}
