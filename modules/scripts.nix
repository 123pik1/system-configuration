{ ... }:
{

  programs.bash.shellAliases = {
    ws-open = "source ws-open";
  };

  imports = [
    ./scripts/random-wallpaper.nix
    ./scripts/open-notes.nix
  ];

}
