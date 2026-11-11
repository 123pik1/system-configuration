# Zarządzanie Użytkownikami (`users/`)

Katalog zawiera definicje użytkowników systemowych oraz konfigurację ich przestrzeni domowej zarządzanej przez **Home Manager**.

---

## Struktura Katalogu

```text
users/
├── pik/                   # Główny użytkownik systemu
│   ├── default.nix        # Konfiguracja konta na poziomie systemu NixOS
│   └── home.nix           # Profil użytkownika w Home Managerze (SSH, XDG, aplikacje)
└── README.md              # Dokumentacja modułu użytkowników
```

---

## Opis Komponentów

### 1. Definicja Systemowa ([`users/pik/default.nix`](pik/default.nix))
* **Typ konta:** Standardowy użytkownik (`isNormalUser = true`).
* **Domyślna powłoka:** `pkgs.zsh`.
* **Grupy systemowe:**
  * `wheel` – uprawnienia administratora (`sudo`).
  * `networkmanager` – zarządzanie połączeniami sieciowymi i Wi-Fi.
  * `docker` – uruchamianie i inspekcja kontenerów bez konieczności używania `sudo`.
* **Warunkowa integracja z Home Managerem:**
  * Moduł przyjmuje flagę `useHomeManager`.
  * Na laptopie (`pik-laptop`) flaga ta jest włączona (`true`), co ładuje pełne środowisko graficzne, konfigurację SSH i aplikacje z [`home.nix`](pik/home.nix).
  * Na serwerze (`server`) flaga jest wyłączona (`false`), zapobiegając instalacji zbędnych komponentów graficznych i zachowując lekki profil serwerowy.

### 2. Środowisko Domowe ([`users/pik/home.nix`](pik/home.nix))
* **Wersja stanu:** `home.stateVersion = "25.05"`.
* **Importowane moduły:**
  * [`modules/home-manager/hyprland/hyprland.nix`](../modules/home-manager/hyprland/hyprland.nix) – kompozytor Hyprland, Waybar, wlogout, Yazi, style GTK.
  * [`modules/home-manager/browser.nix`](../modules/home-manager/browser.nix) – profil przeglądarki Firefox.
* **Klient SSH (`programs.ssh`):**
  * Globalna konfiguracja terminala: `TERM = "xterm"` dla wszystkich połączeń (`*`).
  * Prekonfigurowane bloki maszyn (`matchBlocks`):
    * `server` – bezpieczne połączenie z serwerem przez Cloudflare Access:
      ```nix
      proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      ```
    * `local-server` – bezpośrednie logowanie do serwera po sieci LAN (`192.168.100.1`).
    * `tailscale-server` – połączenie przez prywatną sieć Tailscale (`100.87.208.9`).
* **Powłoka i przeglądarka:**
  * `programs.bash.enable = true` – kompatybilność skryptów powłoki Bash.
  * `programs.firefox.configPath = ".mozilla/firefox"` – dedykowany katalog profilu przeglądarki.
* **Pakiety użytkownika:**
  * `atool` – uniwersalne narzędzie do pracy z archiwami (tar, zip, rar, 7z).
  * `httpie` – przyjazny dla użytkownika klient HTTP w terminalu.
* **Domyślne aplikacje XDG (`xdg.mimeApps`):**
  * Dedykowana przeglądarka obrazów `geeqie.desktop` dla formatów:
    * `image/jpeg`, `image/png`, `image/gif`, `image/webp`
    * `image/tiff`, `image/bmp`, `image/x-adobe-dng` (cyfrowe negatywy RAW)
