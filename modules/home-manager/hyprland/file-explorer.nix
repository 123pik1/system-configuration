{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      # Zamiast 'yazi' używamy aktualnej sekcji 'manager'
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
        ratio = [ 1 4 3 ]; # Zapożyczone z Twojego przykładu z Wiki
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };
    keymap = {
        manager.prepend_keymap = [
            {
            on = ["<C-k>"];
            run = "ripdrag \"$@\"";
            desc = "Drag and drop";
            }
        ];
    };
    };

}
