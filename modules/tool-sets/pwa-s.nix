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
  environment.systemPackages = [
    ########
    # PWAS #
    ########
    pkgs.chromium
    dcPWA
    nextcloudPWA
    githubPWA
    whiteboardPWA
    dockerPWA
    enauczaniePWA
    geminiPWA

  ];
}
