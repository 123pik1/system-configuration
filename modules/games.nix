{ config, pkgs, ... }:
let
  playit-bin = pkgs.stdenv.mkDerivation {
    pname = "playit";
    version = "0.15.26";

    src = pkgs.fetchurl {
      url = "https://github.com/playit-cloud/playit-agent/releases/download/v0.15.26/playit-linux-amd64";
      sha256 = "sha256-238Ck3+/2Kazv3TT3qcwgl4kGWxrfcwCiqQQ2erZhl0=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/playit
      chmod +x $out/bin/playit
    '';
  };
in
{
  users.users.pik.extraGroups = [
    "input"
    "video"
    "render"
  ];

  environment.systemPackages = [
    playit-bin
  ];

  # On playit UDP is under 7636
  # Local ports:
  # UDP: 5864
  # MC: 5002
  systemd.services.playit = {
    description = "Playit.gg service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${playit-bin}/bin/playit";
      Restart = "always";

      User = "root";
      WorkingDirectory = "/home/pik/.config/playit_gg";
    };
  };

  virtualisation.oci-containers.containers.minecraft = {
    image = "itzg/minecraft-server";
    ports = [ "5002:25565" ];
    environment = {
      "EULA" = "TRUE";
      "MEMORY" = "4G";
      "ONLINE_MODE" = "FALSE";
    };

    volumes = [
      "/var/lib/minecraft:/data"
    ];
  };
  /*
    services.factorio = {
      enable = true;
      package = pkgs.factorio-headless;
      port = 5864;
      openFirewall = true;
      saveName = "mainSave";
      stateDirName = "factorio/";

      #extraArgs = [ "--disable-space-age" ];
    };
  */

}
