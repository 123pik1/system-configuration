{pkgs}:
pkgs.mkShell {

    nativeBuildInputs = [
        pkgs.pkg-config
    ];
    
    buildInputs = [
        pkgs.rustc
        pkgs.cargo
        pkgs.rust-analyzer
        pkgs.rustfmt
        pkgs.clippy

        # For macroquad
        pkgs.libx11
        pkgs.libxi
        pkgs.libxcursor
        pkgs.libxinerama
        pkgs.libxrandr
        pkgs.libglut
        pkgs.pkg-config
        pkgs.wayland
        pkgs.alsa-lib
    ];
    shellHook = ''
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${with pkgs; lib.makeLibraryPath [
        xorg.libX11
        xorg.libXi
        xorg.libXcursor
        xorg.libXinerama
        xorg.libXrandr
        libGL
        libxkbcommon
        wayland
        alsa-lib
        ]}"
    '';
    RUST_SRC_PATH=pkgs.rustPlatform.rustLibSrc;
}
