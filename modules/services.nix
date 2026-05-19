{ config, pkgs, ... }:

{
  # --- Networking ---
  networking.hostName = "probook440g5";
  networking.networkmanager.enable = true;



  # --- Audio: PipeWire ---
  services.pulseaudio.enable = false; # must be false when using pipewire
  security.rtkit.enable = true;       # realtime scheduling for pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; # uncomment if you need JACK apps
  };

  # --- Fingerprint reader ---
  # Install the driver
  services.fprintd.enable = true;
  # If simply enabling fprintd is not enough, try enabling fprintd.tod...
  services.fprintd.tod.enable = true;
  # ...and use one of the next four drivers
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan; # Elan(04f3:0c4b) driver
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # (Marked as broken as of 2025/04/23!) driver for 2016 ThinkPads
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a; # Goodix 550a driver (from Lenovo)

  # however for focaltech 2808:a658, use fprintd with overidden package (without tod)
  # services.fprintd.package = pkgs.fprintd.override {
  #   libfprint = pkgs.libfprint-focaltech-2808-a658;
  # };

  # --- Printing ---
  services.printing.enable = true;
  # For network printer discovery, add avahi:
  # services.avahi = { enable = true; nssmdns4 = true; };

  # --- Bluetooth service ---
  services.blueman.enable = true; # GUI Bluetooth manager (complements GNOME)

  # --- Firmware updates ---
  services.fwupd.enable = true; # HP ProBook has LVFS support

  # --- Automatic garbage collection ---
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # --- Nix store optimisation ---
  nix.settings.auto-optimise-store = true;
}
