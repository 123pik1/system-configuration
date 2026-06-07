{pkgs}:
pkgs.mkShell {
    buildInputs = [
        pkgs.texliveFull
    ];

    shellHook = ''
    echo "latex environment"
    '';
}
