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
  services.fprintd = {
    enable = true;
    # tod.enable and tod.driver are for newer libfprint-tod devices.
    # VFS495 uses the legacy validity-sensors path — no tod needed.
  };

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
