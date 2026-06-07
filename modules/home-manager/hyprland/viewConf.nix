{ ... }:
{
  #   # 1. Force GTK to use a Dark Theme
  #   gtk = {
  #     enable = true;
  #
  #     # Select a dark theme (e.g., Adwaita Dark, Catppuccin, Nord)
  #     theme = {
  #       name = "Adwaita-dark";
  #       package = pkgs.gnome-themes-extra;
  #     };
  #
  #     # Set the Icon theme (optional, but looks better)
  #     iconTheme = {
  #       name = "Papirus-Dark";
  #       package = pkgs.papirus-icon-theme;
  #     };
  #
  #     # Force dark preference for GTK 3 and 4
  #     gtk3.extraConfig = {
  #       Settings = ''
  #         gtk-application-prefer-dark-theme=1
  #       '';
  #     };
  #
  #     gtk4.extraConfig = {
  #       Settings = ''
  #         gtk-application-prefer-dark-theme=1
  #       '';
  #     };
  #   };
  #
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
