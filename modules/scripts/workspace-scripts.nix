# Not used currently
# I currently does not work with workspaces so these scripts are outdated
# may not work properly, etc

{ pkgs, ... }:
let

  workspacesDir = "$HOME/Projects/workspaces/workspaces.json";

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
  environment.systemPackages = [
    openingWorkspaces
    addingWorkspace
  ];
}
