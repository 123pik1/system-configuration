# Moduły Systemowe NixOS (`modules/`)

Katalog zawiera deklaratywne moduły systemu NixOS współdzielone pomiędzy maszynami lub definiujące poszczególne podsystemy (sprzęt, powłoka, edytory, usługi, sieć, zestawy narzędzi).

---

## Struktura Katalogu

```text
modules/
├── laptop-essentials.nix     # Usługi i pakiety bazowe laptopa (Waydroid, libvirt, CUPS, SANE, Steam, PipeWire)
├── server-essentials.nix     # Konfiguracja serwera: montowanie dysków SSD/HDD, ext4, spindown, Docker, auto-cpufreq
├── tool-sets/                # Modułowe zestawy pakietów oprogramowania
│   ├── cli-tools.nix         # Narzędzia terminalowe (antigravity-cli, ollama, yt-dlp, yazi, glow, btop, pandoc)
│   ├── gui-application-set.nix # Aplikacje okienkowe (terminale Ghostty/Kitty, Moonlight, OnlyOffice, Krita, Wine)
│   ├── languages.nix         # Kompilatory i narzędzia programistyczne (Nix, Python 3, JDK 21, Clang/GCC, Typst)
│   ├── net-tools.nix         # Diagnostyka i narzędzia sieciowe (Wireshark, Postman, tcpdump, traceroute)
│   ├── pwa-s.nix             # Desktopowe aplikacje PWA w oknach Chromium (Discord, GitHub, Whiteboard, Docker)
│   ├── server-tools.nix      # Narzędzia środowiska serwerowego (cloudflared, screen, hdparm, JDK 25 Temurin)
│   └── virtualisation-tools.nix # Narzędzia wirtualizacji (QEMU, Docker, docker-compose, virt-manager, lazydocker)
├── scripts/                  # Dedykowane skrypty pomocnicze
│   ├── open-notes.nix        # Skrypt open-notes (podgląd notatek z użyciem glow)
│   ├── random-wallpaper.nix  # Skrypt random-wallpaper (losowanie tapet z użyciem awww)
│   └── workspace-scripts.nix # Skrypty nawigacji po projektach (ws-open, ws-add)
├── scripts.nix               # Integracja skryptów użytkownika i aliasów powłoki
├── services/                 # Moduły dedykowanych usług serwerowych
│   ├── ocis.nix              # Kontener ownCloud Infinite Scale (oCIS) i backup rclone
│   ├── gitea.nix             # Serwer Gitea zintegrowany z PostgreSQL
│   ├── kiwix.nix             # Serwer offline Kiwix ZIM i skrypty pobierania archiwów
│   ├── ollama.nix            # Serwer Ollama LLM w trybie CPU z modelem qwen2.5:3b
│   ├── mc.nix                # Serwer Minecraft w usłudze systemd
│   ├── rebuild-switch.nix    # Asynchroniczna aktualizacja systemu w tle (nixos-update-remote)
│   └── README.md             # Szczegółowa dokumentacja usług serwerowych
├── database.nix              # PostgreSQL z bezpieczną inicjalizacją haseł przez sops-nix
├── games.nix                 # Klient tunelu playit.gg do udostępniania serwerów gier
├── gpu.nix                   # Sterowniki NVIDIA z modułami open i NVIDIA PRIME Sync
├── micro-conf.nix            # Edytor Micro ze schematem Twilight, serwerami LSP i formatowaniem
├── neovim-conf.nix           # Zaawansowany edytor Neovim w Nixvim (LSP, drzewo nvim-tree, auto-formatowanie)
├── network.nix               # Routing IP, NAT z enp2s0 do enp3s0 oraz statyczna adresacja LAN
├── secrets.nix               # Konfiguracja integracji sops-nix z kluczami hosta / użytkownika
├── services.nix              # Główna orkiestracja usług (tunel Cloudflare, watchdog łączności, yt-dlp, kontenery OCI)
├── shell.nix                 # Konfiguracja Zsh, autouzupełnianie, aliasy dev oraz Starship Prompt
├── specializations.nix       # Profil battery-mode dostępny w bootloaderze (wyłączenie dGPU NVIDIA)
├── window-manager.nix        # Hyprland (Wayland), ReGreet, portale XDG i pomocnicze skrypty okienkowe
└── home-manager/             # Moduły użytkownika Home Manager (Hyprland Lua, Waybar, Yazi, Firefox)
```

