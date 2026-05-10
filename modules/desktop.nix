{ config, pkgs, ... }:

{
  # --- Display server ---
  services.xserver.enable = true;

  # --- GNOME + GDM ---
  services.displayManager.gdm = {
    enable = true;
    wayland = true; # force Wayland sessions in GDM (already your default)
  };
  services.desktopManager.gnome.enable = true;

  # --- GNOME: trim the default app bloat ---
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-music
    gnome-maps
    epiphany        # GNOME web browser
    totem           # video player
    yelp            # help browser
  ];

  # --- Keymap ---
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };
  console.keyMap = "la-latin1";

  # --- Locale + timezone ---
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Fonts ---
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf     # metric-compatible MS fonts (web rendering)
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];
    fontconfig.defaultFonts = {
      serif     = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
