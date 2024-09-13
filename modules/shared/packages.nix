{ pkgs }: with pkgs; [
	# General packages for development and system management
	bash-completion
	btop
	coreutils
	fastfetch
	git
	killall
	nix-output-monitor
	openssh
	opentofu
	wget
	zip

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
]
