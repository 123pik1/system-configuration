{ pkgs }:
pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs_24
    pkgs.svelte-language-server
    pkgs.typescript-language-server
  ];

  shellHook = ''
    echo "Svelte environment"
    export PATH="$PWD/node_modules/.bin::$PATH"
  '';
}
