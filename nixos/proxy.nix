{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  # Configure network proxy if necessary
  networking.proxy.allProxy = "http://10.8.6.50:3128/"; # Proxy for CUJAE
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,*cujae.edu.cu";

  # services.redsocks = {
  #   enable = true;
  #   redsocks = [
  #   {
  #     doNotRedirect = [
  #       "-d 1.2.0.0/16"
  #     ];
  #     # ip = "0.0.0.0";
  #     port = 23456;
  #     proxy = "10.8.6.50:3128";
  #     redirectCondition = "--dport 80";
  #     type = "http-relay";
  #   }
  #   {
  #     doNotRedirect = [
  #       "-d 1.2.0.0/16"
  #     ];
  #     # ip = "0.0.0.0";
  #     port = 23457;
  #     proxy = "10.8.6.50:3128";
  #     redirectCondition = true;
  #     type = "http-connect";
  #   }
  #   ];
  # };


}
