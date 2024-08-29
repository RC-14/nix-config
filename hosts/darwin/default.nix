{ agenix, config, pkgs, ... }: let
	user = "rc-14";
in {
	imports = [
		../../modules/darwin/secrets.nix
		../../modules/darwin/home-manager.nix
		../../modules/shared
		../../modules/shared/cachix
		agenix.darwinModules.default
	];

	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable = true;

	# Setup user, packages, programs
	nix = {
		package = pkgs.nix;

		gc = {
			user = "root";
			automatic = true;
			interval = { Weekday = 1; Hour = 2; Minute = 0; };
			options = "--delete-older-than 7d";
		};

		settings = {
			# Turn this on to make command line easier
			experimental-features = [ "nix-command" "flakes" ];

			# Disable auto-optimise-store because of this issue:
			#   https://github.com/NixOS/nix/issues/7273
			# "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
			auto-optimise-store = false;
		};
	};

	# Add ability to used TouchID for sudo authentication
	security.pam.enableSudoTouchIdAuth = true;

	# Create /etc/zshrc that loads the nix-darwin environment.
	# this is required if you want to use darwin's default shell - zsh
	programs.zsh.enable = true;
	environment.shells = [
		pkgs.zsh
	];
	environment.pathsToLink = [ "/usr/share/zsh" ];

	# Load configuration that is shared across systems
	environment.systemPackages = with pkgs; [
		agenix.packages."${pkgs.system}".default
	] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

	fonts.packages = with pkgs; [
		geist-font

		(nerdfonts.override {
			fonts = [
				# Patched fonts
				"GeistMono"
			];
		})
	];

	system = {
		stateVersion = 4;

		# activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
		activationScripts.postUserActivation.text = ''
# activateSettings -u will reload the settings from the database and apply them to the current session,
# so we do not need to logout and login again to make the changes take effect.
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

/opt/homebrew/bin/brew upgrade
'';

		defaults = {
			menuExtraClock.Show24Hour = true;

			dock = {
				autohide = true;
				show-recents = true;
				launchanim = true;
				orientation = "bottom";
				tilesize = 40; # Size of icons in the dock

				mru-spaces = false; # Rearange spaces based on most recent use

				# customize Hot Corners
				wvous-tl-corner = 1;  # top-left - Disabled
				wvous-tr-corner = 1;  # top-right - Disabled
				wvous-bl-corner = 1;  # bottom-left - Disabled
				wvous-br-corner = 1;  # bottom-right - Disabled
			};

			finder = {
				_FXShowPosixPathInTitle = false;
				AppleShowAllExtensions = true;
				FXDefaultSearchScope = "SCcf";
				FXEnableExtensionChangeWarning = false;
				ShowPathbar = false;
				ShowStatusBar = false;
			};

			loginwindow = {
				GuestEnabled = false;
				PowerOffDisabledWhileLoggedIn = true;
				RestartDisabledWhileLoggedIn = true;
				ShutDownDisabledWhileLoggedIn = true;
				SHOWFULLNAME = false; # false = display list of users, true = username and password input
			};

			screencapture = {
				location = "~/Pictures/Screenshots/";
				type = "png";
			};

			screensaver = {
				# Require password immediately after sleep or screen saver begins
				askForPassword = true;
				askForPasswordDelay = 0;
			};

			SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

			trackpad = {
				Clicking = true;  # enable tap to click
				TrackpadRightClick = true;  # enable two finger right click
			};
			
			# customize settings that not supported by nix-darwin directly
			# Incomplete list of macOS `defaults` commands :
			#   https://github.com/yannbertrand/macos-defaults
			NSGlobalDomain = {
				# `defaults read NSGlobalDomain "xxx"`
				# Use F1, F2, etc. as standard function keys
				"com.apple.keyboard.fnState" = true; 

				AppleInterfaceStyle = "Dark";  # dark mode
				AppleKeyboardUIMode = 3;  # Mode 3 enables full keyboard control.
				ApplePressAndHoldEnabled = false;
				AppleShowAllExtensions = true;

				# If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
				# sets how long it takes before it starts repeating.
				InitialKeyRepeat = 15; # 120, 94, 68, 35, 25, 15
				# sets how fast it repeats once it starts. 
				KeyRepeat = 2; # 120, 90, 60, 30, 12, 6, 2

				NSAutomaticCapitalizationEnabled = false;  # disable auto capitalization
				NSAutomaticDashSubstitutionEnabled = false;  # disable auto dash substitution
				NSAutomaticPeriodSubstitutionEnabled = false;  # disable auto period substitution
				NSAutomaticQuoteSubstitutionEnabled = false;  # disable auto quote substitution
				NSAutomaticSpellingCorrectionEnabled = false;  # disable auto spelling correction
				NSNavPanelExpandedStateForSaveMode = true;  # expand save panel by default
				NSNavPanelExpandedStateForSaveMode2 = true;
			};

			# Customize settings that not supported by nix-darwin directly
			# see the source code of this project to get more undocumented options:
			#    https://github.com/rgcr/m-cli
			# 
			# All custom entries can be found by running `defaults read` command.
			# or `defaults read xxx` to read a specific domain.
			CustomUserPreferences = {
				".GlobalPreferences" = {
					# automatically switch to a new space when switching to the application
					AppleSpacesSwitchOnActivate = true;
				};

				NSGlobalDomain = {
					# Add a context menu item for showing the Web Inspector in web views
					WebKitDeveloperExtras = true;
				};
				
				"com.apple.AdLib".allowApplePersonalizedAdvertising = false;

				"com.apple.desktopservices" = {
					# Avoid creating .DS_Store files on network or USB volumes
					DSDontWriteNetworkStores = true;
					DSDontWriteUSBStores = true;
				};

				"com.apple.finder" = {
					ShowExternalHardDrivesOnDesktop = true;
					ShowHardDrivesOnDesktop = false;
					ShowMountedServersOnDesktop = true;
					ShowRemovableMediaOnDesktop = true;
					_FXSortFoldersFirst = true;

					FXPreferredGroupBy = "Kind";
					DesktopViewSettings = {
						GroupBy = "Kind";
						IconViewSettings = {
							arrangeBy = "name";
							gridSpacing = 54;
							iconSize = 64;
							labelOnBottom = 1;
							showIconPreview = 1;
							showIconInfo = 0;
							textSize = 12;
							# Don't really know what they do but I don't just wanna delete them
							viewOptionsVersion = 1;
							backgroundColorBlue = 1;
							backgroundColorGreen = 1;
							backgroundColorRed = 1;
							backgroundType = 0;
							gridOffsetX = 0;
							gridOffsetY = 0;
						};
					};
				};

				# Prevent Photos from opening automatically when devices are plugged in
				"com.apple.ImageCapture".disableHotPlug = true;

				"com.apple.WindowManager" = {
					EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
					StandardHideDesktopIcons = 0; # Show items on desktop
					HideDesktop = 0; # Do not hide items on desktop & stage manager
					StageManagerHideWidgets = 0;
					StandardHideWidgets = 0;
				};
			};
		};
	};
}
