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
      pull.rebase = false;
      init.defaultBranch = "main";
      http.lowSpeedLimit = 1000;
      http.lowSpeedTime = 1200;
    };
    userEmail = email;
    userName = name;
  };

}
