{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.runCommand "custom-terminfo" {} ''
      mkdir -p $out/share/terminfo/x

      cp ${./terminfo/xterm-kitty}   $out/share/terminfo/x/xterm-kitty
      cp ${./terminfo/xterm-ghostty} $out/share/terminfo/x/xterm-ghostty
    '')
  ];
}
