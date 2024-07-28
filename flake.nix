{
	description = "My Nix Configuration";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		agenix = {
			url = "github:ryantm/agenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		darwin = {
			url = "github:LnL7/nix-darwin/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
		homebrew-bundle = {
			url = "github:homebrew/homebrew-bundle";
			flake = false;
		};
		homebrew-core = {
			url = "github:homebrew/homebrew-core";
			flake = false;
		};
		homebrew-cask = {
			url = "github:homebrew/homebrew-cask";
			flake = false;
		}; 
		homebrew-wine = {
			url = "github:Gcenx/homebrew-wine";
			flake = false;
		};

		mac-app-util.url = "github:hraban/mac-app-util";

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		secrets = {
			url = "git+ssh://git@github.com/RC-14/nix-secrets.git";
			flake = false;
		};
	};
	outputs = { self, nixpkgs, agenix, home-manager, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, homebrew-wine, mac-app-util, disko, secrets } @inputs: let
		user = "rc-14";
		linuxSystems = [
			# "x86_64-linux"
			# "aarch64-linux"
		];
		darwinSystems = [
			"aarch64-darwin"
			# "x86_64-darwin"
		];
		forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
		devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
			default = with pkgs; mkShell {
				nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
				shellHook = with pkgs; ''
					export EDITOR=vim
				'';
			};
		};
		mkApp = scriptName: system: let pkgs = nixpkgs.legacyPackages.${system}; in {
			type = "app";
			program = "${(pkgs.writeScriptBin scriptName ''
#!/usr/bin/env bash
PATH=${pkgs.git}/bin:${pkgs.nix-output-monitor}/bin:$PATH
echo "Running ${scriptName} for ${system}"
exec ${self}/apps/${system}/${scriptName}
			'')}/bin/${scriptName}";
		};
		mkLinuxApps = system: {
			"apply" = mkApp "apply" system;
			"build-switch" = mkApp "build-switch" system;
			"copy-keys" = mkApp "copy-keys" system;
			"create-keys" = mkApp "create-keys" system;
			"check-keys" = mkApp "check-keys" system;
			"install" = mkApp "install" system;
			"install-with-secrets" = mkApp "install-with-secrets" system;
		};
		mkDarwinApps = system: {
			"apply" = mkApp "apply" system;
			"build" = mkApp "build" system;
			"build-switch" = mkApp "build-switch" system;
			"copy-keys" = mkApp "copy-keys" system;
			"create-keys" = mkApp "create-keys" system;
			"check-keys" = mkApp "check-keys" system;
			"rollback" = mkApp "rollback" system;
		};
	in {
		devShells = forAllSystems devShell;
		apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

		darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
			darwin.lib.darwinSystem {
				inherit system;
				specialArgs = inputs;
				modules = [
					mac-app-util.darwinModules.default

					home-manager.darwinModules.home-manager
					{ home-manager.sharedModules = [ mac-app-util.homeManagerModules.default ]; }

					nix-homebrew.darwinModules.nix-homebrew
					{
						nix-homebrew = {
							inherit user;
							enable = true;
							enableRosetta = true;
							taps = {
								"homebrew/homebrew-core" = homebrew-core;
								"homebrew/homebrew-cask" = homebrew-cask;
								"homebrew/homebrew-bundle" = homebrew-bundle;
								"gcenx/homebrew-wine" = homebrew-wine;
							};
							mutableTaps = false;
							autoMigrate = true;
						};
					}

					./hosts/darwin
				];
			}
		);
	};
}
