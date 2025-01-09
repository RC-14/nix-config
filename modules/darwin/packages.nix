{ pkgs, voedl }: with pkgs; let
	shared-packages = import ../shared/packages.nix { inherit pkgs voedl; };
in shared-packages ++ [
	dockutil
]
