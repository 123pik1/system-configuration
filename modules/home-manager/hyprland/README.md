# Konfiguracja Hyprland (`modules/home-manager/hyprland/`)

Katalog zawiera pełną konfigurację środowiska Wayland opartego o kafelkowy kompozytor okien **Hyprland**.

---

## Zawartość Katalogu

```text
modules/home-manager/hyprland/
├── hyprland.nix       # Główna konfiguracja kompozytora (hyprlang, zmienne środowiskowe, reguły)
├── waybar.nix         # Konfiguracja paska zadań Waybar oraz menu wylogowania wlogout
├── file-explorer.nix  # Konfiguracja menedżera plików Yazi z integracją Zsh
├── hyprpaper.nix      # Usługa zarządzania tapetami pulpitu (hyprpaper daemon)
└── viewConf.nix       # Ustawienia motywów GTK i preferencji ciemnego stylu
```

---

## Opis Poszczególnych Plików

### 1. [`hyprland.nix`](hyprland.nix)
* Główny plik kompozytora importujący pozostałe moduły.
* Konfiguracja w formacie `hyprlang` (`configType = "hyprlang"`).
* **Zmienne środowiskowe:**
  * Wymuszenie motywów Qt: `QT_QPA_PLATFORMTHEME=qt6ct`.
  * Kursor systemowy: motyw `breeze_cursors`, rozmiar `24`.

### 2. [`waybar.nix`](waybar.nix)
* Pasek statusu **Waybar** wyświetlający aktywne obszary robocze, obciążenie CPU/RAM, stan baterii, zegar i tackę systemową.
* Wymagane fonty: `nerd-fonts.jetbrains-mono`, `font-awesome`.
* Integracja z menu wyjścia **`wlogout`**:
  * `l` → `hyprlock` (blokada ekranu)
  * `h` → `systemctl hibernate` (hibernacja)
  * Obsługa restartu, wyłączenia i wylogowania.

### 3. [`file-explorer.nix`](file-explorer.nix)
* Terminalowy menedżer plików **`yazi`**:
  * Skrót `y` w powłoce Zsh automatycznie przechodzący do ostatnio przeglądanego katalogu.
  * Układ kolumn: `[1, 4, 3]` (katalog nadrzędny, bieżący, podgląd).
  * Podgląd plików tekstowych, grafik i multimediów w wysokiej rozdzielczości.
  * Własne mapowanie klawiszy.

### 4. [`hyprpaper.nix`](hyprpaper.nix)
* Demon tapet **`hyprpaper`** z aktywnym interfejsem IPC.
* Wstępne ładowanie grafik z katalogu `~/Pictures/Wallpapers/`.

### 5. [`viewConf.nix`](viewConf.nix)
* Globalne reguły wyglądu i stylów GTK 3 / GTK 4, wymuszające preferencję ciemnego motywu (`prefer-dark-theme`).
