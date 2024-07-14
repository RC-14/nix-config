{ config, pkgs, lib, ... }: let
	name = "RC-14";
	user = "rc-14";
	email = "61058098+RC-14@users.noreply.github.com";

	exports =  { inherit config pkgs lib name user email; };
in {
	alacritty = import ./alacritty.nix exports;

	direnv = {
		enable = true;
		nix-direnv.enable = true;
	};

	gh = {
		enable = true;
		settings = {
			editor = "vim";
			git_protocol = "ssh";
		};
	};

	git = import ./git.nix exports;
	
	mpv = import ./mpv.nix exports;

	neovim = import ./neovim exports;

	ssh = import ./ssh.nix exports;

	yt-dlp = {
		enable = true;
		settings = {
			concurrent-fragments = 8;
		};
	};
	
	zsh = import ./zsh.nix exports;
}
