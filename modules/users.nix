{ config, pkgs, ... }:

{
  users.users.probook440g5 = {
    isNormalUser = true;
    description  = "Probook440g5";
    extraGroups  = [
      "networkmanager" # manage network connections without sudo
      "wheel"          # sudo access
      "audio"          # direct audio device access (pipewire usually handles this)
      "video"          # video device access
      "input"          # input devices (useful for some Wayland compositors)
    ];
    shell = pkgs.bash; # change to pkgs.zsh or pkgs.fish if desired
    packages = with pkgs; [
      # user-specific packages go here or in home-manager
    ];
  };
}
