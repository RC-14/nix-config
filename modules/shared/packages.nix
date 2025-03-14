{ pkgs, voedl }: with voedl.packages.${pkgs.stdenv.hostPlatform.system}; [
  default
  batchdl
] ++ (with pkgs; [
	# General packages for development and system management
	bash-completion
	btop
	coreutils
	fastfetch
	git
	killall
	nix-output-monitor
	openssh
  static-web-server
	wget
	zip
	zulu

	# Encryption and security tools
	age
	age-plugin-yubikey
	gnupg
	libfido2

	# Media-related packages
	ffmpeg

	# Text and terminal utilities
	htop
	jq
	ripgrep
	tldr
	tree
	rar
	unzip
	zsh-powerlevel10k

	# Games
	prismlauncher
])
