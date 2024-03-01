{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  services.redsocks = {
    enable = true;
    redsocks = [
    {
      doNotRedirect = [
        "-d 1.2.0.0/16"
      ];
      # ip = "0.0.0.0";
      port = 23456;
      proxy = "10.8.6.50:3128";
      redirectCondition = "--dport 80";
      type = "http-relay";
    }
    {
      doNotRedirect = [
        "-d 1.2.0.0/16"
      ];
      # ip = "0.0.0.0";
      port = 23457;
      proxy = "10.8.6.50:3128";
      redirectCondition = true;
      type = "http-connect";
    }
    ]
  }


}
