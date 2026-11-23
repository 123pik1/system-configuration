{ flakePath, pkgs, ... }:
let
  flakeDir = "/home/pik/system-configuration";
in
# Pass through flakePath also #<name>
{
  systemd.services.nixos-update-remote = {
    description = "Rebuild NixOS in background";
    path = [
      pkgs.git
      pkgs.nixos-rebuild
      pkgs.systemd
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "nixos-update-remote" ''
        git -C ${flakeDir} pull --ff-only || exit 1
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${flakePath}
      '';
    };
  };

  systemd.timers.updateNixSystem = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "nixos-update-remote.service";
    };

  };
}
