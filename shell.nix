{ ... }: {
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
      rebuild-home = "sudo nixos-rebuild switch --flake ~/.nixos-cfg#nixos";
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
}
