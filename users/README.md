# Zarządzanie Użytkownikami (`users/`)

Katalog zawiera definicje użytkowników systemowych oraz powiązanie z konfiguracją ich przestrzeni domowej zarządzanej przez **Home Manager**.

---

## Struktura

```text
users/
└── pik/                   # Główny użytkownik systemu
    ├── default.nix        # Konfiguracja konta na poziomie systemu NixOS
    └── home.nix           # Profil użytkownika w Home Managerze
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
* **Integracja z Home Managerem:**
  * Moduł przyjmuje flagę `useHomeManager`.
  * Na laptopie (`pik-laptop`) flaga ta jest ustawiona na `true`, co automatycznie wczytuje plik [`home.nix`](pik/home.nix).
  * Na serwerze (`server`) flaga jest wyłączona (`false`), co zapobiega instalowaniu pakietów graficznych i środowiska desktopowego na maszynie bez monitora.

### 2. Środowisko Domowe ([`users/pik/home.nix`](pik/home.nix))
* **Wersja stanu:** `home.stateVersion = "25.05"`.
* **Importowane moduły:**
  * [`modules/home-manager/hyprland/hyprland.nix`](../modules/home-manager/hyprland/hyprland.nix) – kompozytor Hyprland, pasek Waybar, menu wlogout, eksplorator Yazi.
  * [`modules/home-manager/browser.nix`](../modules/home-manager/browser.nix) – profil przeglądarki Firefox.
* **Pakiety użytkownika:**
  * `atool` – narzędzie do archiwów (tar, zip, rar).
  * `httpie` – klient HTTP w konsoli.
* **Skojarzenia plików (`xdg.mimeApps`):**
  * Domyślna przeglądarka obrazów dla formatów `image/jpeg`, `image/png`, `image/gif`, `image/webp`: `geeqie.desktop`.
