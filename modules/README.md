# Moduły Systemowe NixOS (`modules/`)

Katalog zawiera moduły systemu NixOS współdzielone pomiędzy maszynami lub definiujące poszczególne podsystemy (sprzęt, powłoka, edytory, usługi, sieć).

---

## Struktura Katalogu

```text
modules/
├── common.nix             # Aplikacje desktopowe PWA (Discord, Nextcloud Chromium App)
├── dashboard.nix          # Konfiguracja panelu głównego homelab
├── database.nix           # PostgreSQL z automatyzacją użytkowników i uprawnień przez sops-nix
├── essentials.nix         # Docker, auto-cpufreq, wsparcie NTFS, definicje dysków
├── games.nix              # Narzędzie playit.gg do udostępniania serwerów gier
├── gpu.nix                # Sterowniki NVIDIA z modułami open i NVIDIA PRIME Sync
├── micro-conf.nix         # Edytor Micro z prekonfigurowanymi serwerami LSP
├── neovim-conf.nix        # Deklaratywny Neovim za pośrednictwem Nixvim
├── network.nix            # Routing IP, NAT i statyczna adresacja dla sieci lokalnej
├── scripts.nix            # Własne skrypty użytkownika (random-wallpaper, vivado)
├── secrets.nix            # Konfiguracja domyślnego pliku sops-nix
├── services.nix           # Główny moduł usług (Cloudflare Tunnel, Ingress, yt-dlp timer)
├── shell.nix              # Konfiguracja Zsh, podpowiedzi, autouzupełnianie, aliasy dev
├── specializations.nix    # Profile specjalizacji (battery-mode dla laptopa)
├── window-manager.nix     # Hyprland (Wayland), portale XDG i greetd
├── home-manager/          # Moduły użytkownika (Hyprland, Waybar, Yazi, Firefox)
└── services/              # Dedykowane usługi serwerowe (oCIS, Gitea, Minecraft, rebuild)
```

---

## Opis Poszczególnych Modułów

### Środowisko i Interfejs
* **[`window-manager.nix`](window-manager.nix)**: Włącza zarządcę okien Hyprland na poziomie systemu, obsługę XWayland, portale XDG (`xdg-desktop-portal-hyprland` i `gtk`) oraz menedżer logowania `greetd`.
* **[`common.nix`](common.nix)**: Generuje aplikacje Progressive Web Apps (PWA) uruchamiane w oknie Chromium z flagami Wayland/Ozone (np. Discord PWA).
* **[`home-manager/`](home-manager/README.md)**: Szczegółowa konfiguracja użytkownika – pasek Waybar, menu wlogout, eksplorator Yazi, motywy i przeglądarka.

### Sprzęt, Grafika i Zasilanie
* **[`gpu.nix`](gpu.nix)**: Konfiguruje hybrydowy układ graficzny w laptopie (AMD iGPU + NVIDIA RTX). Włącza otwartoźródłowe moduły jądra NVIDIA (`open = true`) oraz tryb PRIME Sync (`PCI:5:0:0` / `PCI:1:0:0`), zapewniając stabilne wyjście wideo na złączach HDMI/DisplayPort.
* **[`specializations.nix`](specializations.nix)**: Dodaje specjalizację `battery-mode` wybieraną podczas uruchamiania systemu w bootloaderze. Blokuje moduły jądra NVIDIA (`nouveau`, `nvidia`, `nvidia_drm`, `nvidiafb`), wymusza sterownik `amdgpu` i czyści zmienne DRM, wydłużając czas pracy na baterii.
* **[`essentials.nix`](essentials.nix)**: Włącza daemona Dockera, wsparcie dla systemów plików NTFS oraz usługę `auto-cpufreq` (z profilem powersave na baterii i wyłączonym trybem turbo).

### Terminal, Powłoka i Edytory
* **[`shell.nix`](shell.nix)**: Globalna konfiguracja powłoki Zsh:
  * Włączone podpowiedzi (`autosuggestions`) i kolorowanie składni (`syntaxHighlighting`).
  * Opcja `autocd`.
  * Skróty deweloperskie do wchodzenia w dedykowane powłoki Flake'a: `rust-dev`, `nids-dev`, `tauri-dev`, `tex-dev`, `java-dev`, `cpp-dev`.
* **[`neovim-conf.nix`](neovim-conf.nix)**: W pełni deklaratywna konfiguracja edytora Neovim przez `nixvim`:
  * Ustawiony jako domyślny edytor (`defaultEditor = true`, aliasy `vi`, `vim`).
  * Integracja ze schowkiem systemowym (`clipboard = "unnamedplus"`), numeracja linii, podświetlanie kursora, wcięcia tabulatora (4 spacje).
* **[`micro-conf.nix`](micro-conf.nix)**: Konfiguracja lekkiego edytora terminalowego `micro` ze schematem `twilight` i zintegrowanymi serwerami LSP (`nixd`, `pyright`, `clangd`, `gopls`, `zls`).

### Sieć, Routing i Usługi
* **[`network.nix`](network.nix)**: Konfiguracja węzła sieciowego na serwerze:
  * Przekazywanie pakietów IPv4 (`sysctl net.ipv4.ip_forward = 1`).
  * Przypisanie statycznego adresu `192.168.100.1/24` do interfejsu wewnętrznego `enp3s0`.
  * Reguły NAT udostępniające internet z `enp2s0` do `enp3s0`.
* **[`services.nix`](services.nix)**: Centralna orkiestracja usług:
  * Zarządzanie tunelem Cloudflare (`cloudflared`) dla domeny `123pik1.ovh` (kierowanie subdomen `drive`, `git`, `www`, `api-blog`, `whiteboard`, `ssh` na odpowiednie porty).
  * Systemd timer i usługa `yt-dlp` do codziennego pobierania nowej muzyki z wybranych playlist YouTube do katalogu `/mnt/2TB_storage_HDD/Music/`.
* **[`database.nix`](database.nix)**: Usługa PostgreSQL z bazą `blog_db`. Wykorzystuje szablony `sops.templates` do bezpiecznego tworzenia użytkownika bazy danych z hasłem pobieranym w locie z magazynu SOPS.
* **[`services/`](services/README.md)**: Dedykowane moduły: kontener OCI oCIS, serwer Gitea, serwer Minecraft, zdalny rebuild NixOS.

### Narzędzia i Skrypty
* **[`scripts.nix`](scripts.nix)**: Pakiet własnych skryptów shellowych:
  * `random-wallpaper`: Losuje i ustawia tapetę za pomocą `awww`.
  * `vivado`: Uruchamia powłokę `nix-shell` ze środowiskiem dla pakietu Xilinx Vivado.
* **[`secrets.nix`](secrets.nix)**: Podstawowa integracja `sops-nix`, wskazująca na centralny zaszyfrowany plik `secrets/passwords.yaml`.
* **[`games.nix`](games.nix)**: Pakowanie i instalacja binarnego agenta `playit` (playit.gg) umożliwiającego omijanie NAT i wystawianie serwerów gier bez publicznego IP.
