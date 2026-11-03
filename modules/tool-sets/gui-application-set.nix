/*
  Set of apps that needs gui and to configure gui
  Other terminal emulators are alos there
*/
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    # ############
    # terminals #
    #############
    kdePackages.konsole
    kitty
    cool-retro-term

    #########
    # games #
    #########
    gamescope
    moonlight-qt
    heroic

    # office things
    onlyoffice-desktopeditors

    # photo
    imv
    swayimg

    # Partition management
    kdePackages.partitionmanager
    kdePackages.kpmcore
    kdePackages.extra-cmake-modules
    gparted

    # anki
    anki

    # image editor
    krita

    kdePackages.breeze

    wineWow64Packages.stable
    winetricks

    # Dedicated tex editor
    texstudio

    # browsers
    google-chrome
    firefox

    # dragging files in terminal?? maybe move to terminal apps?
    ripdrag

    # to scan
    simple-scan

    # communicators
    discord-ptb

    # PDF and POSTSCRIPT
    gv
  ];
}
