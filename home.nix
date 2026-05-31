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
    "$HOME/.local/share/mise/shims"
  ];

  home.file.".gitignore_global".text = "";
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
    mise
    devenv

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
  ]) ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    antigravity
    codex
    opencode
    rtk
  ]);

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Hong Yan";
        email = "contact@hongyan.ca";
        signingkey = "~/.ssh/github-hongyanca.pub";
      };

      core = {
        editor = "nvim";
        pager = "delta";
        excludesFile = "/home/yanh/.gitignore_global";
        ignoreCase = false;
      };
      init.defaultBranch = "main";

      pull.rebase = true;

      rebase = {
        autosquash = true;
        autostash = true;
      };

      interactive.diffFilter = "delta --color-only";

      delta = {
        navigate = true;
        side-by-side = true;
      };

      alias = {
        more = "commit --amend --no-edit";
      };

      gpg = {
        program = "gpg2";
        format = "ssh";
      };

      commit.gpgsign = true;
      tag.gpgSign = true;
    };
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
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ls = "lsd";
      l = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      j = "z";
      rebuild = "sudo nixos-rebuild switch";
      update-system = "nix flake update --flake /etc/nixos && sudo nixos-rebuild switch";
      dump-garbage = "sudo nix-collect-garbage -d && sudo nix-store --optimise && df -h";
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
      right_format = "$username$hostname";

      format = "  $directory$git_branch$git_status$character";

      username = {
        format = "[$user]($style)";
        style_user = "yellow";
        style_root = "bold red";
        show_always = true;
      };
      hostname = {
        format = "[@$hostname]($style)";
        style = "yellow";
        ssh_only = false;
      };
      directory = {
        format = "[$path]($style) ";
        style = "bold blue";
        home_symbol = "~";
        truncate_to_repo = false;
        fish_style_pwd_dir_length = 1;
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "green";
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
