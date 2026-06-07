{pkgs}:
pkgs.mkShell {
    buildInputs = [
        pkgs.nodejs_20
        pkgs.angular-language-server
        pkgs.typescript-language-server
    ];

    shellHook = ''
        echo "Angular environment"
        export PATH="$PWD/node_modules/.bin:$PATH"
    '';
}
