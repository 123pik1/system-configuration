{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # virtualization
    qemu
    docker
    docker-compose
    virt-manager
    lazydocker
  ];
}
