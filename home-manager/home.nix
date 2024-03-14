# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./mpd.nix
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
      # permittedInsecurePackages = [
      #   "electron-25.9.0"
      #   ];
    };
  };

  home = {
    username = "enier";
    homeDirectory = "/home/enier/";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
   ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
    "electron-25"
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Enable zsh and use it as default shell
  programs.zsh = {
    # My zsh config
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      off = "systemctl poweroff";
      p = "ping google.com";
      pc = "ping cubadebate.cu";

      conf = "cd ~/NixOS/ && nvim && cd -";
      update = "sudo nixos-rebuild switch --flake ~/NixOS/ -v";
      upgrade = "cd ~/NixOS && nix flake update && update && cd -";
      update-boot = "sudo nixos-rebuild boot --flake ~/NixOS/ -v";
      upgrade-boot = "cd ~/NixOS && nix flake update && update-boot && cd -";

      cleanup = "sudo nix-collect-garbage --delete-older-than 7d && sudo nix-store --optimise";
      full-cleanup = "sudo nix-collect-garbage -d && sudo nix-store --optimise";

      bat = "cat";
      ls = "eza --icons --group-directories-first";
      ll = "eza --icons --group-directories-first -l --git ";
      la = "eza --icons --group-directories-first -la --git ";
      l = "eza --icons --group-directories-first -lha --git ";
      grep = "grep --color=auto";
      ":q" = "exit";

      v = "nvim";
      sv = "distrobox-enter --root -n Arch -- sudo -e ./";
      vconf = "cd ~/.config/nvim/lua/custom && nvim && cd -";
      vconf-all = "cd ~/.config/nvim && nvim && cd -";

      ga = "git add";
      gs = "git status";
      gb = "git branch";
      gm = "git merge";
      gpl = "git pull";
      gplo = "git pull origin";
      gps = "git push";
      gpso = "git push origin";
      gc = "git commit";
      gch = "git checkout";
      gchb = "git checkout -b";
      gcoe = "git config user.email";
      gcon = "git config user.name";
    };
    initExtra = ''
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        ZVM_VI_ESCAPE_BINDKEY=kj
      '';
  };
  
  programs.starship.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
