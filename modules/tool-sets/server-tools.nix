{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cloudflared
    screen
    # to manage disks
    hdparm
    # Specific java packaage
    javaPackages.compiler.temurin-bin.jdk-25
  ];

}
