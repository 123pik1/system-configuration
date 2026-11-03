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

    # processing json inputs
    jq

    # java
    jdk21

    # C
    libgcc
    clang-tools
    gcc
    ftxui
    # for working clang
    bear

  ];
}
