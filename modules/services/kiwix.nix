{ pkgs, ... }:
let

in
{
  environment.systemPackages = with pkgs; [
    kiwix-tools
  ];

  systemd.services.kiwix-serve = {
    description = "Kiwix ZIM server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "always";
    };
  };
}
