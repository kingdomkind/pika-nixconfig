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

  # Enabling programs
  programs.home-manager.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    # extraConfig = {};
  };

  xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink /home/pika/Software/pika-nixconfig/hyprland.conf;
  xdg.configFile."waybar/config".source = config.lib.file.mkOutOfStoreSymlink /home/pika/Software/pika-nixconfig/config;
  xdg.configFile."waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink /home/pika/Software/pika-nixconfig/style.css;
  xdg.configFile."wal/templates/dunstrc".source = config.lib.file.mkOutOfStoreSymlink /home/pika/Software/pika-nixconfig/dunstrc;

  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
  };

  qt.enable = true;
  qt.platformTheme.name = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  home.file = {
    "/home/pika/.config/hypr/hyprpaper.conf" = {
      text = ''
        splash = false
      '';
    };

    "/home/pika/.config/kitty/kitty.conf" = {
      text = ''
        background_opacity 0.9
        dynamic_background_opacity yes
        include /home/pika/.cache/wal/colors-kitty.conf
        confirm_os_window_close 0
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
}
