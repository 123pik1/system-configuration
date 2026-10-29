{
  pkgs,
  drivePort,
  dataDir,
  backupDir,
  domain,
  ...
}:
let

  configDir = "${dataDir}/config";
  storageDir = "${dataDir}/storage";
  logFile = "${dataDir}/log.log";
in
{

  virtualisation.oci-containers.containers.ocis = {
    image = "docker.io/owncloud/ocis:latest";
    autoStart = true;

    environment = {
      OCIS_URL = "https://drive.${domain}";
      OCIS_INSECURE = "true";
      OCIS_LOG_LEVEL = "warn";
      PROXY_TLS = "false";
      PROXY_ENABLE_BASIC_AUTH = "true";
    };
    volumes = [
      "${configDir}:/etc/ocis"
      "${storageDir}:/var/lib/ocis"
    ];
    ports = [
      "127.0.0.1:${drivePort}:9200"
    ];
  };

  systemd.services.ocisBackup = {
    description = "Automatic backup for oCIS";

    startAt = "*-*-* 03:00:00";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = pkgs.writeShellScript "ocis-backup-script" ''
        echo "-- Backup start: $(${pkgs.coreutils}/bin/date) -- " >> ${logFile}

        ${pkgs.systemd}/bin/systemctl stop docker-ocis.service

        ${pkgs.rsync}/bin/rsync -aXvh --delete ${storageDir}/ ${backupDir}/ >> ${logFile} 2>&1

        ${pkgs.systemd}/bin/systemctl start docker-ocis.service

        echo "-- Backup end: $(${pkgs.coreutils}/bin/date) -- " >> ${logFile}
      '';
    };
  };

  environment.systemPackages = [ pkgs.rclone ];

}
