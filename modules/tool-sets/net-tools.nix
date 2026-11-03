{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.wget
    pkgs.wireshark
    pkgs.postman
  ];
}
