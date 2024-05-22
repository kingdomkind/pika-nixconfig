{ config, pkgs-unstable, pkgs-stable, lib, home-manager, nix-flatpak, rose-pine-hyprcursor, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];  
  
  # NVIDIA driver settings
  hardware.opengl = { enable = true; driSupport = true; driSupport32Bit = true; };  
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;

    # package = config.boot.kernelPackages.nvidiaPackages.beta;

package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  version = "555.42.02";
  sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
  openSha256 = "sha256-3/eI1VsBzuZ3Y6RZmt3Q5HrzI2saPTqUNs6zPh5zy6w=";
  settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
  persistencedSha256 = "";
};
  };
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # kernel
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [
    "v4l2loopback"
  ];
  # boot.kernelPackages = pkgs-stable.linuxPackages_latest;

  # Networking + Bootloader
  networking.hostName = "pika-nix";
  networking.networkmanager.enable = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Localisation Properties
  time.timeZone = "Europe/London";
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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Systemd Services
  systemd.services.VPNService = {
    description = "Runs VPN on boot";
    wantedBy = ["multi-user.target"];
    path = [pkgs-unstable.wireguard-tools pkgs-unstable.coreutils pkgs-unstable.openresolv];
    after = [ "multi-user.target" ];
    script = ''/home/pika/Software/pika-nixconfig/scripts/VPN/vpn_handler up'';
    serviceConfig = {
      User = "root";
      Group = "root";
    };
  };


  systemd.services.StartDefaultNetworkService = {
    description = "Starts default VM network on boot";
    wantedBy = ["multi-user.target"];
    path = [pkgs-unstable.libvirt];
    script = ''virsh net-list | grep -q "default" && echo "default network already started" || virsh net-start default'';
    serviceConfig = {
      User = "root";
      Group = "root";
    };
  };

  # Virtualisation Settings
  programs.dconf.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs-unstable.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;

  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    kernelParams = [
      "amd_iommu=on"
      "vfio-pci.ids=10de:13c0,10de:0fbb"
    ];
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 pika kvm -"
  ];

  # Home manager setup
  users.users.pika = {
    isNormalUser = true;
    description = "pika";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm"];
    packages = with pkgs-unstable; [];
  };

  home-manager = {
    extraSpecialArgs = { inherit rose-pine-hyprcursor; };
    users = {
      "pika" = import ./home.nix;
    };
  };

  # NixOS settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Install Packages
  environment.systemPackages = 

    # UNSTABLE PACKAGES
    (with pkgs-unstable; [
      # GENERAL APPs
      killall
      swww
      neofetch
      dunst
      slurp
      grim
      btop
      obs-studio
      rofi-wayland
      rofi-power-menu
      gnome.nautilus
      vlc
      vim
      nvitop
      librewolf
      teams-for-linux
      ventoy-full
      gparted
      git
      hyprland
      libsForQt5.koko
      prismlauncher
      rustup
      vscodium-fhs
      betterbird
      lua
      wireguard-tools
      qbittorrent-qt5
      libreoffice
      kitty
      (ollama.override { acceleration = "cuda"; })
      vesktop
      waybar
      android-tools
      signal-desktop
      hyprpaper
      freetube
      satty
      cura
      prusa-slicer

      # DEPENDENCIES
      xdg-utils
      wl-clipboard

      # REQUIRED FOR VMs
      virt-manager
      spice spice-gtk
      spice-protocol
      win-virtio
      win-spice
      gnome.adwaita-icon-theme
      virtiofsd
    ]) ++

    # STABLE PACKAGES
    (with pkgs-stable; [
      looking-glass-client
  ]);

  services.flatpak.packages = [
    "com.github.xournalpp.xournalpp"
    "com.rtosta.zapzap"
  ];

  # Audio (pipewire) settings
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  fonts.packages = with pkgs-unstable; [
    nerdfonts
  ];

   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # Enabling programs & services
   programs.hyprland.enable = true;
   programs.steam.enable = true;

   services.openssh.enable = true;
   services.flatpak.enable = true;
   services.flatpak.uninstallUnmanaged = true;
   services.devmon.enable = true;
   services.gvfs.enable = true; 
   services.udisks2.enable = true;

   hardware.opentabletdriver.enable = true;
   hardware.opentabletdriver.daemon.enable = true;

   # Default system version -- recommended to leave alone
   system.stateVersion = "23.11";
}

