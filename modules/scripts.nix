{ pkgs, ... }:

let

  wallpaperDir = "~/Pictures/Wallpapers/";

  notesDir = "~/Projects/notes";

  configDir = "/home/pik/.config/my-nixos-configuration";

  vivadoShellDir = "/home/pik/Projects/Vivado";

  workspacesDir = "$HOME/Projects/workspaces/workspaces.json";

  randomWall = pkgs.writeShellScriptBin "random-wallpaper" ''
    WALLPAPER=$(find ${wallpaperDir} -type f | shuf -n 1)

    awww img "$WALLPAPER"
  '';

  vivadoEnvStart = pkgs.writeShellScriptBin "vivado" ''
    cd ${vivadoShellDir}

    nix-shell
  '';

  openNotes = pkgs.writeShellScriptBin "open-notes" ''
    cd ${notesDir}
    glow
  '';

  nixConf = pkgs.writeShellScriptBin "nix-conf" ''
    cd ~
    rm *.backup
    cd /home/pik/.config
    rm *.backup

    cd ${configDir}
    nvim resolver.nix
    sudo nixos-rebuild switch
  '';

  openingWorkspaces = pkgs.writeShellScriptBin "ws-open" ''
    JSON_FILE=${workspacesDir}
    KEY="''$1"

    if [ -z "''$KEY" ]; then
      echo "Available projects:"
      jq .[].name "${workspacesDir}"
      return 0
    fi

    JSON_OBJECT=$(jq --arg name "''$KEY" '.[] | select(.name == $name )' ${workspacesDir})

    LOCATION=$(echo "''$JSON_OBJECT" | jq -r .location)
    SUBSHELL=$(echo "''$JSON_OBJECT" | jq -r .subshell)

    cd "''$LOCATION"

    if [ "''$SUBSHELL" != "null" ]; then
      nix-shell "''$SUBSHELL"
    fi

  '';

  addingWorkspace = pkgs.writeShellScriptBin "ws-add" ''
    JSON_FILE=${workspacesDir}
    KEY="''$1"
    SUBSHELL="''$2"
    LOCATION=''$(pwd)

    if [ "''$SUBSHELL" == "" ]; then
      SUBSHELL=null
    fi


    TEMP_JSON=''$(mktemp)
    TMP2=''$(mktemp)

    jq -n --arg name "''$KEY" --arg loc "''$LOCATION" --arg shell "''$SUBSHELL" '[{"name": ''$name, "location": ''$loc, "subshell": ''$shell}]' >"''$TEMP_JSON"

    jq -s 'add' "''$JSON_FILE" "''$TEMP_JSON" >"''$TMP2" && mv "''$TMP2" "''$JSON_FILE"
  '';

in
{

  programs.bash.shellAliases = {
    ws-open = "source ws-open";
  };

  environment.systemPackages = [

    # to easier configure nix applications
    nixConf

    (pkgs.writeShellScriptBin "nix-edit" ''
      cd /home/pik/.config/my-nixos-configuration
      nvim resolver.nix
    '')

    (pkgs.writeShellScriptBin "start-waydroid" ''
      sudo systemctl start waydroid-container &
      waydroid session start
    '')

    randomWall

    vivadoEnvStart

    openNotes

    openingWorkspaces
    addingWorkspace
  ];
}
