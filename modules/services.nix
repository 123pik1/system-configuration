{config, pkgs, ... }:
let
  tunnel_1_id = "b06e963b-94ca-41c5-8b6e-1709b6125385";
  credentialsDir = "/var/lib/cloudflare-config";
  domain = "123pik1.ovh";
  channels = [
    "https://youtube.com/playlist?list=PL_6uqpqcFlzPOzm_tpvam1G_VDPZmDaHa&si=D5LlPgSJvC4zJM8K"
    "https://youtube.com/playlist?list=PL_6uqpqcFlzNfI9XLyYSNVAlYQN3HRUrY&si=Hi1MQpRc5IJLUnHK"
    "https://youtube.com/playlist?list=PL_6uqpqcFlzMPJBZ8ydL9F__9XbUj-GYN&si=mY-G4hlbDrmY6eKN"
    "https://youtube.com/playlist?list=PL_6uqpqcFlzM5I9OywWPqc0sTafV3zCBO&si=7J98YbjYPp6bDEp4"
    "https://youtube.com/playlist?list=PL_6uqpqcFlzMCJ4kadi22x-2h4dMtzvRn&si=eTzXHrhb8sbS0Pxo"
  ];
  cloudLogFile = "/home/pik/nextcloud.logs";
  cloudDataDir = "/mnt/1TB_storage_SSD/nextcloud";
  cloudBackupDir = "mnt/2TB_storage_HDD/nextcloud-backup";

  # Ports
  whiteboardPort = "7777";
  dashboardPort = "7575";
  wwwPort = "2137";
  sshPort = "22";
  nextcloudPort = "80";
  blogBackendPort = "9999";
  blogFrontendPot = "9998";
  gitPort = "8991";
  
in
{

    sops.secrets."discord_token" = {};

  sops.templates."discord_bot.env".content = ''
    DISCORD_TOKEN=${config.sops.placeholder.discord_token}
  '';

  sops.templates."blog_backend.env".content = ''
    SPRING_DATASOURCE_PASSWORD=${config.sops.placeholder.blog_db_password}
  '';


  services.cloudflared = {
    enable = true;
    tunnels = {
      "${tunnel_1_id}" = {
        credentialsFile = "${credentialsDir}/${tunnel_1_id}.json";
        default = "http_status:404";
        ingress = {
          "ssh.${domain}" = "ssh://localhost:${sshPort}";
          #        "factorio-server-manager.${domain}" = "http://localhost:5865";
          "nextcloud.${domain}" = "http://localhost:${nextcloudPort}";
          #"ami.${domain}" = "http://127.0.0.1:8080";
          "www.${domain}" = "http://127.0.0.1:${wwwPort}";
          #"dashboard.${domain}" = "http://127.0.0.1:${dashboardPort}";
          #"git.${domain}" = "http://127.0.0.1:6969";
          "whiteboard.${domain}" = "http://127.0.0.1:${whiteboardPort}";
          "api-blog.${domain}" = "http://127.0.0.1:${blogBackendPort}";
          "blog.${domain}" = "http://127.0.0.1:${blogFrontendPot}";
          "git.${domain}" = "http://127.0.0.1:${gitPort}";
          "handle-everything-else" = {
            service = "http_status:404";
          };
        };
      };
    };

  };

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.${domain}";
    package = pkgs.nextcloud33;

    database.createLocally = true;
    configureRedis = true;

    datadir = "${cloudDataDir}";

    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/etc/nixos/secrets/nextcloud-admin-pass";
    };

    maxUploadSize = "300G";
  };

  systemd.services.yt-dlp-download = {
    description = "Automatic download from YT";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    path = [
      pkgs.ffmpeg
      pkgs.yt-dlp
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "pik";
      ExecStart =
        "${pkgs.yt-dlp}/bin/yt-dlp "
        + "--extract-audio "
        + "--audio-format mp3 "
        + "--audio-quality 0 "
        + "--download-archive /mnt/2TB_storage_HDD/Music/archive.txt "
        + "--embed-thumbnail "
        + "--add-metadata "
        + "-o \"/mnt/2TB_storage_HDD/Music/%(uploader)s/%(title)s.%(ext)s\" "
        + "--ignore-errors "
        + (builtins.concatStringsSep " " channels);
    };
  };

  systemd.timers.yt-dlp-download = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "daily";
      Unit = "yt-dlp-download.service";
    };
  };

  systemd.services = {
    nextcloudBackup = {
      description = "Automatic backup for nextcloud";

      serviceConfig = {
        Type = "oneshot";
        User = "nextcloud";
        ExecStart = ''
          nextcloud-occ maintenance:mode --on
          echo "-- Backup start: ''$(date) -- " >> ${cloudLogFile}
          rsync -avh ${cloudDataDir}/ ${cloudBackupDir}/ >> ${cloudLogFile} 2>&1
          echo "-- Backup end: ''$(date) -- " >> ${cloudLogFile}
        '';
      };
    };
    myf-bot = {
      description = "Uploading discord bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.jre ];
      script = "java -jar /home/pik/bot/myfBot/myfBot.jar";
      
      serviceConfig = {
        WorkingDirectory = "/home/pik/bot";
        Restart = "always";
        User = "pik";
        EnvironmentFile = config.sops.templates."discord_bot.env".path;
      };
      
    };
  };

  systemd.timers.nextcloudBackup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "nextcloudBackup.service";
    };
  };

  # Recovery ways:
  # - watchdog (if for 30 minutes cannot ping 1.1.1.1 restarts)
  # - tailscale
  # - discord bot TODO
  #

  systemd.services.connectionWatchdog = {
    description = "Restarts server if internet is down";

    script = ''
      /run/current-system/sw/bin/systemctl is-active --quiet cloudflared-tunnel-b06e963b-94ca-41c5-8b6e-1709b6125385.service
      SERVICE_FAIL=$?

      if [ ! /run/current-system/sw/bin/ping -c 1.1.1.1 > /dev/null ] || [ $SERVICE_FAIL -ne 0 ]; then
        /run/current-system/sw/bin/systemctl restart  cloudflared-tunnel-b06e963b-94ca-41c5-8b6e-1709b6125385.service
      fi
    '';

    startAt = "*:0/5";
  };

  services.tailscale = {
    enable = true;
  };



  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      "whiteboard" = {
        image = "lovasoa/wbo:latest";
        ports = [
          "127.0.0.1:${whiteboardPort}:80"
        ];

        volumes = [
          "/var/lib/whiteboard:/opt/app/boards"
        ];
      };

    "blog-backend" = {
        image = "moj-blog:backendv1";
        extraOptions = [
          "--network=host"
        ];
        
        # Wczytujemy bezpiecznie hasło do bazy
        environmentFiles = [ 
          config.sops.templates."blog_backend.env".path 
        ];
        
        environment = {
          SPRING_DATASOURCE_URL = "jdbc:postgresql://127.0.0.1:5432/blog_db";
          SPRING_DATASOURCE_USERNAME = "blog_user";
          # USUNIĘTO SPRING_DATASOURCE_PASSWORD
          SPRING_JPA_HIBERNATE_DDL_AUTO = "validate";
          SERVER_PORT = "${blogBackendPort}";
        };
      };
      "blog-frontend" = {
        image = "blog-frontend:v4";
        ports = [
          "127.0.0.1:${blogFrontendPot}:3000"
        ];
      };

    };

  };

}
