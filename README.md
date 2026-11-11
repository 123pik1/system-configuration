# NixOS Flake Configuration - 123pik1

Deklaratywna konfiguracja systemu NixOS dla wielu maszyn (multi-host), moduły systemowe, zestawy narzędzi (tool-sets), konfiguracja środowiska użytkownika (Home Manager) oraz kolekcja dedykowanych środowisk deweloperskich (devShells).

---

## Architektura Repozytorium

```text
.
├── flake.nix              # Główny punkt wejściowy flake'a (inputs, outputs, hosty, devShells)
├── flake.lock             # Zamrożone wersje zależności (nixpkgs, home-manager, sops, nur, etc.)
├── hosts/                 # Konfiguracje konkretnych maszyn (per-host)
│   ├── laptop/            # Stacja robocza (pik-laptop: Hyprland Lua, NVIDIA Prime, ReGreet)
│   ├── server/            # Maszyna serwerowa (server: oCIS, Gitea, Kiwix, Ollama, PostgreSQL)
│   ├── pixel-10/          # Konfiguracja mobilna Nix-on-Droid dla Google Pixel
│   └── README.md          # Dokumentacja konfiguracji maszyn
├── modules/               # Moduły NixOS (konfiguracja systemu, sprzętu, usług)
│   ├── tool-sets/         # Zbiory pakietów tematycznych (CLI, GUI, języki, sieć, PWA, wirtualizacja)
│   ├── scripts/           # Samodzielne skrypty użytkownika (tapety, notatki, workspaces)
│   ├── services/          # Dedykowane usługi serwerowe (oCIS, Gitea, Kiwix, Ollama, Minecraft)
│   ├── home-manager/      # Moduły użytkownika (Hyprland, Waybar, Yazi, przeglądarka)
│   ├── laptop-essentials.nix # Podstawowe pakiety i usługi laptopa (Waydroid, libvirt, CUPS, SANE)
│   ├── server-essentials.nix # Dyski, montowania ext4, spindown HDD, Docker, auto-cpufreq
│   └── README.md          # Dokumentacja modułów systemowych
├── shells/                # Dedykowane środowiska deweloperskie (nix develop)
│   ├── python-rag.nix     # Środowisko Python RAG (psycopg, pymupdf, fastembed, venv)
│   └── README.md          # Dokumentacja powłok deweloperskich
├── users/                 # Definicje użytkowników i konfiguracja Home Managera
│   ├── pik/               # Profil użytkownika pik (NixOS + Home Manager + SSH config)
│   └── README.md          # Dokumentacja zarządzania użytkownikami
└── secrets/               # Zaszyfrowane sekrety zarządzane przez sops-nix
    └── passwords.yaml     # Baza sekretów zaszyfrowana kluczami age
```

---

## Zdefiniowane Maszyny (nixosConfigurations)

| Nazwa Hosta | Plik | Opis i Zastosowanie |
| :--- | :--- | :--- |
| **pik-laptop** | [`hosts/laptop`](hosts/README.md#1-pik-laptop-hostslaptop) | Główna stacja robocza. Hyprland (konfiguracja Lua), NVIDIA Prime (Sync / Battery Mode), ReGreet z motywem ciemnym, Home Manager, Nixvim, Starship, Waydroid, audio PipeWire, Bluetooth, narzędzia AI (Ollama CLI, Antigravity CLI). |
| **server** | [`hosts/server`](hosts/README.md#2-server-hostsserver) | Serwer domowy / homelab. PostgreSQL, Cloudflare Tunnels, oCIS (chmura plików), Gitea, Kiwix ZIM server, Ollama LLM (CPU, `qwen2.5:3b`), zabezpieczenia jądra (hung task panic, oops reboot, zramSwap), watchdog sieciowy, routing NAT. |
| **pixel-10** | [`hosts/pixel-10`](hosts/README.md#3-pixel-10-hostspixel-10) | Środowisko terminalowe Nix-on-Droid dla smartfona Google Pixel (Neovim, git, lazygit, fastfetch, glow, fzf). |

---

## Podstawowe Polecenia

### Wdrożenie i przebudowa systemu (Rebuild)

#### Na laptopie:
```bash
sudo nixos-rebuild switch --flake .#pik-laptop
```

#### Na serwerze:
```bash
sudo nixos-rebuild switch --flake .#server
```

#### Zdalna aktualizacja serwera w tle:
```bash
systemctl start nixos-update-remote
```

Podgląd logów w tle:
```bash
journalctl -u nixos-update-remote -f
```

### Aktualizacja zależności Flake'a:
```bash
# Aktualizacja wszystkich inputs
nix flake update

# Aktualizacja konkretnego inputu (np. nixpkgs)
nix flake lock --update-input nixpkgs
```

---

## Środowiska Deweloperskie (devShells)

Flake udostępnia odizolowane powłoki programistyczne bazujące na `pkgs.mkShell` oraz `pkgs.buildFHSEnv`. Uruchomienie wybranego środowiska:

```bash
nix develop .#<nazwa_shella> -c zsh
```

Dostępne środowiska (szczegóły w [`shells/README.md`](shells/README.md)):
* `python-rag` – Python z obsługą RAG (FastEmbed, PyMuPDF, Psycopg, automatyczny virtualenv i wsparcie bibliotek C/zlib)
* `rust` / `rust96` – Rust z rust-overlay, rust-analyzer, cargo (w tym wydanie 1.96 z obsługą pcap)
* `tauri` – Środowisko Tauri (WebView, WebKitGTK 4.1, Cairo, zależności C/Rust)
* `angular` – Node.js 26, Angular CLI i language server
* `svelte` – Node.js 20, npm, wsparcie SvelteKit
* `java` – OpenJDK 21, Maven, Lombok, skrypty zarządzania lokalnym PostgreSQL
* `cpp` – GCC, Clang, CMake, GDB, LLDB, GNU Make
* `android` – Android Studio, Android SDK Tools (`adb`, `fastboot`)
* `latex` – Pełna dystrybucja TeX Live (`texliveFull`)
* `nids` – Python ML dla Network Intrusion Detection System (Scapy, PyZMQ, Docker SDK)
* `mc` – Środowisko deweloperskie FHS dla narzędzi Minecrafta

Szybkie aliasy w Zsh (`modules/shell.nix`): `rust-dev`, `tauri-dev`, `java-dev`, `tex-dev` / `latex-dev`, `nids-dev`, `cpp-dev`.

---

## Zarządzanie Sekretami (sops-nix)

Sekrety są przechowywane w repozytorium w pliku [`secrets/passwords.yaml`](secrets/passwords.yaml) z użyciem kluczy **age**:
* Na serwerze: klucz hosta SSH `/etc/ssh/ssh_host_ed25519_key`.
* Na laptopie: klucz użytkownika `/home/pik/.config/sops/age/keys.txt`.

Edycja sekretów:
```bash
sops secrets/passwords.yaml
```

---

## Dokumentacja Szczegółowa

* [Dokumentacja Maszyn (`hosts/`)](hosts/README.md)
* [Moduły Systemowe NixOS (`modules/`)](modules/README.md)
* [Usługi Serwerowe (`modules/services/`)](modules/services/README.md)
* [Konfiguracja Środowiska Użytkownika (`modules/home-manager/`)](modules/home-manager/README.md)
* [Konfiguracja Hyprland (`modules/home-manager/hyprland/`)](modules/home-manager/hyprland/README.md)
* [Środowiska Deweloperskie (`shells/`)](shells/README.md)
* [Zarządzanie Użytkownikami (`users/`)](users/README.md)
