{pkgs, ...}:
{
programs.zsh = {
        enable = true;

        autosuggestions.enable = true;

        syntaxHighlighting.enable= true;
        interactiveShellInit = let
            flakeDir = toString ./..;
        in ''
            # autocd
            setopt autocd

            # aliases
            alias ll="ls -lah"
            alias cl="clear"
            alias commit="git commit -m"
            alias rust-dev="nix develop ${flakeDir}#rust -c zsh"
            alias nids-dev="nix develop ${flakeDir}#nids -c zsh"
            alias tauri-dev="nix develop ${flakeDir}#tauri -c zsh"
            alias tex-dev="nix develop ${flakeDir}#latex -c zsh"
            alias java-dev="nix develop ${flakeDir}#java -c zsh"
            alias cpp-dev="nix develop ${flakeDir}#cpp -c zsh"
            alias tex-dev="nix develop ${flakeDir}#latex -c zsh"
            alias latex-dev="tex-dev"
            alias e="exit"
            alias drag="ripdrag"
        '';
    };

programs.starship = {
        enable = true;


    settings = {
        add_newline = false;

        gcloud.disabled = true;

        character = {
            success_symbol = "[➜](bold green) ";
            error_symbol = "[➜](bold red) ";
        };



        directory = {
            style = "bold cyan";
            truncate_to_repo = true;
        };
    };
    };



}
