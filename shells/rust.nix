{pkgs}:
pkgs.mkShell {
    buildInputs = [
        pkgs.rustc
        pkgs.cargo
        pkgs.rust-analyzer
        pkgs.rustfmt
        pkgs.clippy
    ];
    RUST_SRC_PATH=pkgs.rustPlatform.rustLibSrc;
}
