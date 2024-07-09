{ config, pkgs, lib, ... }: let
	name = "RC-14";
	user = "rc-14";
	email = "61058098+RC-14@users.noreply.github.com";
in {
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
