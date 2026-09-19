{ pkgs }:
let 
    rustToolchain = pkgs.rust-bin.stable."1.96.0".default.override {
        extensions = [ "rust-src" "rust-analyzer" "rustfmt" "clippy" ];
    };
in
pkgs.mkShell {
    nativeBuildInputs = [
        pkgs.pkg-config
    ];

    buildInputs = [
        rustToolchain
        pkgs.libpcap
    ];
    
    RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
}
