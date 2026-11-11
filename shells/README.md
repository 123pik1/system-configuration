# Środowiska Deweloperskie (`shells/`)

Katalog zawiera deklaratywne środowiska programistyczne definiowane przy użyciu `pkgs.mkShell` oraz `pkgs.buildFHSEnv`. Pozwalają one na natychmiastowe rozpoczęcie pracy nad projektami bez modyfikacji globalnego profilu systemu i bez konfliktów pomiędzy różnymi wersjami zależności.

---

## Jak Korzystać?

### Uruchomienie wybranej powłoki:
```bash
nix develop .#<nazwa_shella> -c zsh
```

### Dedykowane aliasy w Zsh (`modules/shell.nix`):
* `rust-dev` → `nix develop .#rust -c zsh`
* `tauri-dev` → `nix develop .#tauri -c zsh`
* `nids-dev` → `nix develop .#nids -c zsh`
* `java-dev` → `nix develop .#java -c zsh`
* `cpp-dev` → `nix develop .#cpp -c zsh`
* `tex-dev` / `latex-dev` → `nix develop .#latex -c zsh`

---

## Dostępne Powłoki Deweloperskie

| Nazwa Flake'a | Plik | Zawartość i Narzędzia | Zastosowanie |
| :--- | :--- | :--- | :--- |
| **python-rag** | [`python-rag.nix`](python-rag.nix) | Python 3, `psycopg`, `pymupdf`, `virtualenv`, `pip`, biblioteki systemowe `zlib`, `stdenv.cc.cc.lib` + automatyczny `fastembed` w `.venv` | Projekty RAG (Retrieval-Augmented Generation), przetwarzanie dokumentów PDF, integracja z bazami wektorowymi i PostgreSQL |
| **tauri** | [`tauri.nix`](tauri.nix) | Rust, Cargo, `cargo-tauri`, Node.js, WebKitGTK 4.1, GTK3, Cairo, D-Bus, librsvg | Tworzenie aplikacji desktopowych w frameworku Tauri |
| **rust** | [`rust.nix`](rust.nix) | Rustc, Cargo, rust-analyzer, clippy, rustfmt + biblioteki okienkowe i multimedialne (X11, Wayland, ALSA, GLUT, Macroquad) | Programowanie w języku Rust, silniki gier i aplikacje okienkowe |
| **rust96** | [`rust-1.96.nix`](rust-1.96.nix) | Stabilny toolchain Rust 1.96 z `rust-overlay` + `libpcap` + `rust-src` | Projekty wymagające konkretnej wersji kompilatora oraz niskopoziomowej analizy pakietów sieciowych (pcap) |
| **svelte** | [`svelte.nix`](svelte.nix) | Node.js 20, npm, `svelte-language-server`, `typescript-language-server` | Frontend webowy w technologii Svelte i SvelteKit |
| **angular** | [`angular.nix`](angular.nix) | Node.js 26, `angular-language-server`, `typescript-language-server` | Frontend webowy w ekosystemie Angular |
| **java** | [`java.nix`](java.nix) | OpenJDK 21, Maven, Lombok (zintegrowany `-javaagent`), PostgreSQL + skrypty pomocnicze bazy danych (`help`, `db-start`, `db-connect`, `db-stop`) | Backend w Java / Spring Boot z lokalną instancją bazy PostgreSQL |
| **cpp** | [`cpp.nix`](cpp.nix) | GCC, GDB, LLDB, GNU Make | Programowanie w C i C++, debugowanie natywne |
| **android** | [`android.nix`](android.nix) | Android Studio, Android SDK Tools (`adb`, `fastboot`) | Tworzenie i testowanie aplikacji na system Android |
| **latex** | [`latex.nix`](latex.nix) | Pełna dystrybucja TeX Live (`texliveFull`) | Składanie dokumentów naukowych, książek, prezentacji Beamer i artykułów LaTeX |
| **nids** | [`ml-nids.nix`](ml-nids.nix) | Python 3, Pytest, ZeroMQ (`pyzmq`), Scapy, Pydantic, PyYAML, Docker SDK, pyahocorasick | Projekt systemu wykrywania intruzów (NIDS) oparty o uczenie maszynowe i analizę ruchu pakietów |
| **mc** | [`mc.nix`](mc.nix) | Środowisko FHS (`buildFHSEnv`) z kompletem bibliotek X11, GLib, TK, Tkinter, OpenGL | Narzędzia i aplikacje wymagające tradycyjnego layoutu linuksowego FHS |

---

## Przykłady Użycia

### 1. Praca z projektem Python RAG:
```bash
nix develop .#python-rag -c zsh
```
* Powłoka automatycznie sprawdza obecność katalogu `.venv`:
  * Jeśli nie istnieje, tworzy lekkie środowisko z flagą `--system-site-packages`.
  * Aktualizuje `pip` i instaluje pakiet `fastembed`.
* Aktywuje wirtualne środowisko i eksportuje `LD_LIBRARY_PATH` dla wymaganych bibliotek natywnych C/C++ i `zlib`.

### 2. Praca z projektem Java i lokalną bazą danych:
```bash
nix develop .#java -c zsh

# Polecenie pomocnicze wewnątrz powłoki:
help
# db-start   -> uruchamia lokalną instancję bazy PostgreSQL w katalogu .pgdata
# db-connect -> łączy z bazą przez psql
# db-stop    -> bezpiecznie zatrzymuje bazę danych
```

### 3. Kompilacja projektu Tauri:
```bash
nix develop .#tauri -c zsh
npm install
cargo tauri dev
```
