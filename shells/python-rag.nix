{ pkgs }:

let
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      psycopg
      pymupdf
      pip
      virtualenv
    ]
  );
in
pkgs.mkShell {
  buildInputs = [
    pythonEnv
    pkgs.stdenv.cc.cc.lib
    pkgs.zlib
  ];

  shellHook = ''
    # Light venv only with packages which aren't in nixpkgs
    if [ ! -d ".venv" ]; then
      echo "Inicjalizacja środowiska Python..."
      python -m venv --system-site-packages .venv
      .venv/bin/pip install --upgrade pip
      .venv/bin/pip install fastembed
    fi

    # Environment activation
    source .venv/bin/activate

    # Insert dependieces
    export LD_LIBRARY_PATH="${
      pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
      ]
    }:$LD_LIBRARY_PATH"

    echo "Env activated: fastembed, pymupdf and psycopg"
  '';
}
