{ config, pkgs, lib, ... }:

let
  regularModel = "llama3.2:3b";
  abliteratedModel = "nchapman/mistral-small-instruct-2409-abliterated";
in
{
  services.ollama = {
    enable = true;
    loadModels = [ regularModel abliteratedModel ];
  };

  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 3000;
    openFirewall = false;
  };

  environment.variables = {
    OLLAMA_HOST = "http://127.0.0.1:11434";
    OPENWEBUI_URL = "http://127.0.0.1:3000";
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
