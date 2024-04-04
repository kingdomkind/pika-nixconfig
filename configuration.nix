{ config, pkgs, home-manager, nix-flatpak, rose-pine-hyprcursor, ... }:
# inputs use to be a param

{
  imports =
    [
      ./hardware-configuration.nix
      #home-manager.nixosModules.default
      #nix-flatpak.nixosModules.nix-flatpak
    ];  

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pika-nix";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.pika = {
    isNormalUser = true;
    description = "pika";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  #services.flatpak.enable = true;
  home-manager = {
    #extraSpecialArgs = { inherit inputs; };
    extraSpecialArgs = { inherit rose-pine-hyprcursor; };
    users = {
      "pika" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    killall
    swww
    neofetch
    brave
    dunst
    slurp
    grim
    wl-clipboard
    btop
    obs-studio
    rofi-wayland
    gnome.nautilus
    vlc
    vim
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    wireplumber.enable = true;
  };

  fonts.packages = with pkgs; [
    nerdfonts
  ];

   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:
   services.openssh.enable = true;
   hardware.opengl.enable = true; # Hyprland won't boot without
   programs.hyprland.enable = true;

   services.flatpak.enable = true;
   services.flatpak.uninstallUnmanaged = true;
   services.flatpak.packages = ["dev.vencord.Vesktop"];

   # Default system version -- recommended to leave alone
   system.stateVersion = "23.11";
}

