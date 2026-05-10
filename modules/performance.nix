{ config, pkgs, lib, ... }:

{
  # --- CPU: intel_pstate (active mode) ---
  # With intel_pstate active, this sets the P-state hint.
  # "performance" = max responsiveness when plugged in.
  # For battery awareness, consider power-profiles-daemon (see below).
  powerManagement.cpuFreqGovernor = "performance";

  # --- Power profiles daemon ---
  # Allows switching between power-saver / balanced / performance profiles
  # at runtime (GNOME power settings integrates with this automatically).
  # Conflicts with TLP — do not enable both.
  services.power-profiles-daemon.enable = true;

  # --- IO scheduler: BFQ for HDD ---
  # BFQ (Budget Fair Queueing): prioritizes interactive app latency over
  # raw throughput — correct choice for spinning disk.
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", \
      ATTR{queue/scheduler}="bfq"
  '';
  # Note: the rotational==1 guard ensures this only applies to HDDs.
  # If you ever add an SSD it will not be affected.

  # --- VM / memory tuning ---
  boot.kernel.sysctl = {
    # Reduce swap aggressiveness — prefer keeping processes in RAM
    # Default is 60; 10 is good for 16GB RAM with a slow HDD swap
    "vm.swappiness" = 10;

    # How long dirty pages stay in memory before being written to disk
    # Default 3000 (30s); lower = more frequent small writes = smoother on HDD
    "vm.dirty_writeback_centisecs" = 1500;

    # Dirty ratio: start background writeback at 5% of RAM (~800MB)
    "vm.dirty_background_ratio" = 5;

    # Dirty ratio hard limit: force synchronous writeback at 10%
    "vm.dirty_ratio" = 10;
  };

  # --- Zram swap (optional but recommended for HDD systems) ---
  # Compressed in-RAM swap reduces HDD swap pressure significantly.
  # With 16GB RAM, zram as primary swap + HDD swap as fallback is ideal.
  zramSwap = {
    enable = true;
    algorithm = "zstd";      # best compression/speed tradeoff
    memoryPercent = 25;      # ~4GB compressed swap in RAM
    priority = 100;          # higher priority than HDD swap (default 0)
  };
  # The LUKS swap on sda3 remains available as fallback — no changes needed.
}
