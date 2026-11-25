{ pkgs, ... }:
let
  toggleMirrorHyprlandScript = pkgs.writeShellScriptBin "toggle-mirror-hypr" ''
    set -euo pipefail

    HYPRCTL=${pkgs.hyprland}/bin/hyprctl
    JQ=${pkgs.jq}/bin/jq
    NOTIFY=${pkgs.libnotify}/bin/notify-send

    if ! MONITORS=$("$HYPRCTL" monitors all -j); then
      "$NOTIFY" "Hyprland" "Nie udało się pobrać listy monitorów."
      exit 1
    fi

    if ! MONITORS=$(printf '%s\n' "$MONITORS" | "$JQ" -ce '[.[] | select(.disabled != true)]'); then
      "$NOTIFY" "Hyprland" "Nie udało się odczytać listy monitorów."
      exit 1
    fi

    if ! COUNT=$(printf '%s\n' "$MONITORS" | "$JQ" -er 'length'); then
      "$NOTIFY" "Hyprland" "Nie udało się odczytać listy monitorów."
      exit 1
    fi

    if [ "$COUNT" -lt 2 ]; then
      "$NOTIFY" "Hyprland" "Podłączono tylko jeden monitor."
      exit 1
    fi

    MIRRORED_SECONDARY=$(printf '%s\n' "$MONITORS" | "$JQ" -r '[.[] | select((.mirrorOf // "none") != "none") | .name][0] // empty')
    if [ -n "$MIRRORED_SECONDARY" ]; then
      SECONDARY=$MIRRORED_SECONDARY
      MIRROR_ID=$(printf '%s\n' "$MONITORS" | "$JQ" -r --arg name "$SECONDARY" '.[] | select(.name == $name) | .mirrorOf')
      PRIMARY=$(printf '%s\n' "$MONITORS" | "$JQ" -er --arg id "$MIRROR_ID" '.[] | select((.id | tostring) == $id) | .name')
      IS_MIRRORED=true
    else
      PRIMARY=$(printf '%s\n' "$MONITORS" | "$JQ" -er '.[0].name')
      SECONDARY=$(printf '%s\n' "$MONITORS" | "$JQ" -er '.[1].name')
      IS_MIRRORED=false
    fi

    PRIMARY_LUA=$(printf '%s' "$PRIMARY" | "$JQ" -Rs .)
    SECONDARY_LUA=$(printf '%s' "$SECONDARY" | "$JQ" -Rs .)

    if [ "$IS_MIRRORED" = false ]; then
      MIRROR_LUA=$PRIMARY_LUA
      SUCCESS_MESSAGE="Tryb: Duplikowanie ekranu ($SECONDARY -> $PRIMARY)"
      ERROR_MESSAGE="Nie udało się włączyć duplikowania ekranu"
    else
      MIRROR_LUA='""'
      SUCCESS_MESSAGE="Tryb: Rozszerzony ekran"
      ERROR_MESSAGE="Nie udało się przywrócić rozszerzonego ekranu"
    fi

    MONITOR_RULE="hl.monitor({
      output = $SECONDARY_LUA,
      mode = \"preferred\",
      position = \"auto\",
      scale = 1,
      mirror = $MIRROR_LUA
    })"

    if ! RESPONSE=$("$HYPRCTL" eval "$MONITOR_RULE") || [ "$RESPONSE" != "ok" ]; then
      "$NOTIFY" "Hyprland" "$ERROR_MESSAGE: $RESPONSE"
      exit 1
    fi

    "$NOTIFY" "Hyprland" "$SUCCESS_MESSAGE"
  '';
in
{
  environment.systemPackages = [
    toggleMirrorHyprlandScript
  ];
}
