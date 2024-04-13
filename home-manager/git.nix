{ pkgs, lib, ... }:
let
  email = "79170796+EnierGonzalezIbarra@users.noreply.github.com";
  name = "Enier González Ibarra";
in 
{
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core = {
        editor = "nvim --wait";
        autocrlf = false;
        sshCommand = "ssh -i ~/.ssh/github_auth";
      };
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
    userEmail = email;
    userName = name;
    # signingkey = /home/enier/.ssh/github_sign.pub;
  };

}
