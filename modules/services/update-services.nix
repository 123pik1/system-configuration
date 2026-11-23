{
  pkgs,
  ...
}:
let

  services = [
    {
      dir = "/var/lib/blog-services/blog-backend";
      build = "mvn -B clean package && docker build -t moj-blog:backendv1 .";
      restart = "systemctl restart docker-blog-backend.service";
    }

    {
      dir = "/var/lib/blog-services/blog-frontend";
      build = "docker build -t blog-frontend:v4 .";
      restart = "systemctl restart docker-blog-frontend.service";
    }
  ];
  updateScript = pkgs.writeShellScriptBin "update-services" ''
      set -u

      update_service() {
      local dir="$1"
      local build="$2"
      local restart="$3"

      if [ ! -d "$dir/.git" ]; then
        echo "FAILED $dir: not a Git repository"
        return 1
      fi

      local before
      before="$(git -C "$dir" rev-parse HEAD)" ||
        { echo "FAILED $dir: cannot read HEAD"; return 1; }

      if ! git -C "$dir" pull --ff-only --quiet; then
        echo "FAILED $dir: git pull --ff-only"
        return 1
      fi

      local after
      after="$(git -C "$dir" rev-parse HEAD)"

      if [ "$before" = "$after" ]; then
        echo "SKIPPED $dir: no changes"
        return 0
      fi

      echo "CHANGED $dir: $before -> $after"

      if [ -n "$build" ]; then
        if ! (cd "$dir" && bash -c "$build"); then
          echo "FAILED $dir: build"
          return 1
        fi
      fi

      if [ -n "$restart" ]; then
        if ! bash -c "$restart"; then
          echo "FAILED $dir: restart"
          return 1
        fi
      fi

      echo "OK $dir"
    }

    ${builtins.concatStringsSep "\n" (
      map (
        service:
        "update_service "
        + pkgs.lib.escapeShellArg service.dir
        + " "
        + pkgs.lib.escapeShellArg service.build
        + " "
        + pkgs.lib.escapeShellArg service.restart
      ) services
    )}
  '';
in
{
  environment.systemPackages = [
    updateScript
  ];

  systemd.services.update-services = {
    description = "Update Git-based services";
    path = [
      pkgs.bash
      pkgs.coreutils
      pkgs.git
      pkgs.docker
      pkgs.systemd
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${updateScript}/bin/update-services";
    };
  };

  systemd.timers.updateServices = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "update-services.service";
    };

  };

}
