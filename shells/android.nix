{pkgs}:
pkgs.mkShell {
    buildInputs = [
        pkgs.android-studio
        pkgs.android-tools
    ];

    shellHook = ''
    echo "Android environment"
    '';


}
