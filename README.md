# NixOS Flake Configuration - 123pik1

Deklaratywna konfiguracja systemu NixOS dla wielu maszyn (multi-host), moduły systemowe, konfiguracja środowiska użytkownika (Home Manager) oraz kolekcja dedykowanych środowisk deweloperskich (devShells).

---

## Architektura Repozytorium

```text
.
├── flake.nix              # Główny punkt wejściowy flake'a (inputs, outputs, hosty, devShells)
├── flake.lock             # Zamrożone wersje zależności (nixpkgs, home-manager, sops, nur, etc.)
├── hosts/                 # Konfiguracje konkretnych maszyn (per-host)
│   ├── laptop/            # Maszyna mobilna (pik-laptop: Hyprland, NVIDIA Prime, zarządzanie baterią)
│   └── server/            # Maszyna serwerowa (server: oCIS, Gitea, PostgreSQL, Cloudflare, etc.)
├── modules/               # Moduły NixOS (konfiguracja systemu, sprzętu, usług)
│   ├── services/          # Usługi serwerowe i kontenery OCI (oCIS, Gitea, Minecraft)
│   └── home-manager/      # Moduły użytkownika (Hyprland, Waybar, Yazi, przeglądarka)
├── shells/                # Dedykowane środowiska deweloperskie (nix develop)
├── users/                 # Definicje użytkowników i konfiguracja Home Managera
└── secrets/               # Zaszyfrowane sekrety zarządzane przez sops-nix
```

---

## Zdefiniowane Maszyny (nixosConfigurations)

| Nazwa Hosta | Plik | Opis i Zastosowanie |
| :--- | :--- | :--- |
| **pik-laptop** | [`hosts/laptop`](hosts/README.md) | Stacja robocza. Hyprland (Wayland), NVIDIA Prime (Sync / Battery Mode), Home Manager, Nixvim, audio, Bluetooth. |
| **server** | [`hosts/server`](hosts/README.md) | Serwer domowy / homelab. PostgreSQL, Cloudflare Tunnels, oCIS, Gitea, routing sieciowy NAT, kopie zapasowe, automatyzacja pobierania mediów. |

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

### Aktualizacja zależności Flake'a:
```bash
# Aktualizacja wszystkich inputs
nix flake update

# Aktualizacja konkretnego inputu (np. nixpkgs)
nix flake lock --update-input nixpkgs
```

---

## Środowiska Deweloperskie (devShells)

Flake udostępnia odizolowane powłoki programistyczne. Uruchomienie wybranego środowiska:

```bash
nix develop .#<nazwa_shella> -c zsh
```

Dostępne środowiska (szczegóły w [`shells/README.md`](shells/README.md)):
* `rust` / `rust96` – Rust z rust-overlay, rust-analyzer, cargo
* `tauri` – Środowisko Tauri (WebView, WebKitGTK, zależności C/Rust)
* `angular` – Node.js, Angular CLI
* `svelte` – Node.js, npm, wsparcie Svelte
* `java` – OpenJDK, Gradle, Maven, lokalny PostgreSQL
* `cpp` – Clang, GCC, CMake, GDB
* `android` – Android SDK, Java, narzędzia platformowe
* `latex` – TeX Live, kompilatory LaTeX
* `nids` – Python ML dla Network Intrusion Detection System
* `mc` – Środowisko deweloperskie FHS dla narzędzi Minecraft

Szybkie aliasy w Zsh (`modules/shell.nix`): `rust-dev`, `tauri-dev`, `java-dev`, `tex-dev`, `nids-dev`, `cpp-dev`.

---

## Zarządzanie Sekretami (sops-nix)

Sekrety są przechowywane w repozytorium w pliku [`secrets/passwords.yaml`](secrets/passwords.yaml) z użyciem kluczy **age**:
* Na serwerze: klucz hosta `/etc/ssh/ssh_host_ed25519_key`.
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
* [Środowiska Deweloperskie (`shells/`)](shells/README.md)
* [Zarządzanie Użytkownikami (`users/`)](users/README.md)
