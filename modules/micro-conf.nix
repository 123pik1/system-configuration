{  lib, pkgs, ... }:

let
    lspServerString = lib.concatStringsSep "," [
        "nix=nixd"
        "python=pyright-langserver --stdio"
        "c=clangd"
        "c++=clangd"
        "sh=bash-language-server start"
        "lua=lua-language-server"
        "go=gopls"
        "zig=zls"
      ];

  microSettings = pkgs.writeText "settings.json" (builtins.toJSON {

    "colorscheme" = "twilight"; #"gruvbox"

    "cursorline" = true;
    "scrollbar" = true;
    "statusline" = true;
    "diffgutter" = true;
    "mouse" = true;
    "clipboard" = "external";
    "su" = true;
    "tabsize" = 4;
    "tabstospaces" = true;
    "autoclose" = true;
    "rmtrailingws" = true;
    "formatonSave" = true;
    "autofmt" = true;
    "filemanager.width" = 30;


    "lsp.server" = lspServerString;
    # "lsp.formatOnSave" = false;      # Set to false to let 'autofmt' handle formatting, or true to let LSP do it
    "lsp.tabcompletion" = true;      # Enable LSP autocomplete on Tab
    "lsp.autocompleteDetails" = true; # Show details (signature) in autocomplete popup
        # "lsp.ignoreTriggerCharacters" = "completion,signature"; # Less noise

    # formatters
    "ft:nix" = { "formatter" = "nixfmt"; };
    "ft:python" = { "formatter" = "black"; };
    "ft:c" = { "formatter" = "clang-format"; };
    "ft:sh" = { "formatter" = "shfmt -i 4"; };
    "ft:lua" = { "formatter" = "stylua -"; };
    "ft:cpp" = {"formatter" = "clang-format";};

  });

  # Define keybindings

  microBindings = pkgs.writeText "bindings.json" (builtins.toJSON {

    "Ctrl-p" = "CommandMode";

    "Ctrl-P" = "CommandMode";

    # File Tree

    "Ctrl-b" = "command:filetree";

    # --- NEW: Switch Between Open Files (Tabs) ---

    "Alt-Left" = "PreviousTab";

    "Alt-Right" = "NextTab";
    "Ctrl-PageUp" = "PreviousTab"; # Common Linux/VS Code bind
    "Ctrl-PageDown" = "NextTab"; # Common Linux/VS Code bind
    # "Alt-f" = "command:fmt";

    # Editor Actions
    "Ctrl-/" = "lua:comment.comment";
    "Alt-Up" = "MoveLinesUp";
    "Alt-Down" = "MoveLinesDown";
    "Ctrl-Shift-k" = "DeleteLine";
    "Ctrl-d" = "DuplicateLine";
    "Ctrl-s" = "Save";
    "Ctrl-q" = "Quit";

    # opening terminal
    "F12" = "HSplit,command:term";
    "F11" = "VSplit,command:term";

    # refreshing markdown view:
    "F6" = "command:preview";

  });



in {

  environment.systemPackages = [

    # There add wanted plugins

    (pkgs.writeShellScriptBin "micro-install" ''
    echo "Micro is checking plugins"
    mkdir -p $HOME/.config/micro/plug
    rm -rf $HOME/.config/micro/plug/autofmt

      # 1. Formatter
      # if [ ! -d "$HOME/.config/micro/plug/autofmt" ]; then
          # echo "Cloning autofmt..."
          # ${pkgs.git}/bin/git clone https://github.com/a11ce/micro-autofmt.git $HOME/.config/micro/plug/autofmt
      # else
          # echo " - autofmt already installed."
      # fi

      # 2. My filetree
      if [ ! -d "$HOME/.config/micro/plug/filetree" ]; then
          echo "Cloning fileTree-micro..."
          # Cloning directly into a folder named 'filetree'
          ${pkgs.git}/bin/git clone https://github.com/123pik1/fileTree-micro.git $HOME/.config/micro/plug/filetree
      else
          echo " - filetree already installed."
      fi

      # 3. Markdown preview
      if [ ! -d "$HOME/.config/micro/plug/preview" ]; then
        echo "Cloning markdown preview"
        ${pkgs.git}/bin/git clone https://github.com/weebi/micro-preview.git $HOME/.config/micro/plug/preview

      else
                  echo " - markdown preview already installed."
      fi

      # 4. jump to function plugin
    if [ ! -d "$HOME/.config/micro/plug/jump" ]; then
        echo "Cloning jump plugin"
        ${pkgs.git}/bin/git clone https://github.com/terokarvinen/micro-jump.git $HOME/.config/micro/plug/jump

    else
        echo "- jump plugin already installed"
    fi


      exec ${pkgs.micro}/bin/micro -plugin install snippets lsp


    '')

    (pkgs.writeShellScriptBin "micro" ''


      # 1. Ensure config directory exists


      mkdir -p $HOME/.config/micro/plug



      # 2. Force-update settings and bindings every time you run micro


      # This keeps your config declarative!


      cat ${microSettings} > $HOME/.config/micro/settings.json


      cat ${microBindings} > $HOME/.config/micro/bindings.json


      # 3. Ensure permissions are correct so you can install plugins manually


      chmod 755 $HOME/.config/micro


      chmod 755 $HOME/.config/micro/plug


      # 4. Run Micro


      exec ${pkgs.micro}/bin/micro "$@"


    '')

  ];

}