---

## Opis Poszczególnych Modułów

### 1. Pakiety Bazowe Maszyn (Essentials)
* **[`laptop-essentials.nix`](laptop-essentials.nix)**:
  * Łączy modułowe zestawy narzędzi: `cli-tools`, `gui-application-set`, `languages`, `net-tools`, `pwa-s`, `virtualisation-tools`.
  * Wirtualizacja: Waydroid (Android) oraz Libvirt / KVM z nakładką GUI Virt-Manager.
  * Usługi sprzętowe: CUPS (`services.printing`) dla drukarek, SANE (`hardware.sane`) dla skanerów z backendem AirScan.
  * Gaming: Steam z otwartym firewallem dla Remote Play, GameMode oraz GameScope.
  * Dźwięk i Bluetooth: PipeWire z emulacją PulseAudio i ALSA; Bluetooth z demonem Blueman.
  * Integracja powłoki: `direnv` z `nix-direnv`.
* **[`server-essentials.nix`](server-essentials.nix)**:
  * Łączy zestawy: `cli-tools`, `server-tools`.
  * Definicje punktów montowania pamięci masowej ext4 z opcją `nofail` i 5-sekundowym limitem czasu:
    * `/mnt/2TB_storage_HDD` (archiwum i kopie zapasowe).
    * `/mnt/1TB_storage_SSD` (bazy Kiwix ZIM i szybkie dane).
    * `/mnt/0_5TB_internal_SSD` (magazyn oCIS i repozytoria Gitea).
  * Komendy oszczędzania energii dysków: `hdparm -S 120` po uruchomieniu (spindown HDD po 10 minutach bezczynności).
  * Daemon Docker oraz `auto-cpufreq` w profilu powersave.

---

### 2. Zestawy Narzędzi (`tool-sets/`)
* **[`tool-sets/cli-tools.nix`](tool-sets/cli-tools.nix)**: Narzędzia wiersza poleceń: `antigravity-cli`, `ollama`, `yt-dlp`, `yazi`, `glow`, `cmus`, `btop`, `pandoc`, `fzf`, `ctags`, `lolcat`, `git`, `gh`, `lazygit`, `sops`, `trash-cli`, `onefetch`, `fastfetch`.
* **[`tool-sets/gui-application-set.nix`](tool-sets/gui-application-set.nix)**: Aplikacje graficzne: terminale `ghostty`, `kitty`, `konsole`, `cool-retro-term`; gry i streaming `gamescope`, `moonlight-qt`, `heroic`; biuro i nauka `onlyoffice-desktopeditors`, `texstudio`, `anki`; grafika `krita`, `imv`, `swayimg`; partycjonowanie dysków `partitionmanager`, `gparted`; kompatybilność Windows `wineWow64Packages.stable`, `winetricks`.
* **[`tool-sets/languages.nix`](tool-sets/languages.nix)**: Środowiska uruchomieniowe i kompilatory: Nix (`nixd`, `nixfmt`), Python 3 (z modułami `pydbus`, `black`, `requests`, `httpie`), Java (`jdk21`), Lua/LuaJIT, C/C++ (`gcc`, `libgcc`, `clang-tools`, `gnumake`, `bear`, `ftxui`), Typst (`typst`, `typship`), parser JSON `jq`.
* **[`tool-sets/net-tools.nix`](tool-sets/net-tools.nix)**: Pakiety sieciowe: `wget`, `wireshark`, `postman`, `traceroute`, `tcpdump`, `networkmanager`.
* **[`tool-sets/pwa-s.nix`](tool-sets/pwa-s.nix)**: Generator dedykowanych skrótów desktopowych PWA uruchamianych w Chromium w dedykowanych oknach: `Discord`, `Nextcloud`, `GitHub`, `Whiteboard`, `Docker Hub`.
* **[`tool-sets/server-tools.nix`](tool-sets/server-tools.nix)**: Narzędzia serwerowe: `cloudflared`, `screen`, `hdparm` oraz kompilator Java `temurin-bin.jdk-25`.
* **[`tool-sets/virtualisation-tools.nix`](tool-sets/virtualisation-tools.nix)**: Narzędzia do wirtualizacji i kontenerów: `qemu`, `docker`, `docker-compose`, `virt-manager`, `lazydocker`.

