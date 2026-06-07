{ config, pkgs, ...}: 
{
    sops = {
        defaultSopsFile = ./../secrets/passwords.yaml;
        defaultSopsFormat = "yaml";
    };
}
