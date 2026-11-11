# Konfiguracja Hyprland (`modules/home-manager/hyprland/`)

Katalog zawiera kompletną konfigurację nowoczesnego środowiska Wayland opartego o kafelkowy kompozytor okien **Hyprland**, skonfigurowany w oparciu o składnię **Lua**.

---

## Zawartość Katalogu

```text
modules/home-manager/hyprland/
├── hyprland.nix       # Główny plik kompozytora w Lua, skróty klawiszowe, autostart, Ghostty, Swappy
├── waybar.nix         # Pasek statusu Waybar oraz menu wylogowania i zasilania wlogout
├── file-explorer.nix  # Terminalowy menedżer plików Yazi z integracją drag-and-drop (ripdrag)
├── hyprpaper.nix      # Demon tapet hyprpaper (alternatywny backend tapet)
├── viewConf.nix       # Globalne ustawienia ciemnego motywu GTK 3 i GTK 4
└── README.md          # Dokumentacja środowiska Hyprland
```

---

## Opis Poszczególnych Komponentów

### 1. Główny Moduł Kompozytora ([`hyprland.nix`](hyprland.nix))
* Zdefiniowany z użyciem formatu **Lua** (`configType = "lua"`):
  * Czysty, programistyczny zapis reguł i mapowań klawiszy przy użyciu dyspozytorów `hl.bind(...)` oraz funkcji `hl.dsp.*`.
* **Główne zmienne i aplikacje:**
  * Klawisz modyfikatora: `SUPER` (`$mod`).
  * Terminal domyślny: `ghostty`.
  * Menu uruchamiania programów: `wofi --show drun --allow-images`.
  * Wybór emoji: `rofimoji --action copy` (`SUPER + E`).
* **Programy uruchamiane przy starcie (Autostart):**
  * `waybar` – pasek zadań.
  * `mako` – demon powiadomień.
  * `awww-daemon` i `random-wallpaper` – dynamiczne zarządzanie tapetami.
  * `udiskie` – automatyczne wykrywanie i montowanie nośników wymiennych.
  * `polkit-kde-authentication-agent-1` – agent uwierzytelniania Polkit KDE.
  * `fancy-hyprland` – ładowanie domyślnych efektów wizualnych (cienie, zaokrąglenia okien, rozmycie).
  * `blueman-applet` – aplet zarządzania Bluetooth w tacce systemowej.
* **Wbudowane konfiguracje aplikacji (`xdg.configFile`):**
  * **Ghostty (`ghostty/config`):** Font `JetBrainsMono Nerd Font` (11pt, Medium), przezroczystość tła `0.85` z rozmyciem (`background-blur = true`), usunięte obramowanie okna (`window-decoration = false`), marginesy wewnętrzne 12px.
  * **Swappy (`swappy/config`):** Zapis zrzutów ekranu do `~/Pictures/Screenshots`, automatyczne chowanie paska po edycji.

---

### 2. Pasek Statusu i Zasilanie ([`waybar.nix`](waybar.nix))
* **Waybar:**
  * Moduły obszarów roboczych i tytułu bieżącego okna po lewej stronie.
  * Wyśrodkowany zegar z datą.
  * Sekcja prawa z wskaźnikami: GameMode, głośność (PipeWire/PulseAudio z wywołaniem `pavucontrol`), sieć LAN/Wi-Fi, obciążenie procesora, zużycie pamięci RAM, stan baterii, tacka systemowa (`tray`) oraz przycisk wywołania menu zasilania.
  * Zależności fontowe: `nerd-fonts.jetbrains-mono`, `font-awesome`.
* **Wlogout:**
  * Ekranowe menu wylogowania ze skrótami klawiszowymi:
    * `l` – blokada ekranu (`hyprlock`)
    * `h` – hibernacja (`systemctl hibernate`)
    * `e` – wylogowanie z Hyprlanda (`hyprctl dispatch exit`)
    * `s` – wyłączenie komputera (`systemctl poweroff`)
    * `u` – uśpienie (`systemctl suspend`)
    * `r` – restart (`systemctl reboot`)

---

### 3. Eksplorator Plików ([`file-explorer.nix`](file-explorer.nix))
* **Yazi:**
  * Automatyczna nawigacja po wyjściu (`y` wrapper w Zsh).
  * Układ trzech kolumn: `[1, 4, 3]`.
  * Wbudowane wsparcie przeciągania plików (Drag & Drop):
    * Klawisz `<Ctrl+k>` uruchamia narzędzie `ripdrag "$@"`, umożliwiając przeciąganie zaznaczonych plików bezpośrednio z terminala do przeglądarki lub komunikatorów.

---

### 4. Demon Tapet ([`hyprpaper.nix`](hyprpaper.nix))
* Usługa demona `hyprpaper` z preładowaniem grafik tła z `~/Pictures/Wallpapers/` oraz aktywnym interfejsem sterowania IPC.

---

### 5. Wygląd i Motywy ([`viewConf.nix`](viewConf.nix))
* Konfiguracja GTK 3 oraz GTK 4:
  * Wymuszenie `gtk-application-prefer-dark-theme = 1` w celu zachowania spójnego, ciemnego stylu wizualnego we wszystkich aplikacjach okienkowych.
