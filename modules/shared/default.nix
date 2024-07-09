{ config, pkgs, ... }: {
	nixpkgs = {
		config = {
			allowUnfree = true;
			allowBroken = false;
			allowInsecure = false;
			allowUnsupportedSystem = false;
		};

		# Apply each overlay found in the /overlays directory
		overlays = let
			path = ../../overlays;
		in with builtins; map
			(n: import (path + ("/" + n)))
			(filter
				(n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix")))
				(attrNames (readDir path))
			);
	};
}
