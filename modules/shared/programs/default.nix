{ config, pkgs, lib, ... }: let
	name = "RC-14";
	user = "rc-14";
	email = "61058098+RC-14@users.noreply.github.com";
in {
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
		aliases = {
			# Undo the last commit, keeping all files and changes
			shit = "reset --soft HEAD~1";
			# Reset files to the state of the current commit. Does not delete untracked files, use clean -i for that.
			wipe = "reset --hard";
		};
	};
	
	mpv = import ./mpv.nix { inherit config pkgs lib; };

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

	yt-dlp = {
		enable = true;
		settings = {
			concurrent-fragments = 8;
		};
	};
	
	zsh = import ./zsh.nix { inherit config pkgs lib; };
}
