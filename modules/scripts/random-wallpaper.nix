{ pkgs, ... }:
let
  wallpaperDir = "~/Pictures/Wallpapers/";

  randomWall = pkgs.writeShellScriptBin "random-wallpaper" ''
    WALLPAPER=$(find ${wallpaperDir} -type f | shuf -n 1)

    awww img "$WALLPAPER"
  '';
in
{
  environment.systemPackages = [ randomWall ];
}
