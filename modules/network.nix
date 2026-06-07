{ config, pkgs, ... }:

{
  # 1. Włączenie przekazywania pakietów IP (Routing)
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # 2. Konfiguracja interfejsów sieciowych
  networking = {
    interfaces.enp3s0.ipv4.addresses = [
      {
        address = "192.168.100.1";
        prefixLength = 24;
      }
    ];

    # 3. Konfiguracja NAT (Udostępnianie internetu z enp2s0 do enp3s0)
    nat = {
      enable = true;
      internalInterfaces = [ "enp3s0" ];
      externalInterface = "enp2s0";

      extraCommands = "iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE";
    };

    # 4. Firewall - otwarcie portów dla DHCP i DNS dla laptopa
    firewall = {
      enable = true;

      allowedUDPPorts = [ 5864 ];
      checkReversePath = "loose";

      trustedInterfaces = [
        "enp3s0"
        "lo"
        "docker0"
        "tailscale0"
      ]; # Ufamy urządzeniom na porcie 2 oraz na loopbacku
    };
  };

  # 5. Serwer DHCP (dnsmasq), aby laptop dostał IP automatycznie
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "enp3s0";
      dhcp-range = "192.168.100.10,192.168.100.50,24h";
      # Opcja 3 to brama domyślna (gateway), opcja 6 to DNS
      dhcp-option = [
        "3,192.168.100.1"
        "6,8.8.8.8"
      ];
    };
  };
}
