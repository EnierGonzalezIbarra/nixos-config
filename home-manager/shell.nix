{ pkgs, lib, ... }:
let
  aliases = {
    off = "systemctl poweroff";
    p = "ping google.com";
    pc = "ping cubadebate.cu";

    conf = "cd ~/dotfiles/nix/ && nvim && cd -";
    sw = "nh os switch";
    upgrade = "cd ~/NixOS && sw --update && cd -";
    bt = "nh os boot";
    upgrade-boot = "cd ~/NixOS && bt --update && cd -";

    search = "nh search";

    cleanup = "nh clean all --keep 3 --keep-since 7d && echo 'now optimizing store' && sudo nix-store --optimise";
    full-cleanup = "nh clean all && sudo nix-store --optimise";

    bat = "cat";
    grep = "grep --color=auto";
    ":q" = "exit";

    ls = "eza --icons --group-directories-first";
    ll = "eza --icons --group-directories-first -l --git";
    la = "eza --icons --group-directories-first -la --git";
    l = "eza --icons --group-directories-first -lha --git";

    v = "nvim";
    y = "yazi";

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
in
{
  programs.zsh = {
    # My zsh config
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = aliases;
    initExtra = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      ZVM_VI_ESCAPE_BINDKEY=kj
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = aliases;
  };

  programs.starship.enable = true;
}
