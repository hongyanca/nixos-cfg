# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    # system = pkgs.system;
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./shell.nix
    ./git.nix
    ./llm-agents.nix
  ];

  home = {
    username = "yanh";
    homeDirectory = "/home/yanh";
  };

  home.sessionPath = [
    "$HOME/.npm-packages/bin"
    "$HOME/.local/share/mise/shims"
  ];

  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-packages
  '';

  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    sideloadInitLua = true;
    withRuby = false;
    withPython3 = false;
  };


  home.packages = (with pkgs; [
    home-manager
    hydra-check

    # archivers
    zip
    xz
    unzip
    p7zip
    gnutar

    # utils
    gawk
    gnupg
    gnused
    gdu
    ripgrep
    delta
    fd
    jq
    yq-go
    lsd

    # networking
    mtr
    iperf3
    dnsutils
    aria2
    socat
    nmap
    ipcalc

    # misc
    cowsay
    file
    which
    fastfetch
    bat

    # monitoring
    btop
    htop
    iotop
    iftop

    # system utils
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # dev
    mise
    uv
    tree-sitter
    gcc
    gnumake
    nodejs_24
    python314
  ]);


  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
