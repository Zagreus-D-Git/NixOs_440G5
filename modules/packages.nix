{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # --- Editors ---
    vim

    # --- Shell tools ---
    wget
    git
    htop
    btop          # richer htop alternative
    tree
    ripgrep
    fd

    # --- Hardware diagnostics ---
    pciutils      # lspci
    usbutils      # lsusb
    dmidecode     # RAM, BIOS, hardware info (needs sudo)
    lshw          # full hardware listing
    smartmontools # HDD health (SMART data)
    hdparm        # HDD/SSD parameters

    # --- Network diagnostics ---
    iw            # wireless interface info
    wirelesstools # iwconfig etc.

    # --- Apps ---
    brave
    spotify
    
    # --- Opencode ---
    ripgrep
    fd
    jq
    tree
    nixfmt-rfc-style
    statix
    deadnix
    #alejandra
    nil
    
  ];

  # --- Programs with special NixOS integration ---
  programs.firefox.enable = true; # proper Wayland/sandbox integration

  programs.git = {
    enable = true;
    # user config goes in home-manager when you add it
  };
}
