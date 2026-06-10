{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };

  # services.desktopManager.plasma6.enable = true;


  # for auth in file manager to mount disks
  security.polkit.enable = true;

  # Packages needed when using hyprland not necessarily when using other window manager
  environment.systemPackages = with pkgs; [
    wl-clipboard

    ghostty

    kdePackages.qtstyleplugin-kvantum

    # for auth in file manager to mount disks
    polkit_gnome

    # for resume/pause track
    playerctl

    #
    wofi
    # bar above
    waybar
    # notification
    mako
    libnotify
    # wallpaper
    awww
    # menu for logout and shutdown
    hyprlock

    # dzwięk
    pavucontrol
    pamixer

    # automatic disk mounting
    udiskie

    # file-manager #
    kdePackages.dolphin

    # wifi
    iwgtk
    networkmanager

    pipewire
    wireplumber
    eww
    rofimoji
    # wlogout
    # quickshell - moze kiedys

    # screenshot:
    grim # screenshot tool
    slurp # selection tool
    swappy

    # screen brightness:
    brightnessctl

    # for themes
    kdePackages.qt6ct

    (writeShellScriptBin "fancy-hyprland" ''
              hyprctl --batch "\
                  keyword animations:enabled 1;\
                  keyword decoration:drop_shadow 1;\
                  keyword decoration:blur:enabled 1;\
                  keyword general:gaps_in 5;\
                  keyword general:gaps_out 10;\
                  keyword decoration:rounding 10"


    '')

    (writeShellScriptBin "toggle-hyprland-fancy_battery" ''
      HYPR_ANIM=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

          if [ "$HYPR_ANIM" = "1" ]; then
              # TURN OFF FANCY STUFF (Battery/Fast Mode)
              hyprctl --batch "\
                  keyword animations:enabled 0;\
                  keyword decoration:drop_shadow 0;\
                  keyword decoration:blur:enabled 0;\
                  keyword general:gaps_in 0;\
                  keyword general:gaps_out 0;\
                  keyword decoration:rounding 0"

              notify-send "Hyprland" " Fast Mode Enabled"
          else
              # TURN ON FANCY STUFF (Fancy Mode)
              hyprctl --batch "\
                  keyword animations:enabled 1;\
                  keyword decoration:drop_shadow 1;\
                  keyword decoration:blur:enabled 1;\
                  keyword general:gaps_in 5;\
                  keyword general:gaps_out 10;\
                  keyword decoration:rounding 10"

              notify-send "Hyprland" " Fancy Mode Enabled"
          fi
    '')

    (writeShellScriptBin "screenshot-menu" ''
      # Options
      dir="$HOME/Pictures/Screenshots"
      mkdir -p "$dir"
      file="$dir/$(date + '%Y-%m-%d_%H-%M-%S').png"

      option0="Full Screen"
      option1="Area"
      option2="Area with edit"

      # show menu
      selected=$(echo -e "$option0\n$option1\n$option3" | wofi --dmenu --prompt "Screenshot Mode" --lines 3 --width 250)

      if [[ "$selected" == *"Full"* ]]; then
          grim "$file"
          wl-copy < "$file"
          notify-send "Screenshot" "Full screen copied"

      elif [[ "$selected" == *"Area with edit"* ]]; then
          grim -g "$(slurp)" - | swappy -f -

      elif [[ "$selected" == *"Area"* ]]; then
          grim -g "$(slurp)" "$file"
          wl-copy < "$file"
          notify-send "Screenshot" "Area copied"
      fi
    '')

    (writeShellScriptBin "screenshot-area" ''
          dir="$HOME/Pictures/Screenshots"
      mkdir -p "$dir"

      file="$dir/$(date +'%Y-%m-%d_%H-%M-%S').png"

          grim -g "$(slurp)" "$file"
          wl-copy < "$file"
          notify-send "Screenshot" "Area copied"


    '')

  ];

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
            action.id == "org.freedesktop.udisks2.filesystem-mount") &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
  '';
}
