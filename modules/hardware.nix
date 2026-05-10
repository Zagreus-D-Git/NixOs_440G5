{ config, pkgs, lib, ... }:

{
  # --- Firmware ---
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # --- Intel GPU (UHD 620 / i915) ---
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver    # iHD — correct driver for 7th Gen+ (Kaby Lake)
      intel-compute-runtime # OpenCL support
      intel-vaapi-driver    # VA-API hardware video decode
      libva-vdpau-driver    # VDPAU bridge (for apps using VDPAU)
      libvdpau-va-gl        # VDPAU via VA-API
    ];
  };

  # iHD is the correct VA-API driver for Kaby Lake (gen9+)
  environment.variables.LIBVA_DRIVER_NAME = "iHD";

  # --- WiFi: Realtek RTL8821CE ---
  # Driver: rtw88_8821ce (in-tree since 5.15 — no DKMS needed with zen kernel)
  boot.extraModprobeConfig = ''
    # Disable aggressive power save — source of random disconnects on this chip
    options rtw88_core disable_lps_deep=1
    options rtw88_pci disable_ps=1
    # MSI interrupts: improves throughput stability
    options rtw88_8821ce msi_support=1
  '';

  # --- Bluetooth ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # exposes battery level, cleaner pairing
  };

  # --- Audio: Intel HDA Sunrise Point-LP ---
  # Handled in services.nix (pipewire) — nothing hardware-specific needed here
  # The snd_hda_intel module loads automatically

  # --- Fingerprint reader: Validity VFS495 ---
  # Service enabled in services.nix — driver support comes from fprintd
  # VFS495 requires libfprint with validity-sensors support (included in nixpkgs)

  # --- Card reader: Realtek RTS522A ---
  # Handled by rtsx_pci_sdmmc in boot.initrd (already in hardware-configuration)
  # No additional config needed

  # --- Unfree ---
  nixpkgs.config.allowUnfree = true;
}
