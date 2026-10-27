# Dokumentacja Maszyn (`hosts/`)

Katalog zawiera definicje poszczególnych systemów NixOS zarządzanych przez Flake. Każdy podkatalog odpowiada jednej maszynie i zawiera specyfikację sprzętową (`hardware-configuration.nix`) oraz konfigurację systemową (`configuration.nix`).

---

## 1. pik-laptop ([`hosts/laptop/`](laptop/))

Główna stacja robocza zoptymalizowana pod kątem programowania, multimediów i elastycznego zarządzania energią.

### Główne cechy:
* **Środowisko graficzne:** [Hyprland](../modules/window-manager.nix) (Wayland) zintegrowany z Waybar, Wlogout i Yazi.
* **Karty graficzne (Hybrid Graphics):**
  * AMD iGPU + NVIDIA RTX (dGPU) ze sterownikami `open = true` i technologią PRIME Sync (`modules/gpu.nix`).
* **Specjalizacje zasilania (`modules/specializations.nix`):**
  * `battery-mode` – profil oszczędzania energii dostępny przy starcie systemu. Blokuje moduły jądra NVIDIA (`nouveau`, `nvidia`, `nvidia_drm`), zmusza system do pracy wyłącznie na zintegrowanej grafice AMD oraz obniża taktowanie CPU.
* **Zarządzanie energią:** `auto-cpufreq` automatycznie optymalizujący profile pracy na baterii i zasilaczu.
* **Dźwięk i łączność:** Pipewire, Bluetooth, NetworkManager z obsługą sieci uniwersyteckiej (certyfikaty `eduroam` wstrzykiwane przez sops-nix).
* **Bootloader:** `systemd-boot` (obsługa EFI).
* **Edytory:** Nixvim (Neovim) i Micro z pełnym wsparciem serwerów LSP.

#### Przebudowa systemu:
```bash
sudo nixos-rebuild switch --flake .#pik-laptop
```

---

## 2. server ([`hosts/server/`](server/))

Serwer domowy (Homelab) odpowiedzialny za usługi sieciowe, przechowywanie danych, kopie zapasowe i aplikacje self-hosted.

### Główne cechy:
* **Usługi Chmurowe i Przechowywanie:**
  * Kontener **ownCloud Infinite Scale (oCIS)** na porcie `9200` (`drive.123pik1.ovh`).
  * Wcześniej instancja **Nextcloud** na bazie PostgreSQL.
  * Dyski montowane w `/mnt/`:
    * `1TB_storage_SSD` – szybkie dane chmury i aplikacji.
    * `2TB_storage_HDD` – magazyn kopii zapasowych, archiwum muzyki i multimediów.
    * `0_5TB_internal_SSD` – repozytoria i bazy Gitea.
* **Dostęp publiczny:** Cloudflare Tunnel (`cloudflared`) kierujący ruch z domeny `123pik1.ovh` do lokalnych portów bez konieczności otwierania portów na routerze.
* **Routing i sieć (`modules/network.nix`):**
  * Włączony routing pakietów (`net.ipv4.ip_forward = 1`).
  * NAT z interfejsu WAN (`enp2s0`) do sieci lokalnej (`enp3s0` z podsiecią `192.168.100.0/24`).
* **Repozytoria kodu:** Gitea zintegrowana z PostgreSQL (`git.123pik1.ovh`).
* **Baza danych:** PostgreSQL (`modules/database.nix`) z automatyczną inicjalizacją użytkowników i baz (`blog_db`).
* **Automatyzacja:** Timer `yt-dlp` pobierający nowe materiały z obserwowanych kanałów do archiwum muzycznego na HDD.
* **Gry:** Dedykowany serwer Minecraft z tunelem Playit.gg.
* **Bootloader:** GRUB na dysku `/dev/sda`.

#### Przebudowa systemu:
```bash
sudo nixos-rebuild switch --flake .#server
```
*(lub w tle przez systemd: `systemctl start nixos-update-remote`).*
