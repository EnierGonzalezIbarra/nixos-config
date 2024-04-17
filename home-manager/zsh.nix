{ pkgs, lib, ... }:
{
  programs.zsh = {
    # My zsh config
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
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
      grep = "grep --color=auto";
      ":q" = "exit";

      y = "yazi";

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

        if command -v eza &> /dev/null; then
          alias -- 'ls'='eza --icons --group-directories-first'
          alias -- 'll'='eza --icons --group-directories-first -l --git'
          alias -- 'la'='eza --icons --group-directories-first -la --git'
          alias -- 'l'='eza --icons --group-directories-first -lha --git'
        else 
          alias -- 'ls'='ls --color=auto --group-directories-first'
          alias -- 'll'='ls -l --color=auto --group-directories-first'
          alias -- 'la'='ls -la --color=auto --group-directories-first'
          alias -- 'l'='ls -lha --color=auto --group-directories-first'
        fi
      '';
  };
  
  programs.starship.enable = true;
}
