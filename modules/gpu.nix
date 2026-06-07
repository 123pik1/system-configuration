{ ... }:
{

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # ... your other settings ...

    # RTX 30-series supports the new open modules.
    # Set to "true" for the modern open-source kernel modules (Recommended for you).
    # Set to "false" for the classic proprietary kernel modules.
    open = true;

    modesetting.enable = true;
    nvidiaSettings = true;
    

    prime = {
      # Włączamy tryb Sync. Zapewnia on bezproblemowe działanie wyjść 
      # obrazu (HDMI, DP), bo NVIDIA cały czas w pełni kontroluje ekran.
      sync.enable = true; 
      
      # Adresy sprzętowe wyciągnięte z komendy 'ls -l /sys/class/drm/'
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    };
  hardware.graphics.enable32Bit = true;
}
