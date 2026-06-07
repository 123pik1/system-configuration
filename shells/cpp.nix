{pkgs}:
pkgs.mkShell {
    buildInputs = with pkgs; [
        gcc
        gdb
        lldb
        gnumake
    ];

}
