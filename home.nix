# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  home = {
    username = "yanh";
    homeDirectory = "/home/yanh";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;

  home.packages = with pkgs;[
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
    ripgrep
    jq
    yq-go
    fzf
    zoxide
    lsd
    starship

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
  ];

  programs.git = {
    enable = true;
    settings.user.name = "Hong Yan";
    settings.user.email = "contact@hongyan.ca";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      ls = "lsd";
      l = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      j = "z";
    };

    initContent = ''
      bindkey -e
  
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
  
      bindkey '^P' up-line-or-beginning-search
      bindkey '^N' down-line-or-beginning-search
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
  
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
  
      format = "  $directory$character";
  
      directory = {
        format = "[$path]($style) ";
        style = "bold blue";
        truncation_length = 16;
        home_symbol = "~";
      };
  
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };
    };
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
