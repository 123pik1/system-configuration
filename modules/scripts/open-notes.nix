{ pkgs, ... }:
let

  notesDir = "~/Projects/notes";

  openNotes = pkgs.writeShellScriptBin "open-notes" ''
    cd ${notesDir}
    glow
  '';
in
{
  environment.systemPackages = [ openNotes ];
}
