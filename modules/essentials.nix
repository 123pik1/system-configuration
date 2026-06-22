{ pkgs, ... }:
let
  HDD_UUID = "1f34911f-3641-4ee6-ae3c-c0d68ed0c218";
  SSD_CRUCIAL_UUID = "f0acba63-c3df-4903-8aeb-6ef9a2f51fa0";
  SSD_NVM_UUID = "6bba3d17-6829-4c9b-89af-8730f5728c80";
in
{
  # docker
  virtualisation.docker = {
    enable = true;
  };

  users.users.pik.extraGroups = [
    "docker"
    "nextcloud"
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };

  environment.systemPackages = [
    pkgs.yazi
    pkgs.fastfetch
    pkgs.cloudflared
    pkgs.javaPackages.compiler.temurin-bin.jdk-25
    pkgs.hdparm
    pkgs.php
    pkgs.yt-dlp
    pkgs.screen
    pkgs.python3
    pkgs.python3Packages.httpie
    pkgs.gh
    pkgs.git
  ];

  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/bin/hdparm -S 120 /dev/disk/by-uuid/${HDD_UUID}
  '';

  fileSystems."/mnt/2TB_storage_HDD" = {
    device = "/dev/disk/by-uuid/${HDD_UUID}";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  fileSystems."/mnt/1TB_storage_SSD" = {
    device = "/dev/disk/by-uuid/${SSD_CRUCIAL_UUID}";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  fileSystems."/mnt/0_5TB_internal_SSD" = {
    device = "/dev/disk/by-uuid/${SSD_NVM_UUID}";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };
}