---

### 3. Skrypty Użytkownika (`scripts/` i `scripts.nix`)
* **[`scripts/open-notes.nix`](scripts/open-notes.nix)**: Skrypt `open-notes` przechodzący do katalogu `~/Projects/notes` i uruchamiający czytnik `glow`.
* **[`scripts/random-wallpaper.nix`](scripts/random-wallpaper.nix)**: Skrypt `random-wallpaper` losujący plik graficzny z `~/Pictures/Wallpapers/` i aplikujący go za pomocą daemona `awww`.
* **[`scripts/workspace-scripts.nix`](scripts/workspace-scripts.nix)**: Skrypty `ws-open` i `ws-add` do szybkiego otwierania i indeksowania lokalizacji projektowych w formacie JSON wraz z ich podpowłokami nix-shell.
* **[`scripts.nix`](scripts.nix)**: Importuje powyższe skrypty oraz konfiguruje alias `ws-open` w powłoce Bash.

---

### 4. Środowisko Graficzne i Logowanie
* **[`window-manager.nix`](window-manager.nix)**:
  * Włącza kompozytor Hyprland na poziomie systemu z obsługą XWayland.
  * Menedżer logowania **ReGreet** (`programs.regreet`):
    * Tło: `/run/current-system/sw/share/backgrounds/gnome/vines-l.svg` (Cover).
    * Styl: wymuszony ciemny motyw GTK (`application_prefer_dark_theme = true`).
    * Zapamiętywanie ostatniego użytkownika (`pik`) oraz sesji.
  * Zestaw zintegrowanych narzędzi Wayland: `wofi`, `waybar`, `mako`, `awww`, `hyprlock`, `pavucontrol`, `pamixer`, `dolphin`, `udiskie`, `grim`, `slurp`, `swappy`, `brightnessctl`.
  * Wbudowane skrypty użytkownika:
    * `fancy-hyprland` – włącza animacje, zaokrąglenia, cienie i rozmycie.
    * `toggle-hyprland-fancy_battery` – przełącznik trybu oszczędzania energii i wydajności w locie.
    * `screenshot-menu` / `screenshot-area` – menu zrzutów ekranu bazujące na wofi, grim, slurp i swappy.
* **[`home-manager/`](home-manager/README.md)**: Konfiguracja per-użytkownik (Hyprland w Lua, paski Waybar, Yazi, Firefox).

---

### 5. Sprzęt, Grafika i Zasilanie
* **[`gpu.nix`](gpu.nix)**: Hybrydowy podsystem graficzny (AMD iGPU + NVIDIA RTX). Włącza otwarte sterowniki jądra NVIDIA (`open = true`) oraz technologię PRIME Sync (`amdgpuBusId = "PCI:5:0:0"`, `nvidiaBusId = "PCI:1:0:0"`).
* **[`specializations.nix`](specializations.nix)**: Specjalizacja `battery-mode` dostępna w menu GRUB/systemd-boot: blokuje moduły jądra NVIDIA (`nouveau`, `nvidia`, `nvidia_drm`, `nvidiafb`), wymusza sterownik `amdgpu` i czyści flagi DRM, maksymalizując czas pracy na baterii.

