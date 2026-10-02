{ config, pkgs, ... }:

{
  systemd.services.mc-server = {
    description = "Minecraft server in background";
    serviceConfig = {
      Type = "simple";
      User = "pik";
      WorkingDirectory = "/home/pik/mc-server/";
      ExecStart = "${pkgs.openjdk17}/bin/java -Xmx4G -jar mc-server.jar nogui";
      Restart = "no";
    };
  };
}
