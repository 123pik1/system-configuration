# Dokumentacja Maszyn (`hosts/`)

Katalog zawiera definicje poszczególnych systemów NixOS oraz konfiguracji mobilnych zarządzanych przez Flake. Każdy podkatalog odpowiada jednej maszynie i zawiera specyfikację sprzętową (`hardware-configuration.nix`) oraz deklaratywną konfigurację systemową (`configuration.nix`).

---

## Spis Hostów

```text
hosts/
├── laptop/            # Stacja robocza (pik-laptop)
│   ├── configuration.nix
│   └── hardware-configuration.nix
├── server/            # Maszyna serwerowa (server)
│   ├── configuration.nix
│   └── hardware-configuration.nix
├── pixel-10/          # Środowisko mobilne Nix-on-Droid
│   └── configuration.nix
└── README.md
```

---

## 1. pik-laptop ([`hosts/laptop/`](laptop/))

Główna stacja robocza zoptymalizowana pod kątem programowania, multimediów, grafiki hybrydowej i elastycznego zarządzania energią.

### Główne komponenty i technologie:
* **Środowisko graficzne:** [Hyprland](../modules/window-manager.nix) (Wayland) z konfiguracją opartą o format **Lua** (`configType = "lua"`), zintegrowany z Waybar, Wlogout, Yazi, Mako oraz Ghostty jako domyślnym terminalem.
* **Menedżer logowania (Greeter):** [ReGreet (`programs.regreet`)](../modules/window-manager.nix) z ciemnym motywem GTK, tłem Vines GNOME oraz zapamiętywaniem użytkownika i sesji.
* **Karty graficzne (Hybrid Graphics):**
  * Układ hybrydowy: zintegrowany AMD iGPU oraz dedykowany NVIDIA RTX (dGPU).
  * Otwartoźródłowe moduły jądra NVIDIA (`open = true`) oraz technologia PRIME Sync (`modules/gpu.nix`).
* **Profile zasilania (`modules/specializations.nix`):**
  * `battery-mode` – profil oszczędzania baterii wybierany w bootloaderze. Blokuje moduły jądra NVIDIA (`nouveau`, `nvidia`, `nvidia_drm`, `nvidiafb`), wymusza pracę wyłącznie na zintegrowanej grafice AMD oraz redukuje zużycie energii.
* **Zarządzanie energią:** `auto-cpufreq` automatycznie optymalizujący profile pracy na baterii i zasilaczu.
* **Wirtualizacja i konteneryzacja:**
  * Waydroid (kontener Android wewnątrz Wayland).
  * Docker daemon oraz Libvirt / KVM z nakładką GUI Virt-Manager.
* **Peryferia, druk i skanowanie:**
  * Drukarki: usługa CUPS (`services.printing`) ze sterownikami `cups-filters`.
  * Skanery: obsługa SANE (`hardware.sane`) z backendem `sane-airscan`.
  * Dźwięk: PipeWire z emulacją PulseAudio i ALSA (PulseAudio wyłączone).
  * Bluetooth: `hardware.bluetooth` z apletem Blueman.
* **Zarządzanie środowiskiem:** `direnv` z integracją `nix-direnv`.
* **Gry:** Steam z obsługą GameMode, GameScope Session oraz Moonlight-qt i Heroic Games Launcher.
* **Narzędzia AI:** Lokalny klient Ollama CLI oraz Antigravity CLI włączone w zestawie `cli-tools.nix`.
* **Bootloader:** `systemd-boot` (obsługa UEFI).
* **Edytory:** Nixvim (deklaratywny Neovim) oraz Micro z prekonfigurowanymi serwerami LSP.

#### Przebudowa systemu:
```bash
sudo nixos-rebuild switch --flake .#pik-laptop
```

---

## 2. server ([`hosts/server/`](server/))

Serwer domowy (Homelab) odpowiedzialny za usługi sieciowe, bezpieczne przechowywanie danych, kopie zapasowe, lokalne modele LLM i aplikacje self-hosted.

### Główne komponenty i usługi:
* **Usługi Chmurowe i Przechowywanie:**
  * **ownCloud Infinite Scale (oCIS)** w kontenerze OCI (`modules/services/ocis.nix`) na porcie `9200` (`drive.123pik1.ovh`), z automatycznymi kopiami zapasowymi rclone o 03:00.
  * Montowanie pamięci masowej w `/mnt/`:
    * `/mnt/1TB_storage_SSD` – archiwa Kiwix ZIM i szybkie dane aplikacji.
    * `/mnt/2TB_storage_HDD` – magazyn kopii zapasowych, archiwum muzyczne z automatycznym uśpieniem dysku (`hdparm -S 120`).
    * `/mnt/0_5TB_internal_SSD` – dane oCIS (`/mnt/0_5TB_internal_SSD/ocis_data/ocis/`) oraz repozytoria i bazy Gitea.
