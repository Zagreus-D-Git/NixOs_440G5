{ config, pkgs, lib, ... }:

{
  ##########################################################################
  ## Ollama
  ##########################################################################

  services.ollama = {
    enable = true;

    # CPU inference only
    acceleration = false;

    # Local machine only
    host = "127.0.0.1";
    port = 11434;

    # Models are managed manually with:
    #
    #   ollama pull ...
    #
    # No automatic downloads.
    loadModels = [ ];

    # Environment for the daemon
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "10m";

      # Plenty of disk available
      OLLAMA_MODELS = "/var/lib/ollama/models";

      # Conservative queue for a daily-driver laptop
      OLLAMA_MAX_QUEUE = "2";
    };
  };

  ##########################################################################
  ## Open WebUI
  ##########################################################################

  services.open-webui = {
    enable = true;

    host = "127.0.0.1";
    port = 3000;

    openFirewall = false;
  };

  ##########################################################################
  ## Useful client environment
  ##########################################################################

  environment.sessionVariables = {
    OLLAMA_HOST = "http://127.0.0.1:11434";
  };

  ##########################################################################
  ## Packages
  ##########################################################################

  environment.systemPackages = with pkgs; [
    ollama
  ];

  ##########################################################################
  ## Desktop launcher
  ##########################################################################

  environment.etc."xdg/open-webui.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Open WebUI
    Exec=${pkgs.xdg-utils}/bin/xdg-open http://127.0.0.1:3000
    Icon=applications-internet
    Terminal=false
    Categories=Utility;
  '';
}
