{ pkgs }:
pkgs.mkShell {
    packages = [
        (pkgs.python3.withPackages (p: [p.pyzmq]))
    ];

    buildInputs = [
        pkgs.python3Packages.pytest
        pkgs.zeromq
        pkgs.python3Packages.pydantic
        pkgs.python3Packages.pyahocorasick
        pkgs.python3Packages.docker
        pkgs.python3Packages.pyyaml
        pkgs.python3Packages.scapy
    ];

    shellHook = ''
        echo "pytest, 0mq, pydantic, pyahocorasick, python-docker, pyyaml, scapy"
    '';
}
