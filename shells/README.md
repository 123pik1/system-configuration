# Środowiska Deweloperskie (`shells/`)

Katalog zawiera deklaratywne środowiska programistyczne definiowane przy użyciu `pkgs.mkShell` oraz `pkgs.buildFHSEnv`. Pozwalają one na natychmiastowe rozpoczęcie pracy nad projektami bez modyfikacji globalnego profilu systemu.

---

## Jak Korzystać?

### Uruchomienie powłoki:
```bash
nix develop .#<nazwa_shella> -c zsh
```

### Dedykowane aliasy w Zsh (`modules/shell.nix`):
* `rust-dev` → `nix develop .#rust -c zsh`
* `tauri-dev` → `nix develop .#tauri -c zsh`
* `nids-dev` → `nix develop .#nids -c zsh`
* `java-dev` → `nix develop .#java -c zsh`
* `cpp-dev` → `nix develop .#cpp -c zsh`
* `tex-dev` → `nix develop .#latex -c zsh`

---

## Dostępne Powłoki Deweloperskie

| Nazwa Flake'a | Plik | Zawartość i Narzędzia | Zastosowanie |
| :--- | :--- | :--- | :--- |
| **default / tauri** | [`tauri.nix`](tauri.nix) | Rust, Cargo, `cargo-tauri`, Node.js, WebKitGTK 4.1, GTK3, Cairo, D-Bus, librsvg | Tworzenie aplikacji desktopowych w frameworku Tauri |
| **rust** | [`rust.nix`](rust.nix) | Rustc, Cargo, rust-analyzer, clippy, rustfmt + biblioteki graficzne i okienkowe (X11, Wayland, ALSA, GLUT, Macroquad) | Programowanie w Rust, w tym silniki gier i aplikacje okienkowe |
| **rust96** | [`rust-1.96.nix`](rust-1.96.nix) | Stabilny toolchain Rust 1.96 z `rust-overlay` + `libpcap` + `rust-src` | Projekty wymagające konkretnej wersji kompilatora oraz analizy pakietów sieciowych (pcap) |
| **svelte** | [`svelte.nix`](svelte.nix) | Node.js 20, npm, `svelte-language-server`, `typescript-language-server` | Frontend webowy w technologii Svelte / SvelteKit |
| **angular** | [`angular.nix`](angular.nix) | Node.js 26, `angular-language-server`, `typescript-language-server` | Frontend webowy w ekosystemie Angular |
| **java** | [`java.nix`](java.nix) | OpenJDK 21, Maven, Lombok (zintegrowany `-javaagent`), PostgreSQL + skrypty pomocnicze bazy danych (`help`) | Backend w Java / Spring Boot z lokalną instancją bazy PostgreSQL |
| **cpp** | [`cpp.nix`](cpp.nix) | GCC, GDB, LLDB, GNU Make | Programowanie w C i C++, debugowanie natywne |
| **android** | [`android.nix`](android.nix) | Android Studio, Android SDK Tools (`adb`, `fastboot`) | Tworzenie aplikacji na system Android |
| **latex** | [`latex.nix`](latex.nix) | Pełna dystrybucja TeX Live (`texliveFull`) | Składanie dokumentów naukowych, prezentacji Beamer i artykułów LaTeX |
| **nids** | [`ml-nids.nix`](ml-nids.nix) | Python 3, Pytest, ZeroMQ (`pyzmq`), Scapy, Pydantic, PyYAML, Docker SDK, pyahocorasick | Projekt systemu wykrywania intruzów (NIDS) bazujący na uczeniu maszynowym i analizie ruchu sieciowego |
| **mc** | [`mc.nix`](mc.nix) | Środowisko FHS (`buildFHSEnv`) z kompletem bibliotek X11, GLib, TK, Tkinter, OpenGL | Narzędzia i aplikacje wymagające tradycyjnego layoutu FHS |

---

## Przykłady Użycia

### Praca z projektem Java i lokalną bazą danych:
```bash
nix develop .#java -c zsh

# Polecenie pomocnicze wewnątrz powłoki:
help
# db-start   -> uruchamia lokalną bazę postgres w katalogu .pgdata
# db-connect -> łączy z bazą przez psql
# db-stop    -> zatrzymuje bazę
```

### Kompilacja projektu Tauri:
```bash
nix develop .#tauri -c zsh
npm install
cargo tauri dev
```
