{ flakePath, pkgs, ... }:
# Pass through flakePath also #<name>
{
  systemd.services.nixos-update-remote = {
    description = "Rebuild NixOS in background";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${flakePath}";
    };
  };
}
