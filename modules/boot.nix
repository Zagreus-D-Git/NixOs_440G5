{ config, pkgs, ... }:

{
  # --- Bootloader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit stored generations in the boot menu — keeps it clean
  boot.loader.systemd-boot.configurationLimit = 10;

  # --- LUKS encryption ---
  # Root partition
  boot.initrd.luks.devices."luks-6f2453c5-3a0c-4f0d-b71b-903cd25877c4" = {
    device = "/dev/disk/by-uuid/6f2453c5-3a0c-4f0d-b71b-903cd25877c4";
    allowDiscards = false; # HDD — discard/TRIM is irrelevant, leave off
  };

  # Swap partition
  boot.initrd.luks.devices."luks-028a400a-4c66-41a9-b817-e219e24e0ce3" = {
    device = "/dev/disk/by-uuid/028a400a-4c66-41a9-b817-e219e24e0ce3";
    allowDiscards = false;
  };

  # --- Kernel ---
  # linux_zen: desktop-responsiveness patches, 1000Hz timer, better latency
  # Compatible with rtw88_8821ce (in-tree driver, no DKMS needed)
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # --- Kernel modules ---
  # kvm-intel: preserved from hardware-configuration — useful for local VMs
  boot.kernelModules = [ "kvm-intel" ];

  # --- Kernel parameters ---
  boot.kernelParams = [
    # intel_pstate stays in active mode (default) — no override needed
    # Quiet boot: reduce verbosity after POST
    "quiet"
    "loglevel=3"
    "rd.udev.log_level=3"
  ];

  # --- Flakes + nix-command ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # --- State version ---
  # Tracks stateful data layout — do not change after first install
  system.stateVersion = "25.11";
}
