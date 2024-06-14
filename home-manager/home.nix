# This is your home-manager configuration file
{ inputs
, lib
, config
, pkgs
, name
, username
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    inputs.xremap-flake.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./ags.nix
    ./mpd.nix
    ./shell.nix
    ./hyprland-rice
    ./git.nix
    ./tmux.nix
    ./neofetch.nix
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
    "electron-25"
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.mpv.enable = true;
  programs.git.enable = true;

  programs.vscode.enable = true;
  programs.neovim = {
    enable = true;
    withPython3 = true;
    withRuby = true;
    withNodeJs = true;
    extraPackages = with pkgs; [
      fzf
      libclang
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.ripgrep.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  services.xremap = {
    withHypr = true;
    # withWlroots = true;
    config = {
      keymap = [
        {
          name = "main remaps";
          remap = {
            super-y = {
              launch = "kitty";
            };
          };
        }
      ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
