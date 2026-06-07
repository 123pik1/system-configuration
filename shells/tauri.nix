{ pkgs }:
let
  libraries = with pkgs; [
    webkitgtk_4_1
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    librsvg
  ];
in
pkgs.mkShell {
   # Compilers etc
   nativeBuildInputs = with pkgs; [
    rustc
    cargo
    cargo-tauri
    nodejs
    rust-analyzer
    rustfmt
    clippy
    pkg-config
  ];

  buildInputs = libraries;

  RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
  '';
}
