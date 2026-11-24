{ pkgs, ... }:
let
  toggleMirrorHyprlandScript = pkgs.writeShellScriptBin "toggle-mirror-hypr" ''
    # Pobierz nazwy podłączonych monitorów za pomocą hyprctl i jq
    MONITORS=$(${pkgs.hyprland}/bin/hyprctl monitors -j)
    COUNT=$(echo "$MONITORS" | ${pkgs.jq}/bin/jq 'length')

    if [ "$COUNT" -lt 2 ]; then
      ${pkgs.libnotify}/bin/notify-send "Hyprland" "Podłączono tylko jeden monitor."
      exit 1
    fi

    # Zakładamy, że pierwszy to główny (np. eDP-1), a drugi to zewnętrzny (np. HDMI-A-1)
    PRIMARY=$(echo "$MONITORS" | ${pkgs.jq}/bin/jq -r '.[0].name')
    SECONDARY=$(echo "$MONITORS" | ${pkgs.jq}/bin/jq -r '.[1].name')

    # Sprawdź, czy drugi monitor już duplikuje pierwszy
    IS_MIRRORED=$(echo "$MONITORS" | ${pkgs.jq}/bin/jq -r ".[1].mirrorOf")

    if [ "$IS_MIRRORED" == "none" ] || [ -z "$IS_MIRRORED" ]; then
      # Włącz duplikowanie (SECONDARY kopiuje obraz z PRIMARY)
      ${pkgs.hyprland}/bin/hyprctl keyword monitor "$SECONDARY, preferred, auto, 1, mirror, $PRIMARY"
      ${pkgs.libnotify}/bin/notify-send "Hyprland" "Tryb: Duplikowanie ekranu ($SECONDARY -> $PRIMARY)"
    else
      # Przywróć tryb rozszerzony (domyślny)
      ${pkgs.hyprland}/bin/hyprctl keyword monitor "$SECONDARY, preferred, auto, 1"
      ${pkgs.libnotify}/bin/notify-send "Hyprland" "Tryb: Rozszerzony ekran"
    fi
  '';
in
{
  environment.systemPackages = [
    toggleMirrorHyprlandScript
  ];
}
