{ config, pkgs, lib, ... }: {
	enable = true;
	defaultEditor = true;

	viAlias = true;
	vimAlias = true;
	vimdiffAlias = true;

	extraPackages = with pkgs; [
    cargo
		gcc
		gnumake
    nodejs_24
		ripgrep
	];
}
