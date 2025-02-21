{ lib, pkgs, ... }: {
	enable = true;

	# On mac use the homebrew cask instead
	package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (pkgs.writeShellScriptBin "mpv" "exec /Applications/mpv.app/Contents/MacOS/mpv \"$@\"");

	bindings = {
		# Skip anime opening
		"Shift+s" = "seek +85";
    # Next Chapter
    "Alt+right" = "add chapter 1";
    # Previous Chapter / Start of current Chapter
    "Alt+left" = "add chapter -1";
	};

	config = {
		fullscreen = true;

		# Fuzzy subtitle finding
		sub-auto = "fuzzy";

		# Use GPU-accelerated video output by default
		vo = "libmpv";
		# Use hardware video decoding
		hwdec = "yes";

    # Treat right Alt key as Alt not Alt-Gr
    input-right-alt-gr = "no";

		# Screenshot config
		screenshot-format = "png";
		screenshot-directory = "~/Pictures/Screenshots/";
	};
}