---

### 6. Terminal, Powłoka i Edytory
* **[`shell.nix`](shell.nix)**:
  * Globalna powłoka Zsh z `autosuggestions`, `syntaxHighlighting` i flagą `autocd`.
  * Integracja promptu **Starship** (`programs.starship`) z niestandardowymi symbolami statusu i skróconą ścieżką repozytorium.
  * Aliasy powłoki: `ll`, `cl`, `commit`, `drag`, oraz skróty deweloperskie do powłok Flake'a: `rust-dev`, `nids-dev`, `tauri-dev`, `java-dev`, `cpp-dev`, `tex-dev` / `latex-dev`.
* **[`neovim-conf.nix`](neovim-conf.nix)**:
  * W pełni deklaratywna konfiguracja edytora Neovim zarządzana przez `nixvim`.
  * Domyślny edytor systemowy (`defaultEditor = true`, aliasy `vi`, `vim`).
  * Serwery LSP: `nixd` (z integracją `nixfmt`), `pyright`, `clangd`, `bashls`, `html`, `cssls`, `ts_ls`, `vhdl_ls`.
  * Pluginy: `nvim-tree` (otwieranie plików w nowych kartach), `treesitter`, `lualine`, `comment`, `nvim-autopairs`, `rustaceanvim`, `crates`, `markdown-preview`.
  * Automatyczne formatowanie przy zapisie pliku (`BufWritePre`) dla plików Python, Nix, Rust, C/C++, HTML/TS/JS, VHDL itp.
* **[`micro-conf.nix`](micro-conf.nix)**:
  * Lekki terminalowy edytor `micro` ze schematem kolorystycznym `twilight`.
  * Zintegrowane serwery LSP: `nixd`, `pyright`, `clangd`, `bash-language-server`, `lua-language-server`, `gopls`, `zls`.
  * Formatowanie kodu: `nixfmt`, `black`, `clang-format`, `shfmt`, `stylua`.

---

### 7. Sieć, Usługi Serwerowe i Bezpieczeństwo
* **[`network.nix`](network.nix)**: Routing na serwerze: włączenie `sysctl net.ipv4.ip_forward = 1`, statyczny adres `192.168.100.1/24` na `enp3s0` oraz translacja NAT z interfejsu WAN `enp2s0`.
* **[`services.nix`](services.nix)**:
  * Tunel Cloudflare (`cloudflared`) dla domeny `123pik1.ovh` (kierowanie subdomen `ssh`, `www`, `drive`, `api-blog`, `blog`, `git`).
  * Watchdog połączenia (`connectionWatchdog`): automatyczny restart tunelu w przypadku problemów z łącznością (brak odpowiedzi od `1.1.1.1` co 5 minut).
  * Systemd timer `yt-dlp-download`: codzienne pobieranie audio z obserwowanych playlist do archiwum `/mnt/2TB_storage_HDD/Music/`.
  * Kontenery Docker OCI: `whiteboard` (WBO na porcie 7777), `blog-backend` (Spring Boot na porcie 9999), `blog-frontend` (Next.js na porcie 9998).
* **[`database.nix`](database.nix)**: Relacyjna baza danych PostgreSQL z bazą `blog_db`, inicjalizowana bezpiecznie za pomocą szablonów `sops.templates`.
* **[`services/`](services/README.md)**: Dedykowane moduły usług serwerowych: `ocis.nix`, `gitea.nix`, `kiwix.nix`, `ollama.nix`, `mc.nix`, `rebuild-switch.nix`.
* **[`games.nix`](games.nix)**: Demon `playit.gg` umożliwiający bezproblemowe wystawianie serwera Minecrafta na świat przez tunele UDP/TCP.
* **[`secrets.nix`](secrets.nix)**: Podstawowa integracja modułu `sops-nix` z plikiem `secrets/passwords.yaml`.
