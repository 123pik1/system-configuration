{ pkgs, ... }:
{
  home.stateVersion = "25.05";
  # manual.backupFileExtension = "backup";

  imports = [
    ./../../modules/home-manager/hyprland/hyprland.nix
    ./../../modules/home-manager/browser.nix
  ];

  home.packages = [
    pkgs.atool
    pkgs.httpie
  ];

  programs.bash.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # images:
      "image/jpeg" = [ "geeqie.desktop" ];
      "image/png" = [ "geeqie.desktop" ];
      "image/gif" = [ "geeqie.desktop" ];
      "image/webp" = [ "geeqie.desktop" ];
      "image/tiff" = [ "geeqie.desktop" ];
      "image/bmp" = [ "geeqie.desktop" ];
      "image/x-adobe-dng" = [ "geeqie.desktop" ];

    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {

      "*" = {
        setEnv = {
          TERM = "xterm";
        };
      };

      "server" = {
        hostname = "ssh.123pik1.ovh";
        user = "pik";
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      };
      "local-server" = {
        hostname = "192.168.100.1";
        user = "pik";
      };
      "tailscale-server" = {
        hostname = "100.87.208.9";
        user = "pik";
      };
    };
  };

  programs.firefox.configPath = ".mozilla/firefox";
}
