{ pkgs, ... }:
let
  zimLibrary = "/mnt/1TB_storage_SSD/zim_archives";

  downloadArchWiki = pkgs.writeShellScriptBin "download_arch_wiki" ''
    mkdir -p "${zimLibrary}"
    cd "${zimLibrary}"
    echo "Szukanie najnowszego archiwum ArchWiki..."
    URL=$(${pkgs.curl}/bin/curl -sL "https://download.kiwix.org/zim/other/" | grep -oP 'href="\Karchlinux_en_all_maxi_[0-9-]+\.zim' | sort -V | tail -n 1)
    if [ -n "$URL" ]; then
      ${pkgs.wget}/bin/wget -c "https://download.kiwix.org/zim/other/$URL"
    else
      echo "Nie znaleziono pliku w other/, sprawdzam główny katalog zim..."
      URL=$(${pkgs.curl}/bin/curl -sL "https://download.kiwix.org/zim/" | grep -oP 'href="\Karchlinux_en_all_maxi_[0-9-]+\.zim' | sort -V | tail -n 1)
      ${pkgs.wget}/bin/wget -c "https://download.kiwix.org/zim/$URL"
    fi
  '';

  downloadNixWiki = pkgs.writeShellScriptBin "download_nix_wiki" ''
    mkdir -p "${zimLibrary}"
    cd "${zimLibrary}"
    echo "Szukanie najnowszego archiwum NixOS Wiki..."
    URL=$(${pkgs.curl}/bin/curl -sL "https://download.kiwix.org/zim/other/" | grep -oP 'href="\Knixos.*?[0-9-]+\.zim' | sort -V | tail -n 1)
    if [ -n "$URL" ]; then
      ${pkgs.wget}/bin/wget -c "https://download.kiwix.org/zim/other/$URL"
    else
      echo "Błąd: nie znaleziono pliku nixos*.zim na serwerze."
    fi
  '';

  downloadWiki_EN_nopic = pkgs.writeShellScriptBin "download_wiki_en_nopic" ''
    mkdir -p "${zimLibrary}"
    cd "${zimLibrary}"
    echo "Szukanie najnowszej Wikipedii EN (nopic)..."
    URL=$(${pkgs.curl}/bin/curl -sL "https://download.kiwix.org/zim/wikipedia/" | grep -oP 'href="\Kwikipedia_en_all_nopic_[0-9-]+\.zim' | sort -V | tail -n 1)
    if [ -n "$URL" ]; then
      echo "Pobieranie $URL (~50-60 GB)..."
      ${pkgs.wget}/bin/wget -c "https://download.kiwix.org/zim/wikipedia/$URL"
    else
      echo "Błąd: nie znaleziono pliku Wikipedii."
    fi
  '';
  port = 9999;

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
    wget

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

      Type = "exec";
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
