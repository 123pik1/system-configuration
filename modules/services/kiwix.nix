{ pkgs, ... }:
let
  zimLibrary = "/mnt/1TB_STORAGE_SSD/zim_archives";

  downloadArchWiki = pkgs.writeShellScriptBin "downloadArchWiki" ''
    mkdir -p "${zimLibrary}"
    cd ${zimLibrary}
    wget https://download.kiwix.org/zim/other/archlinux_en_all_maxi.zim
  '';

  downloadNixWiki = pkgs.writeShellScriptBin "downloadNixWiki" ''
    mkdir -p "${zimLibrary}"
    cd ${zimLibrary}
    wget https://download.kiwix.org/zim/other/nixos_en_all_maxi.zim
  '';

  downloadWiki_EN_nopic = pkgs.writeShellScriptBin "downloadWiki_EN_nopic" ''
    mkdir -p "${zimLibrary}"
    cd ${zimLibrary}
    wget https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_nopic.zim
  '';

  port = 7777;

in
{
  systemd.tmpfiles.rules = [
    "d ${zimLibrary} 0755 kiwix kiwix -"
  ];

  users.users.kiwix = {
    isSystemUser = true;
    group = "kiwix";
    home = zimLibrary;
    createHome = false;
  };
  users.groups.kiwix = { };

  environment.systemPackages = with pkgs; [
    kiwix-tools

    # Download wikis
    downloadWiki_EN_nopic
    downloadNixWiki
    downloadArchWiki
  ];

  systemd.services.kiwix-serve = {
    description = "Kiwix ZIM server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = "10s";

      Type = "Exec";
      User = "kiwix";
      Group = "kiwix";
      WorkingDirectory = zimLibrary;

      ProtectSystem = "strict";
      ProtectHome = true;
      ReadOnlyPaths = [ zimLibrary ];
      NoNewPrivileges = true;
      PrivateTmp = true;

      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '${pkgs.kiwix-tools}/bin/kiwix-serve --port=${toString port} ${zimLibrary}/*.zim'
      '';

    };
  };
}
