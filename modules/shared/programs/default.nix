{ config, pkgs, lib, ... }: let
	name = "RC-14";
	user = "rc-14";
	email = "61058098+RC-14@users.noreply.github.com";
in {
	gh = {
		enable = true;
		settings = {
			editor = "vim";
			git_protocol = "ssh";
		};
	};

	git = {
		enable = true;
		ignores = [ ".DS_Store" ];
		userName = name;
		userEmail = email;
		lfs.enable = true;
		extraConfig = {
			init.defaultBranch = "main";
			core = {
				editor = "vim";
			};
			pull.rebase = true;
		};
	};
	
	mpv = {
		enable = true;

		# On mac use the homebrew cask instead
		package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (pkgs.writeShellScriptBin "mpv" "exec /nix/store/n59hsv730dfxmwnm67b5lf2m9qmnxii1-darwin-mpv-link/bin/mpv $@");

		bindings = {
			# Skip anime opening
			"Shift+s" = "seek +85";
		};

		config = {
			fullscreen = true;

			# Fuzzy subtitle finding
			sub-auto = "fuzzy";

			# Use GPU-accelerated video output by default
			vo = "libmpv";
			# Use hardware video decoding
			hwdec = "yes";

			# Screenshot config
			screenshot-format = "png";
			screenshot-directory = "~/Pictures/Screenshots/";
		};
	};

	neovim = import ./neovim { inherit config pkgs lib; };

	ssh = {
		enable = true;
		includes = [
			(lib.mkIf pkgs.stdenv.hostPlatform.isLinux "/home/${user}/.ssh/config_external")
			(lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/Users/${user}/.ssh/config_external")
		];
		matchBlocks = {
			"github.com" = {
				identitiesOnly = true;
				identityFile = [
					(lib.mkIf pkgs.stdenv.hostPlatform.isLinux "/home/${user}/.ssh/id_ed25519")
					(lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/Users/${user}/.ssh/id_ed25519")
				];
			};
		};
	};

	zsh = import ./zsh.nix { inherit config pkgs lib; };
}
