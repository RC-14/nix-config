{ config, pkgs, lib, ... }: {
	enable = true;
	defaultEditor = true;

	viAlias = true;
	vimAlias = true;
	vimdiffAlias = true;

	extraPackages = with pkgs; [
		gcc
		gnumake
    nodejs_23
		ripgrep
	];
}
