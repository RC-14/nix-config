{ pkgs, lib, ... }: {
  enable = true;

	# Use homebrew alacritty on darwin
	package = let
    kittyDir = "/Applications/kitty.app/Contents/MacOS";
  in lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (with pkgs; symlinkJoin {
    name = "kitty.app";
    paths = [
      (writeShellScriptBin "kitty" "exec ${kittyDir}/kitty \"$@\"")
      (writeShellScriptBin "kitten" "exec ${kittyDir}/kitten \"$@\"")
    ];
  });

  font = {
    name = "GeistMono Nerd Font";
    size = 11;
  };

  darwinLaunchOptions = [
    "--single-instance"
  ];

  shellIntegration.mode = "no-rc no-cursor no-title";

  environment = {};

  keybindings = {};

  settings = {
    "enable_audio_bell" = "no";

    "background_opacity" = "0.9";

    "remember_window_size" = "no";
    "initial_window_width" = "120c";
    "initial_window_height"= "40c";

    # Darwin specific
    "macos_option_as_alt" = "both";
    "macos_quit_when_last_window_closed" = "no";
  };
}