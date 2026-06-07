{ config, pkgs, ... }:
let
  blog_db_user = "blog_user";
in
{
    sops.secrets."blog_db_password" = {
    
    };

sops.templates."blog-init.sql" = {
    content = ''
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '${blog_db_user}') THEN
          CREATE USER ${blog_db_user} WITH PASSWORD '${config.sops.placeholder.blog_db_password}';
        END IF;
      END $$;
      GRANT ALL PRIVILEGES ON DATABASE blog_db TO ${blog_db_user};
    '';
    owner = "postgres"; # Tylko baza danych może to przeczytać
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "blog_db" ];

    authentication = pkgs.lib.mkAfter ''
      local     blog_db     ${blog_db_user}                   md5
      host      blog_db     ${blog_db_user}   127.0.0.1/32    md5
      host      blog_db     ${blog_db_user}   ::1/128         md5
      host      blog_db     ${blog_db_user}   172.17.0.1/32   md5
    '';

    initialScript = config.sops.templates."blog-init.sql".path;
    settings = {
      listen_addresses = pkgs.lib.mkForce "*"; # "localhost, 172.17.0.1";
    };
  };
  systemd.services.postgresql.serviceConfig.ReadWritePaths = [
    "/mnt/0_5TB_internal_SSD/postgres_databases"
  ];

  services.postgresqlBackup = {
    enable = true;
    databases = [ "blog_db" ];
    location = "/home/pik/backup/"; # lub ścieżka na Twoim dysku SSD
    startAt = "*-*-* 01:15:00"; # Codziennie o 01:15
  };
}
