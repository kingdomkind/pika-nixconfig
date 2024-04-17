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
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking + Bootloader
  networking.hostName = "pika-nix";
  networking.networkmanager.enable = true;
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
        # enable IOMMU
        "amd_iommu=on"
        "vfio-pci.ids=10de:13c0,10de:0fbb"
      ];
    };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 pika kvm -"
  ];

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile
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
      kate
      hyprland
      libsForQt5.koko
      prismlauncher
      rustup
      vscodium-fhs
      betterbird
      whatsapp-for-linux
      lua
      wireguard-tools
      opentabletdriver
      qbittorrent

      # FOR PROPER SYSTEM FUNCTION
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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    wireplumber.enable = true;
  };

  fonts.packages = with pkgs-unstable; [
    nerdfonts
  ];

   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:
   services.openssh.enable = true;
   programs.hyprland.enable = true;
   programs.steam.enable = true;
   #programs.hyprland = {enable = true;};

   services.flatpak.enable = true;
   services.flatpak.uninstallUnmanaged = true;
   services.flatpak.packages = ["dev.vencord.Vesktop" "com.github.xournalpp.xournalpp"];
   services.devmon.enable = true;
   services.gvfs.enable = true; 
   services.udisks2.enable = true;

   # Default system version -- recommended to leave alone
   system.stateVersion = "23.11";
}

