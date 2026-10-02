{ config, pkgs, ... }:

{
  systemd.services.mc-serwer = {
    description = "Prywatny serwer Minecraft";
    serviceConfig = {
      Type = "simple";
      User = "pik";
      WorkingDirectory = "/home/pik/mc-server/";
      ExecStart = "${pkgs.openjdk17}/bin/java -Xmx4G -jar mc-server.jar nogui";
      Restart = "no";
    };
  };
}
