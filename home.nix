{config, pkgs, rose-pine-hyprcursor, ... }:

{
  home.username = "pika";
  home.homeDirectory = "/home/pika";

  # avoids breaking changes
  home.stateVersion = "23.11";

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    rose-pine-hyprcursor.packages.x86_64-linux.default
  ];

  # Home Manager can also manage your environment variables like below
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  #xdg.mimeApps = {
  #  enable = true;
  #
  #  defaultApplications = {
  #
  #  };
  #};

  # Enabling programs
  programs.home-manager.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    # extraConfig = {};
  };

  xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink /home/pika/Software/pika-nixconfig/hyprland.conf;

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.libsForQt5.breeze-gtk;
    };
  };


  home.file = {
    "/home/pika/.config/kitty/kitty.conf" = {
      text = ''
        background_opacity 0.9
        dynamic_background_opacity yes
        include /home/pika/.cache/wal/colors-kitty.conf
      '';
    };

    "/home/pika/.config/electron22-flags.conf" = {
      text = ''
        --enable-features=UseOzonePlatform
        --ozone-platform=wayland
      '';
    };

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

        font = "jetbrains mono 10"
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
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      build-config = "sudo /home/pika/Software/pika-nixconfig/scripts/build/build-config.sh";
      edit = "cd /home/pika/Software/pika-nixconfig";
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

        "tray" = {
          icon-size = 17;
          spacing = 10;
        };

        "network" = {
          "format-wifi" = "  {signalStrength}%";
          "format-ethernet" = " ";
          "format-disconnected" = "Disconnected";
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

       "clock" = {
          "interval" = 1;
          "format" = "{:%H:%M:%S %a}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "hyprland/window" = {
          format = "{class}";
        };

        "custom/system" = {
          format = "{}";
          exec = "/home/pika/Software/pika-nixconfig/scripts/stats/system.sh";
          restart-interval = 1;
        };

        "custom/nvidia" = {
          format = "{}";
          exec = "/home/pika/Software/pika-nixconfig/scripts/stats/nvidia.sh";
          restart-interval = 1;
        };

        modules-left = ["hyprland/workspaces" "hyprland/window" ];
        modules-right = ["tray" "custom/system" "custom/nvidia" "network" "clock"];
      };
    };

    style = ''
      @import "/home/pika/.cache/wal/colors-waybar.css";      

      * {
        font-family: JetBrainsMono Nerd Font;
        border-radius: 20px;
        color: #ffffff;
      }

      window#waybar {
        background-color: transparent;
        color: #ffffff;
      }

      #tray,
      #network,
      #window,
      #workspaces,
      #custom-system,
      #custom-nvidia,
      #clock {
        background-color: @background;
        margin-left: 5px;
        margin-right: 5px;
        border: 2px solid @color11;
        padding: 0px 15px;
        color: #ffffff;
      }

      #workspaces button:hover {
        background: @color11;
        border: 0px;
      }
    '';
  };
}
