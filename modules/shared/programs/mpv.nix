{ lib, pkgs, ... }: {
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
}
