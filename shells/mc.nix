{ pkgs }:

(pkgs.buildFHSEnv {
  name = "app-env";
  targetPkgs = pkgs: with pkgs; [
    # Narzędzia bazowe i Python
    xorg.xrdb
    xorg.libxcb
    tcl
    tk
    glib
    zlib

    # Zależności X11
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libICE
    xorg.libSM
    xorg.libXtst
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes

    # GTK i JavaFX
    gtk3
    cairo
    pango
    gdk-pixbuf

    # Zależności ogólne
    alsa-lib
    freetype
    fontconfig
    pciutils
    udev

    # Grafika (Rozwiązuje błąd renderowania)
    libGL
    libglvnd       # Rozwiązuje błąd: Could not retrieve OpenGL functions
    vulkan-loader  # Rozwiązuje błąd: Vulkan loader library is missing
    mesa
  ];
  runScript = "bash";
}).env
