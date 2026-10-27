# Konfiguracja Środowiska Użytkownika (`modules/home-manager/`)

Katalog zawiera deklaratywne moduły Home Managera odpowiedzialne za konfigurację środowiska graficznego Wayland, terminalowych menedżerów plików oraz aplikacji codziennego użytku.

---

## Struktura

```text
modules/home-manager/
├── browser.nix            # Konfiguracja przeglądarki Mozilla Firefox
└── hyprland/              # Kompletne środowisko graficzne Hyprland (Wayland)
    ├── hyprland.nix       # Główny plik konfiguracyjny Hyprlanda (zmienne, kursor, reguły)
    ├── waybar.nix         # Pasek statusu Waybar oraz menu wylogowania wlogout
    ├── file-explorer.nix  # Menedżer plików Yazi z integracją Zsh
    ├── hyprpaper.nix      # Zarządzanie tapetami przez demona hyprpaper
    └── viewConf.nix       # Ustawienia stylów GTK i preferencji ciemnego motywu
```

---

## Opis Komponentów

### 1. Przeglądarka ([`browser.nix`](browser.nix))
* Konfiguracja profilu **Mozilla Firefox**.
* Ustawienie regionu wyszukiwania na `PL`.

### 2. Środowisko Hyprland ([`hyprland/`](hyprland/))

#### [`hyprland.nix`](hyprland/hyprland.nix)
* Włączenie i konfiguracja kompozytora **Hyprland** (`configType = "hyprlang"`).
* Integracja z motywami Qt (`QT_QPA_PLATFORMTHEME=qt6ct`).
* Ustawienie motywu i rozmiaru kursora systemowego (`breeze_cursors`, 24px).
* Spójny import komponentów towarzyszących (pasek, menu, tapety, menedżer plików).

#### [`waybar.nix`](hyprland/waybar.nix)
* Pasek stanu **Waybar** zoptymalizowany dla Hyprlanda.
* Wymagane fonty: `nerd-fonts.jetbrains-mono` oraz `font-awesome`.
* Zintegrowane menu wyjścia/blokady **`wlogout`**:
  * `Lock` (`l`) → uruchamia `hyprlock`.
  * `Hibernate` (`h`) → hibernacja systemu.
  * `Shutdown` / `Reboot` / `Logout`.

#### [`file-explorer.nix`](hyprland/file-explorer.nix)
* Menedżer plików w terminalu **`yazi`**:
  * Wrapper powłoki `y` (automatycznie zmienia katalog po wyjściu).
  * Włączona integracja z Zsh.
  * Tryb wyświetlania o proporcjach `[1, 4, 3]`, sortowanie naturalne, ukrywanie plików ukrytych.
  * Wbudowany podgląd multimediów i dokumentów do 1000x1000px.

#### [`hyprpaper.nix`](hyprland/hyprpaper.nix)
* Zarządzanie tłem pulpitu przez **`hyprpaper`**.
* Włączone sterowanie przez IPC (`ipc = "on"`).
* Preload kolekcji tapet z katalogu `~/Pictures/Wallpapers/`.

#### [`viewConf.nix`](hyprland/viewConf.nix)
* Wymuszenie globalnego ciemnego motywu (Dark Theme) dla aplikacji GTK 3 i GTK 4.
