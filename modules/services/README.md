# Moduły Usług Serwerowych (`modules/services/`)

Katalog zawiera deklaratywne definicje aplikacji i mikroserwisów uruchamianych na maszynie `server`.

---

## Spis Usług

| Plik | Usługa / Kontener | Port / Protokół | Ścieżki Danych | Opis |
| :--- | :--- | :--- | :--- | :--- |
| **[`ocis.nix`](ocis.nix)** | ownCloud Infinite Scale (OCI) | `9200` (HTTP) | `/mnt/1TB_storage_SSD/ocis` | Chmura plików (Go/CS3APIs) zastępująca Nextclouda. Działa w kontenerze OCI (Docker/Podman). Włączone `PROXY_ENABLE_BASIC_AUTH=true`. |
| **[`gitea.nix`](gitea.nix)** | Gitea (Git Service) | `8991` (HTTP) | `/mnt/0_5TB_internal_SSD/gitea` | Lekki serwer repozytoriów Git podpięty pod lokalną bazę PostgreSQL. Rejestracja publiczna zablokowana. |
| **[`mc.nix`](mc.nix)** | Minecraft Server | Port gry / Java | `/home/pik/mc-server/` | Usługa systemd uruchamiająca serwer Minecrafta w tle przy użyciu OpenJDK 25 z alokacją pamięci 4GB RAM (`-Xmx4G`). |
| **[`rebuild-switch.nix`](rebuild-switch.nix)** | Zdalna Przebudowa NixOS | Systemd oneshot | Ścieżka do Flake'a | Usługa `nixos-update-remote` pozwalająca na wywołanie `nixos-rebuild switch` w tle przez `systemd-run` bez konieczności trzymania otwartej sesji SSH. |

---

## Szczegóły Konfiguracji Usług

### 1. ownCloud Infinite Scale ([`ocis.nix`](ocis.nix))
* Usługa działa w kontenerze OCI zarządzanym przez NixOS:
  ```nix
  virtualisation.oci-containers.containers.ocis = {
    image = "docker.io/owncloud/ocis:latest";
    environment = {
      OCIS_URL = "https://drive.${domain}";
      PROXY_TLS = "false";
      PROXY_ENABLE_BASIC_AUTH = "true";
    };
    ports = [ "${drivePort}:9200" ];
  };
  ```
* **Katalogi montowane:**
  * `${dataDir}/config` → `/etc/ocis` (konfiguracja, certyfikaty)
  * `${dataDir}/storage` → `/var/lib/ocis` (magazyn metadanych i obiektów DecomposedFS)
  * `${dataDir}/log.log` → `/var/log/ocis.log`
* Dostęp publiczny realizowany jest przez Cloudflare Tunnel (`drive.123pik1.ovh`).

### 2. Gitea ([`gitea.nix`](gitea.nix))
* Natywna usługa NixOS (`services.gitea`).
* Stan danych przechowywany na dysku `/mnt/0_5TB_internal_SSD/gitea`.
* Baza danych PostgreSQL zarządzana przez system (`database.type = "postgres"`).

### 3. Serwer Minecraft ([`mc.nix`](mc.nix))
* Zdefiniowany jako jednostka systemd `mc-server.service`.
* Uruchamia plik `/home/pik/mc-server/mc-server.jar`.
* Umożliwia grę sieciową w połączeniu z agentem `playit` (`modules/games.nix`).

### 4. Zdalna Przebudowa (`rebuild-switch.nix`)
* Uruchamiana komendą:
  ```bash
  systemctl start nixos-update-remote
  ```
* Podgląd logów aktualizacji:
  ```bash
  journalctl -u nixos-update-remote -f
  ```
