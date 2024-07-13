{ config, pkgs, lib, home-manager, ... }: let
	user = "rc-14";
	# Define the content of your file as a derivation
	sharedFiles = import ../shared/files.nix { inherit config pkgs; };
	additionalFiles = import ./files.nix { inherit user config pkgs; };
in {
	imports = [
		./dock
	];

	users.users.${user} = {
		name = "${user}";
		home = "/Users/${user}";
		isHidden = false;
		shell = pkgs.zsh;
	};

	homebrew = {
		enable = true;
		casks = pkgs.callPackage ./casks.nix {};
		onActivation.cleanup = "zap";
		caskArgs.no_quarantine = true;

		# These app IDs are from using the mas CLI app
		# mas = mac app store
		# https://github.com/mas-cli/mas
		#
		# $ nix shell nixpkgs#mas
		# $ mas search <app name>
		#
		# If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
		# you may receive an error message "Redownload Unavailable with This Apple ID".
		# This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
		masApps = {
			# Audible = 379693831;
			Bitwarden = 1352778147;
			Goodnotes = 1444383602;
			Keynote = 409183694;
			LocalSend = 1661733229;
			Numbers = 409203825;
			Pages = 409201541;
			Prime-Video = 545519333;
			# Tachimanga = 6447486175;
			Telegram = 747648890;
			Wireguard = 1451685025;
		};
	};

	# Enable home-manager
	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		users.${user} = { pkgs, config, lib, ... }:{
			home = {
				packages = pkgs.callPackage ./packages.nix {};
				stateVersion = "24.05";
			};
			programs = {} // import ../shared/programs { inherit config pkgs lib; };

			# Marked broken Oct 20, 2022 check later to remove this
			# https://github.com/nix-community/home-manager/issues/3344
			manual.manpages.enable = false;
		};
	};

	# Fully declarative dock using the latest from Nix Store
	local = { 
		dock = {
			enable = true;
			entries = [
				##########
				## Apps ##
				##########

				# { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"; }

				{ path = "/System/Applications/System Settings.app"; }
				{ path = "/System/Applications/Utilities/Activity Monitor.app"; }
				{ path = "/Applications/Bitwarden.app"; }
				{ path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
				{ path = "/Applications/GitHub Desktop.app"; }
				{ path = "/Applications/Visual Studio Code.app"; }
				{ path = "/Applications/Telegram.app"; }
				{ path = "/Applications/Discord.app"; }
				{ path = "/Applications/Signal.app"; }
				{ path = "/System/Applications/Mail.app/"; }
				{ path = "/System/Applications/Calendar.app"; }
				{ path = "/System/Applications/Reminders.app"; }
				{ path = "/Applications/NetNewsWire.app"; }
				{ path = "/Applications/Firefox.app"; }
				{ path = "/Applications/Prime Video.app"; }
				{ path = "/System/Applications/Music.app/"; }
				{ path = "/Applications/LocalSend.app"; }
				{ path = "/Applications/AlDente.app"; }
				{ path = "/Applications/Mullvad VPN.app"; }

				#############
				## Folders ##
				#############

				{
					path = "${config.users.users.${user}.home}/Downloads";
					section = "others";
					options = "--sort name --view fan --display stack";
				}
			];
		};
	};
}
