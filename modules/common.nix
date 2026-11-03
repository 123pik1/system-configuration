{ pkgs, ... }:
{

  imports = [
    ./tool-sets/pwa-s.nix
    ./tool-sets/languages.nix
    ./tool-sets/net-tools.nix
  ];

  nixpkgs.config = {
    problems.handlers = {
      "gtk+".broken = "warn";
    };
  };

  environment.systemPackages = with pkgs; [
    antigravity-cli

    typst
    typship

    google-chrome

    texstudio

    traceroute

    ripdrag

    kdePackages.breeze

    onefetch

    # for security
    sops

    # normal things
    krita

    simple-scan

    anki

    fastfetch

    trash-cli
    wineWow64Packages.stable
    winetricks
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

  services.dbus.packages = [ pkgs.gcr_4 ];

  services.tailscale = {
    enable = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-filters ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };
  users.users.pik.extraGroups = [
    "scanner"
    "lp"
  ];

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

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # automatyczne uruchamianie adaptera przy starcie

  # Enable Blueman
  services.blueman.enable = true;
}
