# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, lib
, config
, pkgs
, outputs
, ...
}:
with outputs; {
  imports = [
    # Use modules from other flakes (such as nixos-hardware):
    inputs.sddm-sugar-candy-nix.nixosModules.default

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import home manager
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-19.1.9"
        "electron-25.9.0"
      ];
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest available kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" "btrfs" "exfat" ];

  # Make NixOS manage power and use upower deamon
  powerManagement.enable = true;
  services.upower.enable = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "https://10.8.6.50:3128/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,*cujae.edu.cu";
  # networking.nftables.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";

    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.sddm = {
    enable = true;
    sugarCandyNix.enable = true;
  };

  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # programs = {
  #   dconf.enable = true;
  #   direnv.enable = true;
  # };

  # Configure keymaps
  services.xserver.xkb = {
    layout = "us-custom";
    variant = "";
    options = "shift:both_capslock";
  };

  services.xserver.xkb.extraLayouts.us-custom = {
    description = "US layout custom symbols";
    languages = [ "eng" ];
    symbolsFile = /home/enier/xkb_custom_layout/symbols/us-custom;
  };
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable polkit
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Enable bluetooth and power up controller on boot
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.enier = {
    isNormalUser = true;
    description = "${name}";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "input" "libvirtd" "socksified" ];
    initialPassword = "theLinuxMan";
    packages = with pkgs; [
      microsoft-edge
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    roboto
    (nerdfonts.override { fonts = [ "FiraCode" "Hasklig" "RobotoMono" ]; })
  ];

  # Don't require password for members of "wheel" to use sudo
  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    audacity
    bat
    bottles
    floorp
    gimp
    libsForQt5.kalk
    pandoc
    thunderbird
    zotero
    baobab
    btop
    calibre
    coreutils-full
    dbus
    distrobox
    docker
    docker-compose
    entr
    eza
    fd
    file
    gh
    git-crypt
    gnumake
    gnutar
    gparted
    home-manager
    jq
    kitty
    lazygit
    lf
    libgcc
    libreoffice
    libinput-gestures
    libnotify
    neofetch
    # nodejs_21
    obsidian
    onlyoffice-bin
    poppler
    pulseaudio
    pv
    rar
    spice
    spice-gtk
    spice-protocol
    telegram-desktop
    tldr
    tmux
    tor
    tor-browser
    tree
    udisks
    unar
    unrar
    unzip
    usbutils
    vim
    vlc
    # virtio-win
    virt-viewer
    wget
    whatsapp-for-linux
    # win-spice
    wl-clipboard
    wofi
    yazi
    zip
  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      xfconf
      thunar-volman
    ];
  };

  programs.proxychains = {
    enable = true;
    package = pkgs.proxychains-ng;
    proxies = {
      default = {
        enable = true;
        type = "socks4";
        host = "127.0.0.1";
        port = 9050;
      };
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    # clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/enier/dotfiles/nix";
    package = inputs.nh.packages.x86_64-linux.default;
  };


  programs.npm = {
    enable = true;
    npmrc =
      ''
        timeout=10000000
        https-proxy=127.0.0.1:9050
      '';
  };


  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      enier = import ../home-manager/home.nix;
    };
  };

  environment = {
    sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      # Not officially in the specification
      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
      ];
    };
    variables = {
      EDITOR = "nvim";
      XCURSOR_THEME = "Numix-Cursor";
      XCURSOR_SIZE = "12";
    };
    localBinInPath = true;
  };
  # programs.nix-ld.enable = true;


  # Enable flatpak
  services.flatpak.enable = true;

  # Enable autocpufreq for better battery life
  services.auto-cpufreq.enable = true;

  programs.zsh = {
    # General zsh config
    enable = true;
    enableCompletion = true;
    setOptions = [ "PROMPT_SUBST" "appendhistory" ];
    autosuggestions = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";
    syntaxHighlighting.enable = true;
  };
  programs.starship.enable = true;

  # Enable libvirtd(qemu) and docker virtualization
  services.spice-vdagentd.enable = true;
  virtualisation = {
    docker.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  programs.virt-manager.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
