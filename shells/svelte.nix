{pkgs}:
pkgs.mkShell {
    buildInputs = [
        pkgs.nodejs_20
        pkgs.svelte-language-server
        pkgs.typescript-language-server
        pkgs.nodePackages.npm
    ];

    shellHook = ''
        echo "Svelte environment"
        export PATH="$PWD/node_modules/.bin::$PATH"
    '';
}
