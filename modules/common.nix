{ pkgs, ... }:
let
  # PWAS
  dcPWA = pkgs.makeDesktopItem {
    name = "discord-pwa";
    desktopName = "Discord (Chromium PWA)";
    # Use --app to hide the browser UI and --class for your NixOS window rules
    exec = "${pkgs.chromium}/bin/chromium --app=https://discord.com/app --class=discord-pwa";
    icon = "discord";
    terminal = false;
    categories = [
      "Network"
      "Chat"
    ];
  };

  nextcloudPWA = pkgs.makeDesktopItem {
    name = "nextcloud";
    desktopName = "nextcloud";

    exec = "${pkgs.chromium}/bin/chromium --app=http://nextcloud.123pik1.ovh --enable-features=UseOzonePlatform --ozone-platform-hint=auto";
    terminal = false;
    categories = [
    ];
  };

  githubPWA = pkgs.makeDesktopItem {
    name = "github";
    desktopName = "github";

    exec = "${pkgs.chromium}/bin/chromium --app=https://github.com/dashboard";
    terminal = false;
  };

  whiteboardPWA = pkgs.makeDesktopItem {
    name = "whiteboard";
    desktopName = "whiteboard";

    exec = "${pkgs.chromium}/bin/chromium --app=http://whiteboard.123pik1.ovh";
    terminal = false;
  };

  dockerPWA = pkgs.makeDesktopItem {
    name = "docker-pwa";
    desktopName = "docker (PWA)";

    exec = "chromium --app=\"https://hub.docker.com/search\"";
    terminal = false;
  };

  enauczaniePWA = pkgs.makeDesktopItem {
    name = "enauczanie";
    desktopName = "enauczanie";

    exec = "chromium --app=\"https://enauczanie.pg.edu.pl\"";
    terminal = false;
  };

  geminiPWA = pkgs.makeDesktopItem {
    name = "gemini-pwa";
    desktopName = "gemini (PWA)";

    exec = "chromium --app=https://gemini.google.com/app";
    terminal = false;
  };

in
{
    


  environment.systemPackages = with pkgs; [

    ripdrag

    kdePackages.breeze

    onefetch

    # for security
    sops

    # normal things
    krita

    simple-scan
    obs-studio

    anki

    fastfetch

    trash-cli
    wineWow64Packages.stable
    winetricks
    refine
    # Partition management
    kdePackages.partitionmanager
    kdePackages.kpmcore
    kdePackages.extra-cmake-modules
    gparted

    #############
    # net tools #
    #############
    wget
    wireshark
    postman
    #################
    # Communicators #
    #################

    # discord
    discord-ptb

    #########
    # other #
    #########

    # waydroid++ - does not work
    # waydroid-script

    # md viewer:
    glow

    # photo
    imv
    swayimg


    # make
    gnumake

    # music
    cmus


    # system tellers
    btop

    # PDF and POSTSCRIPT
    gv

    # text file converter
    pandoc

    # git
    git
    gh
    lazygit

    # zip
    unzip

    # virtualization
    qemu
    docker
    docker-compose
    virt-manager

    tcpreplay
    


    lazydocker

    # office things
    onlyoffice-desktopeditors

    # micro jump plugin dependiences
    fzf
    ctags

    # micro preview markdown plugin dependiences
    grip

    #############
    # languages #
    #############
    nixd
    lua
    luajit

    ghdl
    # .vcd show
    gtkwave

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

    # EFI
    gnu-efi

    #######
    # fun #
    #######

    lolcat

    #########
    # games #
    #########

    gamescope
    moonlight-qt
    heroic

    #############
    # terminals #
    #############
    kdePackages.konsole
    kitty
    cool-retro-term

    ########
    # PWAS #
    ########
    chromium
    dcPWA
    nextcloudPWA
    githubPWA
    whiteboardPWA
    dockerPWA
    enauczaniePWA
    geminiPWA

  ];

  programs = {

    # Steam:
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };

    firefox = {
      enable = true;
    };

    gamemode.enable = true;

    gamescope.enable = true;

  };

  boot.kernelModules = [
    "binder_linux"
    "ashmem_linux"
  ];

  virtualisation = {
    waydroid = {
      enable = true;
    };
    docker = {
      enable = true;
    };
  };
  nixpkgs.config.permittedInsecurePackages = [
    "electron-36.9.5"
  ];
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.dbus.packages = [ pkgs.gcr ];

  services.tailscale = {
    enable = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  services.printing = {
  enable = true;
  drivers = [pkgs.cups-filters];
  };
services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
};
hardware.sane = {
enable = true;
extraBackends = [pkgs.sane-airscan];
};
users.users.pik.extraGroups = ["scanner" "lp"];

programs.direnv = {
enable = true;
nix-direnv.enable = true;
};


# Wyłącz PulseAudio (wchodzi w konflikt z PipeWire)
services.pulseaudio.enable = false;
security.rtkit.enable = true;

# Włącz PipeWire z obsługą protokołu Pulse
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};

# Włącz Bluetooth
hardware.bluetooth.enable = true;
hardware.bluetooth.powerOnBoot = true; # automatyczne uruchamianie adaptera przy starcie

# Włącz Blueman (bardzo wygodny interfejs graficzny dla Waylanda/Hyprlanda)
services.blueman.enable = true;
}
