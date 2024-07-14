{ lib, pkgs, user, ... }: {
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
}
