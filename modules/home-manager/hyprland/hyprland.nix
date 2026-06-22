{ pkgs, ... }:
{
  imports = [
    ./waybar.nix
    ./viewConf.nix
    ./file-explorer.nix
    #   ./hyprpaper.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    configType = "hyprlang";


    plugins = [
    ];

    settings = {
      env = [
        "QT_QPA_PLATFORMTHEME,qt6ct"
        #      "QT_STYLE_OVERRIDE,kvantum"

"XCURSOR_THEME,breeze_cursors" 
        "XCURSOR_SIZE,24"
      ];

      #Monitor
      monitor = ",prefered,auto,1";

      #Variables
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$menu" = "wofi --show drun --allow-images";

      # startup programs
      exec-once = [
        "waybar &"
        "mako &"
        # wallpaper
        "awww-daemon"
        "random-wallpaper"
        # disk mounting
        "udiskie &"

        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "sleep 2 && ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 &"
        "fancy-hyprland"
 #       "toggle-hyprland-fancy_battery"
"hyprctl setcursor breeze_cursors 24"

"blueman-applet &"

      ];

      input = {
        kb_layout = "pl";

        # natural_scroll = false;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      # look
      general = {
        gaps_in = 5;
        gaps_out = 0;
        allow_tearing = true;
      };

      /*
        windowrule = [
          "immediate, ^(cs2)$"

          "stayfocused, class:^(steam)$"
        ];
      */
      # bindings
      bind = [
        "$mod, T, exec, $terminal"
        "ALT, F4, killactive"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, Space, exec, $menu"
        "$mod, E, exec, rofimoji --action copy"
        "$mod, F1, exec, firefox"
        "$mod, L, exec,  hyprlock"

        # move to workspace
        "CTRL SHIFT, period, movetoworkspace, +1"
        "CTRL SHIFT, comma, movetoworkspace, -1"

        # Control of tracks/music/videos (sound)
        "ALT, P, exec, playerctl play-pause"
        "ALT, RIGHT, exec, playerctl next"
        "ALT, LEFT, exec, playerctl previous"

        # Toggle battery view
        #"$mod, F9,exec, toggle-hyprland-fancy_battery"

        # PrintScreen
        ", Print, exec, screenshot-area"

        "$mod, left, focusmonitor, l"
        "$mod, right, focusmonitor, r"

        "$mod, 1,focusworkspaceoncurrentmonitor, 1"
        "$mod, 2,  focusworkspaceoncurrentmonitor, 2"
        "$mod, 3, focusworkspaceoncurrentmonitor, 3"
        "$mod, 4, focusworkspaceoncurrentmonitor, 4"
        "$mod, 5, focusworkspaceoncurrentmonitor, 5"
        "$mod, 6,focusworkspaceoncurrentmonitor, 6"
        "$mod, 7, focusworkspaceoncurrentmonitor, 7"
        "$mod, 8, focusworkspaceoncurrentmonitor, 8"
        "$mod, 9,focusworkspaceoncurrentmonitor, 9"
        "$mod, 0, focusworkspaceoncurrentmonitor, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod, Tab,exec, hyprctl dispatch overview:toggle"

        "$mod, V, toggleFloating"
      ];

      # mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        # volume up
        ",XF86AudioRaiseVolume, exec, pamixer -i 5"

        # volume down
        ",XF86AudioLowerVolume, exec, pamixer -d 5"

        # Mute
        ",XF86AudioMute, exec, pamixer -t"

        # Increase brightness
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"

        # decrease brightness
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        # change workspace:
        "CTRL, period,focusworkspaceoncurrentmonitor, +1"
        "CTRL, comma,focusworkspaceoncurrentmonitor, -1"

      ];

      bindr = [
        "$mod, SUPER_L, exec, nwg-drawer"
      ];

      plugin = {
        overview = {
          panelHeight = 150;
          exitOnSwitch = true;
        };
      };

    };
  };
  # Config for screenshots:
  xdg.configFile = {

    "swappy/config".text = ''
      [Default]
      save_dir=$HOME/Pictures/Screenshots
      save_filename_format=screensht-%d%m%Y-%H%M%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=sans-serif
    '';

    # swayimg
    "swayimg/config".text = ''
      [keys.viewer]
      c = next_file
      x = prev_file
    '';

    "ghostty/config".text = ''
        # --- Czcionka (Font) ---
        font-family = "JetBrainsMono Nerd Font"
        font-size = 11
        font-style = Medium

        # --- Kolorystyka i Motyw (Theme) ---
        # Możesz wybrać m.in.: catppuccin-mocha, tokyonight, rose-pine, gruvbox-dark
        # theme = catppuccin-mocha

        # --- Okno i Przezroczystość (Window Layout) ---
        background-opacity = 0.85
        background-blur = true
    
        # Usuwa pasek tytułowy (czysty, minimalistyczny wygląd)
        window-decoration = false
    
        # Marginesy wewnątrz terminala (tekst nie dotyka krawędzi)
        window-padding-x = 12
        window-padding-y = 12

        # --- Kursor ---
        cursor-style = block

    '';
  };

  # wifi
  home.file.".local/bin/wifi-menu".text = ''
    #!/usr/bin/env  bash

    # Pobranie listy dostępnych sieci wifi:
    # Format: IN-USE,SSID,SECURITY
    wifi_list=$(nmcli --terse --fields "IN-USE,SSID,SECURITY" device wifi list | sed 's/^--//' | sed 's/^\*:/󰖩 /')


    # wybranie linii:
    chosen_line=$(echo "$wifi_list" | wofi --dmenu --prompt "Wifi Networks" --width 400 --height 300)

    [ -z "$chosen_line" ] && exit

    ssid=$(echo "$chosen_line" | cut -d':' -f2)

    if nmcli connection show "$ssid" > dev/null 2>&1; then
        notify-send -a "Network" "Connecting to known network: $ssid"
        nmcli connection up "$ssid"
    else
        pass=$(wofi --dmenu --prompt "Enter password" --password --width 400 --height 30)

        [ -z "$pass" ] && exit

        notify-send -a "Network" "Trying to connect to: $ssid"

        if nmcli device wifi connect "$ssid" password "$pass"; then
            notify-send -a "Network" "Connected successfully"
        else
            notify-send -a "Network" "Connection refused to: $ssid. Check password"
        fi

    fi


  '';

  home.file.".local/bin/wifi-menu".executable = true;

}
