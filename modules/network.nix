{ ... }:

{
  # 1. Enabling ip routing
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # 2. Configuration of internal network interface
  networking = {
    interfaces.enp3s0.ipv4.addresses = [
      {
        address = "192.168.100.1";
        prefixLength = 24;
      }
    ];

    # 3. NAT configuration
    nat = {
      enable = true;
      internalInterfaces = [ "enp3s0" ];
      externalInterface = "enp2s0";

      extraCommands = "iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE";
    };

    # 4. Firewall - Open DHCP and DNS for internal network
    firewall = {
      enable = true;

      allowedUDPPorts = [ 5864 ];
      checkReversePath = "loose";

      # We trust these interfaces - enp3s0 is not connected to internet directly
      trustedInterfaces = [
        "enp3s0"
        "lo"
        "docker0"
        "tailscale0"
      ];
    };
  };

  # 5. Server DHCP (dnsmasq), anything connected to enp3s0 should get automatic address
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "enp3s0";
      dhcp-range = "192.168.100.10,192.168.100.50,24h";
      # 3 - default gateway
      # 6 - default DNS
      dhcp-option = [
        "3,192.168.100.1"
        "6,8.8.8.8"
      ];
    };
  };
}
