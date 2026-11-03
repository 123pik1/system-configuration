{ pkgs, inputs, ... }:
{
  imports = [
    ./waybar.nix
    ./viewConf.nix
    ./file-explorer.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    configType = "lua";

    plugins = [
    ];

    extraConfig = ''
      -- Variables
      local mod = "SUPER"
      local terminal = "ghostty"
      local menu = "wofi --show drun --allow-images"

      -- Environment Variables
      hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
      hl.env("XCURSOR_THEME", "breeze_cursors")
      hl.env("XCURSOR_SIZE", "24")

      -- Monitor
      hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = 1,
      })

      -- Settings
      hl.config({
        general = {
          gaps_in = 5,
          gaps_out = 0,
          allow_tearing = true,
        },
        input = {
          kb_layout = "pl",
          follow_mouse = 1,
          touchpad = {
            natural_scroll = true,
          },
        },
      })

      -- Startup programs
      hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")
        hl.exec_cmd("mako")
        hl.exec_cmd("awww-daemon")
        hl.exec_cmd("random-wallpaper")
        hl.exec_cmd("udiskie")
        hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("sleep 2 && ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1")
        hl.exec_cmd("fancy-hyprland")
        hl.exec_cmd("hyprctl setcursor breeze_cursors 24")
        hl.exec_cmd("blueman-applet")
      end)

      -- Key bindings
      hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal))
      hl.bind("ALT + F4", hl.dsp.window.close())
      hl.bind(mod .. " + C", hl.dsp.window.close())
      hl.bind(mod .. " + M", hl.dsp.exit())
      hl.bind(mod .. " + Space", hl.dsp.exec_cmd(menu))
      hl.bind(mod .. " + E", hl.dsp.exec_cmd("rofimoji --action copy"))
      hl.bind(mod .. " + F1", hl.dsp.exec_cmd("firefox"))
      hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))

      -- Move to workspace
      hl.bind("CTRL + SHIFT + period", hl.dsp.window.move({ workspace = "+1" }))
      hl.bind("CTRL + SHIFT + comma", hl.dsp.window.move({ workspace = "-1" }))

      -- Track/music/video control
      hl.bind("ALT + P", hl.dsp.exec_cmd("playerctl play-pause"))
      hl.bind("ALT + RIGHT", hl.dsp.exec_cmd("playerctl next"))
      hl.bind("ALT + LEFT", hl.dsp.exec_cmd("playerctl previous"))

      -- PrintScreen
      hl.bind("Print", hl.dsp.exec_cmd("screenshot-area"))

      -- Focus monitors
      hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))

      -- Workspaces 1-10
      for i = 1, 10 do
        local key = tostring(i % 10)
        local ws = tostring(i)
        hl.bind(mod .. " + " .. key, function()
          hl.dispatch(hl.dsp.focus({ workspace = ws, on_current_monitor = true }))
        end)
        hl.bind(mod .. " + SHIFT + " .. key, function()
          hl.dispatch(hl.dsp.window.move({ workspace = ws }))
        end)
      end

      -- Plugins & window management
      hl.bind(mod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch overview:toggle"))
      hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))

      -- Mouse bindings
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Volume and brightness controls (repeating & locked)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true, locked = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true, locked = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { repeating = true, locked = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true, locked = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true, locked = true })

      -- Change workspace
      hl.bind("CTRL + period", function()
        hl.dispatch(hl.dsp.focus({ workspace = "+1", on_current_monitor = true }))
      end, { repeating = true, locked = true })
      hl.bind("CTRL + comma", function()
        hl.dispatch(hl.dsp.focus({ workspace = "-1", on_current_monitor = true }))
      end, { repeating = true, locked = true })
    '';
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
