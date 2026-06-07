{ lib, ... }:
{

  specialisation = {
    battery-mode.configuration = {
      system.nixos.tags = [ "battery-mode" ];

      # 1. Wyłączamy moduły kernela (także framebuffer, który się pojawił w lspci)
      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidiafb" # Blokujemy też framebuffera
      ];

      # 2. Tylko AMD
      services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];

      # 3. Zmienne środowiskowe (czyszczenie)
      environment.variables = {
        "AQ_DRM_DEVICES" = lib.mkForce null;
        "WLR_DRM_DEVICES" = lib.mkForce null;
      };

      # 4. ROZWIĄZANIE ATOMOWE: Usuń urządzenie z systemu
      services.udev.extraRules = ''
        # Usuń urządzenie Audio Nvidii (to, które trzyma sterownik snd_hda_intel)
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

        # Usuń urządzenie VGA Nvidii
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}="auto", ATTR{remove}="1"

        # Usuń ewentualne kontrolery USB-C na karcie Nvidii (często są w RTX 3060)
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      '';

      # 5. Skrypt startowy "sprzątający" na wypadek, gdyby udev zadziałał za wolno
      # Próbuje ręcznie odpiąć sterownik audio, jeśli system już zdążył go załadować
      boot.postBootCommands = ''
        for dev in /sys/bus/pci/devices/0000:01:00.*; do
          if [ -d "$dev" ]; then
            echo 1 > "$dev/remove"
          fi
        done
      '';
      systemd.services."systemd-backlight@leds:kbd_backlight".enable = lib.mkForce false;

    };
  };
}
