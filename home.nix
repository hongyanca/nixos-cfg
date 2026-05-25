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
  ];

  home = {
    username = "yanh";
    homeDirectory = "/home/yanh";
  };


  home.sessionPath = [
    "$HOME/.npm-packages/bin"
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
  };


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

    # neovim
    tree-sitter
    gcc
    gnumake
    nodejs_24
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

      format = "  $directory$git_branch$git_status$character";

      directory = {
        format = "[$path]($style) ";
        style = "bold blue";
        truncation_length = 16;
        home_symbol = "~";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold yellow";
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
