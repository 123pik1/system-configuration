# Konfiguracja Środowiska Użytkownika (`modules/home-manager/`)

Katalog zawiera deklaratywne moduły Home Managera odpowiedzialne za konfigurację środowiska graficznego Wayland, kompozytora Hyprland, menedżerów plików oraz aplikacji codziennego użytku.

---

## Struktura Katalogu

```text
modules/home-manager/
├── browser.nix            # Konfiguracja profilu przeglądarki Mozilla Firefox
├── hyprland/              # Kompletne środowisko graficzne Hyprland (Wayland)
│   ├── hyprland.nix       # Główny plik kompozytora w formacie Lua, zmienne, skróty, autostart
│   ├── waybar.nix         # Pasek statusu Waybar oraz menu zasilania wlogout
│   ├── file-explorer.nix  # Terminalowy menedżer plików Yazi z integracją ripdrag (<C-k>)
│   ├── hyprpaper.nix      # Zarządzanie tapetami przez demona hyprpaper (alternatywa dla awww)
│   ├── viewConf.nix       # Wymuszenie globalnego ciemnego stylu dla aplikacji GTK
│   └── README.md          # Szczegółowa dokumentacja środowiska Hyprland
└── README.md              # Dokumentacja modułu Home Manager
```

---

## Opis Komponentów

### 1. Przeglądarka ([`browser.nix`](browser.nix))
* Konfiguracja profilu **Mozilla Firefox**.
* Ustawienie domyślnego regionu wyszukiwania na `PL` (`browser.search.region = "PL"`).
* Zarządzanie profilem użytkownika w ścieżce `.mozilla/firefox`.

---

### 2. Środowisko Hyprland ([`hyprland/`](hyprland/README.md))

#### [`hyprland/hyprland.nix`](hyprland/hyprland.nix)
* Włączenie i konfiguracja kompozytora **Hyprland** w oparciu o nowoczesny format **Lua** (`configType = "lua"`).
* Integracja z motywami Qt (`QT_QPA_PLATFORMTHEME=qt6ct`) oraz kursorem Breeze (`breeze_cursors`, 24px).
* **Autostart usług:** `waybar`, `mako`, `awww-daemon`, `random-wallpaper`, `udiskie`, agent uwierzytelniania Polkit KDE, `fancy-hyprland`, `blueman-applet`.
* **Domyślny terminal:** `ghostty` ze zdefiniowaną przezroczystością (`background-opacity = 0.85`), rozmyciem tła (`background-blur = true`), brakiem obramowania okna i fontem `JetBrainsMono Nerd Font`.
* **Narzędzie zrzutów ekranu:** integracja ze `swappy` w `xdg.configFile."swappy/config"`.

#### [`hyprland/waybar.nix`](hyprland/waybar.nix)
* Pasek stanu **Waybar** zoptymalizowany dla kafelkowego menedżera okien:
  * Lewa sekcja: obszary robocze (`hyprland/workspaces`), aktywne okno (`hyprland/window`).
  * Środek: zegar z kalendarzem.
  * Prawa sekcja: GameMode, PulseAudio/PipeWire (`pavucontrol`), sieć, CPU, RAM, poziom baterii, tacka systemowa (`tray`), menu zasilania.
* Wymagane fonty: `nerd-fonts.jetbrains-mono` oraz `font-awesome`.
* Zintegrowane menu wyjścia i blokady **`wlogout`**:
  * `Lock` (`l`) → `hyprlock`
  * `Hibernate` (`h`) → `systemctl hibernate`
  * `Logout` (`e`) → wyjście z sesji Hyprland
  * `Shutdown` (`s`) → wyłączenie komputera
  * `Suspend` (`u`) → uśpienie systemu
  * `Reboot` (`r`) → ponowne uruchomienie

#### [`hyprland/file-explorer.nix`](hyprland/file-explorer.nix)
* Szybki terminalowy eksplorator plików **`yazi`**:
  * Skrót `y` w powłoce Zsh automatycznie zmieniający katalog roboczy po zamknięciu programu.
  * Proporcje kolumn: `[1, 4, 3]` (katalog nadrzędny, bieżący, podgląd).
  * Naturalne sortowanie katalogów na początku listy oraz wyświetlanie rozmiarów.
  * Zaawansowany podgląd grafik i dokumentów o wymiarach do 1000x1000px.
  * **Obsługa Drag & Drop:** podpięcie narzędzia `ripdrag` pod kombinację `<Ctrl+k>`.

#### [`hyprland/hyprpaper.nix`](hyprland/hyprpaper.nix)
* Demon tapet **`hyprpaper`** z aktywnym sterowaniem IPC (`ipc = "on"`).
* Wstępne ładowanie grafik z katalogu `~/Pictures/Wallpapers/`.

#### [`hyprland/viewConf.nix`](hyprland/viewConf.nix)
* Wymuszenie spójnego ciemnego motywu (Dark Theme) dla aplikacji bazujących na bibliotekach GTK 3 oraz GTK 4 (`gtk-application-prefer-dark-theme = 1`).