* **Wiedza offline (Kiwix ZIM Server):**
  * Dedykowana usługa systemd `kiwix-serve` (`modules/services/kiwix.nix`) na porcie `5555`.
  * Obsługa pełnych archiwów `.zim` (Wikipedia EN nopic, NixOS Wiki, ArchWiki).
  * Skrypty do automatycznego pobierania aktualnych archiwów: `download_arch_wiki`, `download_nix_wiki`, `download_wiki_en_nopic`.
* **Lokalna Sztuczna Inteligencja (Ollama):**
  * Usługa `services.ollama` (`modules/services/ollama.nix`) w wersji CPU (`pkgs.ollama-cpu`) na porcie `11111`.
  * Preinstalowany model `qwen2.5:3b`.
  * Zmienne systemowe `OLLAMA_HOST` i `OLLAMA_NAME` ułatwiające integrację z narzędziami CLI i powłokami RAG.
* **Dostęp publiczny:**
  * Tunel Cloudflare (`cloudflared`) kierujący subdomeny `123pik1.ovh` (`drive`, `git`, `www`, `api-blog`, `blog`, `ssh`) do lokalnych portów.
* **Niezawodność i Zabezpieczenia Jądra:**
  * Reguły jądra (`sysctl`):
    * `kernel.hung_task_panic = 1` (panika jądra przy zawieszeniu I/O powyżej 120 sekund).
    * `kernel.panic = 10` (automatyczny restart po 10 sekundach od paniki jądra).
    * `kernel.panic_on_oops = 1` (restart przy pętli przerw procesora).
  * Skompresowany swap w pamięci RAM (`zramSwap.enable = true`).
  * Watchdog połączenia (`connectionWatchdog`): systemd timer sprawdzający co 5 minut łączność z `1.1.1.1` oraz stan tunelu Cloudflare; restartuje tunel w przypadku braku sieci.
* **Routing i Sieć (`modules/network.nix`):**
  * Przekazywanie pakietów IPv4 (`sysctl net.ipv4.ip_forward = 1`).
  * Reguły NAT z interfejsu WAN (`enp2s0`) do sieci lokalnej (`enp3s0` z podsiecią `192.168.100.0/24`).
* **Baza Danych i Repozytoria:**
  * PostgreSQL (`modules/database.nix`) z bezpiecznym tworzeniem użytkowników i baz (`blog_db`) via szablony sops-nix.
  * Gitea zintegrowana z PostgreSQL na porcie `8991` (`git.123pik1.ovh`).
* **Kontenery OCI (Docker):**
  * `whiteboard` – tablica interaktywna online (`lovasoa/wbo`) na porcie `7777`.
  * `blog-backend` – usługa Spring Boot podpięta pod bazę PostgreSQL na porcie `9999`.
  * `blog-frontend` – aplikacja frontendowa na porcie `9998`.
* **Automatyzacja i Multimedia:**
  * Timer `yt-dlp` pobierający nowe materiały audio z obserwowanych playlist na YouTube bezpośrednio do `/mnt/2TB_storage_HDD/Music/`.
* **Gry:**
  * Usługa Minecraft Server (`modules/services/mc.nix`) uruchamiana w systemd z pakietem OpenJDK 25 Temurin i tunelem Playit.gg (`modules/games.nix`).
* **Bootloader:** GRUB zainstalowany na dysku `/dev/sda`.

#### Przebudowa systemu:
```bash
sudo nixos-rebuild switch --flake .#server
```

*(lub zdalnie w tle: `systemctl start nixos-update-remote`).*

---

## 3. pixel-10 ([`hosts/pixel-10/`](pixel-10/))

Lekka konfiguracja środowiska linuksowego w systemie Android uruchamiana w ramach **Nix-on-Droid** na smartfonie Google Pixel.

### Zawartość:
* Dedykowane środowisko terminalowe definiowane przez `environment.packages`.
* Podstawowe narzędzia pracy z kodem: `git`, `curl`, `wget`, `unzip`, `fzf`, `glow`, `lazygit`, `fastfetch`.
* Edytor tekstu: `neovim`.
* Wersja stanu systemu: `stateVersion = "24.05"`.
