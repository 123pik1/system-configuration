{ pkgs, ... }:
{

home.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  font-awesome
];

programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "hyprlock"; # Make sure you have hyprlock (or swaylock) installed
        text = "Lock";
        keybind = "l";
    }
              {
                label = "hibernate";
                action = "systemctl hibernate";
                text = "Hibernate";
                keybind = "h";
              }
              {
                label = "logout";
                action = "hyprctl dispatch exit"; # The specific command to kill Hyprland
                text = "Logout";
                keybind = "e";
              }
              {
                label = "shutdown";
                action = "systemctl poweroff";
                text = "Shutdown";
                keybind = "s";
              }
              {
                label = "suspend";
                action = "systemctl suspend";
                text = "Suspend";
                keybind = "u";
              }
              {
                label = "reboot";
                action = "systemctl reboot";
                text = "Reboot";
                keybind = "r";
              }
    ];
};



 programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "bottom"; # or top?
        position = "top";
        height = 30;
        spacing = 4;

        # Where modules go
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "custom/gamemode" "pulseaudio" "network" "cpu" "memory" "battery" "tray" "custom/power" ];

        # Module Configurations
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "clock" = {
          format = "{:%H:%M}  ";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
          # on-click-right: calendar
        };

        "cpu" = {
          format = "{usage}% ";
          tooltip = true;
          on-click = "btop++";
        };

        "memory" = {
          format = "{}% ";
          on-click = "btop";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click-right = "~/.local/bin/wifi-menu";
        };


# Actions for bluetooth - connect, send file, etc.
        "bluetooth" = {

        };

        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        # Your custom Nvidia Button
        # "custom/gamemode" = {
        #   format = "🎮";
        #   tooltip = "Switch to Gaming Mode";
        #   on-click = "switch-to-gaming"; # Requires the script we made earlier
        # };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout --protocol layer-shell";
        };

      };
    };

    # 2. The Style (CSS)
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: white;
      }

      /* The floating pill effect */
      #workspaces {
        background: #1e1e2e;
        margin: 5px;
        padding: 0 5px;
        border-radius: 16px;
        border: 1px solid #181825;
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: white;
      }

      #workspaces button.active {
        color: #89b4fa;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #custom-gamemode {
        padding: 0 10px;
        background: #1e1e2e;
        color: white;
        margin: 5px 2px;
        border-radius: 16px;
        border: 1px solid #181825;
      }

      #clock {
        color: #fab387;
      }

      #battery.charging, #battery.plugged {
        color: #a6e3a1;
      }

      #battery.critical:not(.charging) {
        background-color: #f38ba8;
        color: #bf5656;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #custom-power {
                margin-right: 10px;
              }

      label:focus {
        background-color: #000000;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }
    '';
  };
}

