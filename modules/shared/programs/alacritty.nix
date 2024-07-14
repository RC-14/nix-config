{ pkgs, ... }: {
	enable = true;

	settings = {
		live_config_reload = true;

		colors = {
			transparent_background_colors = true;
			
			bright = {
				black = "#676767";
				blue = "#6871ff";
				cyan = "#5ffdff";
				green = "#5ff967";
				magenta = "#ff76ff";
				red = "#ff6d67";
				white = "#fffefe";
				yellow = "#fefb67";
			};

			normal = {
				black = "#000000";
				blue = "#0225c7";
				cyan = "#00c5c7";
				green = "#00c200";
				magenta = "#c930c7";
				red = "#c91b00";
				white = "#c7c7c7";
				yellow = "#c7c400";
			};

			primary = {
				background = "#000000";
				foreground = "#c7c7c7";
			};
		};

		cursor = {	
			thickness = 0.15;
			unfocused_hollow = true;

			style.shape = "Block";
		};

		font = {
			size = 11.0;

			bold = {
				family = "GeistMono Nerd Font";
				style = "Bold";
			};

			bold_italic = {
				family = "GeistMono Nerd Font";
				style = "Bold Italic";
			};

			italic = {
				family = "GeistMono Nerd Font";
				style = "Italic";
			};

			normal = {
				family = "GeistMono Nerd Font";
				style = "Regular";
			};
		};

		shell.program = "${pkgs.zsh}/bin/zsh";

		window = {
			opacity = 0.9;
			option_as_alt = "Both";

			dimensions = {
				columns = 128;
				lines = 32;
			};
		};
	};
}
