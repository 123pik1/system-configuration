# Moduły Usług Serwerowych (`modules/services/`)

Katalog zawiera deklaratywne definicje aplikacji, kontenerów OCI oraz mikroserwisów uruchamianych na maszynie `server`.

---

## Spis Usług

| Plik | Usługa / Kontener | Port / Protokół | Ścieżki Danych | Opis |
| :--- | :--- | :--- | :--- | :--- |
| **[`ocis.nix`](ocis.nix)** | ownCloud Infinite Scale (OCI) | `9200` (HTTP) | `/mnt/0_5TB_internal_SSD/ocis_data/ocis/` | Nowoczesna chmura plików (Go/CS3APIs) zastępująca Nextclouda. Działa w kontenerze OCI (Docker). Posiada automatyczną kopię rclone o 03:00. |
| **[`kiwix.nix`](kiwix.nix)** | Kiwix ZIM Server | `5555` (HTTP) | `/mnt/1TB_storage_SSD/zim_archives` | Serwer wiedzy offline udostępniający archiwa `.zim` (Wikipedia, ArchWiki, NixOS Wiki). Zawiera skrypty automatycznego pobierania. |
| **[`ollama.nix`](ollama.nix)** | Ollama LLM Service | `11111` (HTTP) | Domyślna baza Ollama | Lokalny serwer sztucznej inteligencji w wariancie CPU (`pkgs.ollama-cpu`) z automatycznie pobieranym i załadowanym modelem `qwen2.5:3b`. |
| **[`gitea.nix`](gitea.nix)** | Gitea (Git Service) | `8991` (HTTP) | `/mnt/0_5TB_internal_SSD/gitea` | Lekki serwer repozytoriów Git podpięty pod lokalną bazę PostgreSQL. Rejestracja publiczna zablokowana. |
| **[`mc.nix`](mc.nix)** | Minecraft Server | Port gry / Java | `/home/pik/mc-server/` | Usługa systemd uruchamiająca serwer Minecrafta w tle przy użyciu OpenJDK 25 Temurin z alokacją pamięci 4GB RAM (`-Xmx4G`). |
| **[`rebuild-switch.nix`](rebuild-switch.nix)** | Zdalna Przebudowa NixOS | Systemd oneshot | Ścieżka do Flake'a | Usługa `nixos-update-remote` pozwalająca na wywołanie `nixos-rebuild switch` w tle przez `systemd-run` bez konieczności podtrzymywania sesji SSH. |

---

## Szczegóły Konfiguracji Usług

### 1. ownCloud Infinite Scale ([`ocis.nix`](ocis.nix))
* Usługa działa w kontenerze OCI zarządzanym przez Dockera:
  ```nix
  virtualisation.oci-containers.containers.ocis = {
    image = "docker.io/owncloud/ocis:latest";
    environment = {
      OCIS_URL = "https://drive.${domain}";
      OCIS_INSECURE = "true";
      OCIS_LOG_LEVEL = "warn";
      PROXY_TLS = "false";
      PROXY_ENABLE_BASIC_AUTH = "true";
    };
    ports = [ "127.0.0.1:${drivePort}:9200" ];
  };
  ```
* **Katalogi montowane:**
  * `${dataDir}/config` → `/etc/ocis` (konfiguracja, certyfikaty)
  * `${dataDir}/storage` → `/var/lib/ocis` (magazyn metadanych i obiektów DecomposedFS)
  * `${dataDir}/log.log` → plik dziennika operacji
* **Kopie zapasowe (`systemd.services.ocisBackup`):**
  * Codziennie o `03:00:00` wykonywana jest synchronizacja katalogu danych do `${backupDir}` (`/mnt/2TB_storage_HDD/ocis-backup`) przy pomocy `rclone sync`.
* **Dostęp publiczny:**
  * Realizowany przez Cloudflare Tunnel (`drive.123pik1.ovh`).

---

### 2. Kiwix ZIM Server ([`kiwix.nix`](kiwix.nix))
* Usługa systemd `kiwix-serve.service` serwująca bazy wiedzy offline w formacie `.zim` na porcie `5555`.
* **Bezpieczeństwo i piaskownica systemd:**
  * Dedykowany użytkownik i grupa `kiwix`.
  * `ProtectSystem = "strict"`, `ProtectHome = true`, `NoNewPrivileges = true`, `PrivateTmp = true`.
  * Dostęp do katalogu `/mnt/1TB_storage_SSD/zim_archives` w trybie tylko do odczytu (`ReadOnlyPaths`).
* **Dołączone skrypty pobierania archiwów:**
  * `download_arch_wiki` – automatycznie wyszukuje i pobiera najnowsze archiwum ArchWiki (`archlinux_en_all_maxi_*.zim`).
  * `download_nix_wiki` – pobiera oficjalne archiwum NixOS Wiki (`nixos*.zim`).
  * `download_wiki_en_nopic` – pobiera pełną anglojęzyczną Wikipedię w wersji bez grafik (`wikipedia_en_all_nopic_*.zim`, ~50-60 GB).

---

### 3. Ollama LLM Service ([`ollama.nix`](ollama.nix))
* Deklaratywna usługa systemowa `services.ollama` działająca na maszynie serwerowej:
  ```nix
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cpu;
    host = "127.0.0.1";
    port = 11111;
    loadModels = [ "qwen2.5:3b" ];
  };
  ```
* **Zmienne środowiskowe:**
  * `OLLAMA_HOST = "127.0.0.1:11111"`
  * `OLLAMA_NAME = "qwen2.5:3b"`
* Pozwala na lokalne zapytania AI bez obciążania zasobów GPU i bez konieczności korzystania z zewnętrznych chmur.

---

### 4. Gitea ([`gitea.nix`](gitea.nix))
* Natywna usługa NixOS (`services.gitea`) na porcie `8991`.
* Dane repozytoriów przechowywane na szybkim dysku SSD: `/mnt/0_5TB_internal_SSD/gitea`.
* Relacyjna baza danych: PostgreSQL (`database.type = "postgres"`).
* Wyłączona otwarta rejestracja dla zachowania pełnej prywatności.

---

### 5. Serwer Minecraft ([`mc.nix`](mc.nix))
* Zdefiniowany jako usługa systemd `mc-server.service`.
* Uruchamia plik `/home/pik/mc-server/mc-server.jar` z parametrami Java 25:
  ```bash
  ${pkgs.javaPackages.compiler.temurin-bin.jdk-25}/bin/java -Xmx4G -Xms4G -jar mc-server.jar --nogui
  ```
* Bezpieczny dostęp sieciowy zapewniany przez agenta `playit` (`modules/games.nix`), eliminujący konieczność przekierowywania portów na routerze.

---

### 6. Zdalna Przebudowa (`rebuild-switch.nix`)
* Uruchamiana komendą:
  ```bash
  systemctl start nixos-update-remote
  ```
* Podgląd logów aktualizacji w czasie rzeczywistym:
  ```bash
  journalctl -u nixos-update-remote -f
  ```
