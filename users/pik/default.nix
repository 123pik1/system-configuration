{
  pkgs,
  lib,
  inputs,
  useHomeManager ? true,
  ...
}:
{

  users.users.pik = {
    isNormalUser = true;
    description = "pik";
    initialPassword = "test";
    
    shell = pkgs.zsh;

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  home-manager = lib.mkIf useHomeManager {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.pik = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
