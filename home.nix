{ config, pkgs, rose-pine-hyprcursor, ... }:

{
  home.username = "pika";
  home.homeDirectory = "/home/pika";

  # avoids breaking changes
  home.stateVersion = "23.11";

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    rose-pine-hyprcursor.packages.x86_64-linux.default
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  # Home Manager can also manage your environment variables like below
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  #services.flatpak.uninstalledUnmanaged = true;
  #services.flatpak.packages = ["dev.vencord.Vesktop"];

  programs.kitty = {
    enable = true;

    settings = {
      include = "/home/pika/.cache/wal/colors-kitty.conf";
    };
  };

  systemd.user.services = {
    #path = [pkgs.bash];
    change-wallpaper = {
      Unit = { Description = "Changes the Hyprland wallpaper randomly"; };
      Install.WantedBy = ["multi-user.target"];
      Service = {
        Type = "oneshot";
        ExecStart = "/etc/nixos/scripts/wallpaper/change-wallpaper.sh";
        #User = "pika";
      };
    };
  };

  systemd.user.timers = {
    change-wallpaper = {
      Unit = { Description = "Triggers a wallpaper change at every X minutes"; };
      Install.WantedBy = ["timers.target"];
      Timer = {
        OnUnitActiveSec = "1m";
        Unit = "change-wallpaper.service";
      };
    };
  };

  # Enabling programs
  programs.home-manager.enable = true;
  wayland.windowManager.hyprland.enable = true;

  home.file = {
    "/home/pika/.config/rofi/config.rasi" = {
       text = ''
        @import "/home/pika/.cache/wal/colors-rofi-dark"
      '';
    };

    "/home/pika/.config/wal/templates/colors-hyprland.conf" = {
      text = ''
        $background = rgb({background.strip})
        $foreground = rgb({foreground.strip})
        $color0 = rgb({color0.strip})
        $color1 = rgb({color1.strip})
        $color2 = rgb({color2.strip})
        $color3 = rgb({color3.strip})
        $color4 = rgb({color4.strip})
        $color5 = rgb({color5.strip})
        $color6 = rgb({color6.strip})
        $color7 = rgb({color7.strip})
        $color8 = rgb({color8.strip})
        $color9 = rgb({color9.strip})
        $color10 = rgb({color10.strip})
        $color11 = rgb({color11.strip})
        $color12 = rgb({color12.strip})
        $color13 = rgb({color13.strip})
        $color14 = rgb({color14.strip})
        $color15 = rgb({color15.strip})
      '';
    };

    "/home/pika/.config/wal/templates/dunstrc" = {
      text = ''
        [global]
        # Which monitor should the notifications be displayed on.
        monitor = 0
        follow = none

        width = 300
        height = (0,300)

        origin = top-right
        offset = 15x30
        scale = 0
        notification_limit = 20
        timeout = 3

        progress_bar = true
        progress_bar_height = 10
        progress_bar_frame_width = 1
        progress_bar_min_width = 150
        progress_bar_max_width = 300
        progress_bar_corner_radius = 10
        icon_corner_radius = 5
        corner_radius = 10

        # Show how many messages are currently hidden (because of
        # notification_limit).
        indicate_hidden = yes
        separator_height = 2

        # Padding between text and separator.
        padding = 8
        horizontal_padding = 8
        text_icon_padding = 0
        frame_width = 1
        frame_color = "{color11}"
        background = "{color1}"
        #foreground = "{color1}"

        gap_size = 0
        separator_color = frame

      '';
    };

    "/home/pika/.local/share/applications/dev.vencord.Vesktop.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Vesktop
        Exec=flatpak run --branch=stable --arch=x86_64 --command=startvesktop dev.vencord.Vesktop
        Terminal=false
        Type=Application
        Icon=/home/pika/Icon1.png
        StartupWMClass=Vesktop
        X-AppImage-Version=1.5.1
        GenericName=Internet Messenger
        Categories=Network;
        Keywords=discord;vencord;electron;chat;
        X-Desktop-File-Install-Version=0.27
        X-Flatpak=dev.vencord.Vesktop
      '';
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      build-config = "sudo /etc/nixos/scripts/build/build-config.sh";
    };
  };

  programs.pywal = {
    enable = true;
  };

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        height = 20;
        margin-top = 10;
        margin-right = 10;
        margin-left = 10;
        margin-bottom = 0;
       
        "custom/exit" = {
           format = "   ";
           tooltip = false;
           on-click = "hyprctl dispatch exit";
        };
 
        "cpu" = {
          interval = 1;
          format = "| C {usage}% ";
        };

        "memory" = {
          interval = 1;
          format = "| M {}% | ";
        };

        "tray" = {
          icon-size = 21;
          spacing = 10;
        };

        "group/hardware" = {
          orientation = "horizontal";
          # modules = ["disk" "cpu" "memory"];
        };

        "network" = {
          "format" = "{ifname}";
          "format-wifi" = "  {signalStrength}%";
          "format-ethernet" = "  ↑ {bandwidthUpBytes}  ↓ {bandwidthDownBytes}";
          "format-disconnected" = "Disconnected";
          "tooltip-format" = "  {ifname} via {gwaddri}";
          "tooltip-format-wifi" = "  {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\nUp: {bandwidthUpBits} Down: {bandwidthDownBits}";
          "tooltip-format-ethernet" = "  {ifname}\nIP: {ipaddr}\n up: {bandwidthUpBits} down: {bandwidthDownBits}";
          "tooltip-format-disconnected" = "Disconnected";
          "max-length" = 50;
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          format = "{}";
          format-icons = { urgent = ""; active = ""; default = ""; };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "custom/appmenu" = {
          format = " Apps ";
          on-click = "rofi -show drun";
        };

       "clock" = {
          "format" = " {:%H:%M %a} ";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "wlr/taskbar" = {
          on-click = "activate";
          on-click-middle = "close";
        };

        "hyprland/window" = {
          #max-length = 20;
          format = "{class}";
        };

        modules-left = ["custom/exit" "hyprland/workspaces" "custom/appmenu" "hyprland/window"];
        modules-center = ["wlr/taskbar"];
        modules-right = ["tray" "cpu" "memory" "network" "clock"];
      };
    };

    style = ''
      @import "/home/pika/.cache/wal/colors-waybar.css";      

      * {
      font-family: JetBrainsMono Nerd Font;
      border-radius: 10px;
      }

      window#waybar {
        background-color: transparent;
        color: #ffffff;
      }

      #workspaces {
        background: @color11;
        margin: 5px 1px 6px 1px;
        padding: 0px 7px;
        border-radius: 15px;
        border: 0px;
        font-weight: bold;
        font-style: normal;
        opacity: 0.8;
        font-size: 16px;
      }

      #workspaces button:hover {
        background: @foreground;
        border-radius: 15px;
        opacity:0.7;
      }

      #taskbar {
        background-color: @background;
        opacity: 0.8;
        border: 3px solid @color11;
      }

      #taskbar button:hover {
        background: @foreground;
        opacity:0.7;
      }
    '';
  };

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$fileManager" = "nemo";
    "$menu" = "rofi -show drun";
    "$browser" = "brave";

    exec-once = ["swww-daemon" "waybar" "sleep 1 && /etc/nixos/scripts/wallpaper/change-wallpaper.sh"];

    "env" = ["XCURSOR_SIZE,24" "QT_QPA_PLATFORMTHEME,qt5ct" "HYPRCURSOR_THEME,rose-pine-hyprcursor"];

    monitor = ",preferred,auto,1,transform,2";
    source = "/home/pika/.cache/wal/colors-hyprland.conf";

    "$mainMod" = "SUPER";
    bind =
    [
      "$mainMod, B, exec, $browser"
      "$mainMod, Q, exec, $terminal"
      "$mainMod, C, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, V, togglefloating,"
      "$mainMod, R, exec, /etc/nixos/scripts/wallpaper/change-wallpaper.sh"
      "$mainMod, P, pseudo," # dwindle
      "$mainMod, J, togglesplit," # dwindle
      "$mainMod, SPACE, exec, $menu"
      "$mainMod, ESCAPE, exec, hyprctl dispatch exit"
      "$mainMod SHIFT, H, movewindow, l"
      "$mainMod SHIFT, L, movewindow, r"
      "$mainMod SHIFT, K, movewindow, u"
      "$mainMod SHIFT, J, movewindow, d"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      #"ALT, INSERT, exec, hyprshot -m region --clipboard-only"
      "ALT, INSERT, exec, grim -g \"$(slurp -d)\" - | wl-copy -t image/png"
    ];

    binde = [
      "$mainMod SHIFT, right, resizeactive, 10 0"
      "$mainMod SHIFT, left, resizeactive, -10 0"
      "$mainMod SHIFT, up, resizeactive, 0 -10"
      "$mainMod SHIFT, down, resizeactive, 0 10"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"

    ];

    misc = { force_default_wallpaper = 0; };
   
    dwindle = {
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = "yes"; # you probably want this
    };

    input = {
      kb_layout = "us";
      follow_mouse = 1;
    };

    decoration = {
    
      rounding = 10;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };

      active_opacity = 1;
      inactive_opacity = 0.9;
      fullscreen_opacity = 1;

      drop_shadow = "yes";
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
    };

    general = {

      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      # "col.inactive_border" = "rgba(595959aa)";
      "col.inactive_border" = "$color11";

      layout = "dwindle";
      allow_tearing = [false];
    };

    animations = {

      enabled = "yes";
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };
  };
}

