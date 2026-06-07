{pkgs}:
pkgs.mkShell {
    buildInputs = [
        pkgs.jdk21
        pkgs.maven
        pkgs.lombok
        pkgs.postgresql
        (pkgs.writeShellScriptBin "help" ''
        echo "run: mvn exec:jaca -Dexec.mainClass="
        
        echo "compile: mvn clean compile"

        echo 'db localization: export PGDATA="$PWD/.pgdata/"'
        
        echo "db-start: pg_ctl -l $PGDATA/server.log -D $PGDATA start"

        echo "db-connect: psql -h 127.0.0.1 -d postgres"

        echo "db-stop: pg_ctl stop -D $PGDATA"
        '')
    ];

    shellHook = ''
        export JAVA_TOOL_OPTIONS="-javaagent:${pkgs.lombok}/share/java/lombok.jar"

        export PGDATA="$PWD/.pgdata"

        echo "JAVA and postgres env"
    '';
}
