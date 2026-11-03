{ pkgs, ... }:
{

  imports = [
    ./tool-sets/pwa-s.nix
    ./tool-sets/languages.nix
    ./tool-sets/net-tools.nix
    ./tool-sets/common-tools.nix
    ./tool-sets/gui-application-set.nix
    ./tool-sets/cli-tools.nix
    ./tool-sets/virtualisation-tools.nix
  ];

  nixpkgs.config = {
    problems.handlers = {
      "gtk+".broken = "warn";
    };
  };

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
