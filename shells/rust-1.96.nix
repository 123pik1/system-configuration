{ pkgs }:
let 
    rustToolchain = pkgs.rust-bin.stable."1.96.0".default.override {
        extensions = [ "rust-src" "rust-analyzer" "rustfmt" "clippy" ];
    };
in
pkgs.mkShell {
    buildInputs = [
        rustToolchain
    ];
    
    RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
}
