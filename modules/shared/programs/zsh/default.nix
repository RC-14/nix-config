{ config, pkgs, lib, ... }: {
	enable = true;

	# Whether to enable integration with terminals using the VTE library.
	# This will let the terminal track the current working directory.
	enableVteIntegration = false;

	# Directory where the zsh configuration and more should be located, relative to the users home directory.
	dotDir = ".config/zsh";

	# Automatically enter into a directory if typed directly into shell.
	autocd = false;
	# List of paths to autocomplete calls to cd.
	cdpath = [ ];
	# An attribute set that adds to named directory hash table.
	dirHashes = { };

	autosuggestion.enable = true;
	
	enableCompletion = true;

	# Options related to zsh-syntax-highlighting.
	syntaxHighlighting = {
		enable = true;
		# Highlighters to enable
		# See the list of highlighters: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
		highlighters = [
			"main"
			"brackets"
		];
		# Custom syntax highlighting for user-defined patterns.
		# Reference: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/pattern.md
		patterns = { };
		# Custom styles for syntax highlighting.
		# See each highlighter style option: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
		styles = { };
	};

	# Options related to commands history configuration.
	history = rec {
		# History file location
		path = "$HOME/.zsh_history";

		# Number of history lines to save.
		save = 10000000;
		# Number of history lines to keep.
		size = save;

		# Share command history between zsh sessions.
		share = false;

		# Save timestamp into the history file.
		extended = false;

		expireDuplicatesFirst = false;

		# Do not enter command lines into the history list if the first character is a space.
		ignoreSpace = true;
		# Do not enter command lines into the history list if they are duplicates of the previous event.
		ignoreDups = false;
		# If a new command line being added to the history list duplicates an older one,
		# the older command is removed from the list (even if it is not the previous event).
		ignoreAllDups = true;
		# Do not enter command lines into the history list if they match any one of the given shell patterns.
		ignorePatterns = [ ];
	};

	# Options related to zsh-history-substring-search.
	historySubstringSearch = {
		enable = true;
		# The key codes to be used when searching down.
		# The default of ^[[B may correspond to the DOWN key – if not, try $terminfo[kcud1].
		searchDownKey = [ "^[[B" ];
		# The key codes to be used when searching up.
		# The default of ^[[A may correspond to the UP key – if not, try $terminfo[kcuu1].
		searchUpKey = [ "^[[A" ];
	};

	plugins = [
		{
			name = "powerlevel10k";
			src = pkgs.zsh-powerlevel10k;
			file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
		}
		{
			name = "powerlevel10k-config";
			src = ./powerlevel10k-config;
			file = "p10k.zsh";
		}
	];

	# An attribute set that maps aliases (the top level attribute names in this option) to command strings or directly to build outputs.
	shellAliases = {
		ls = "ls --color=auto";
		l = "ls";
		ll = "ls -lh";
		la = "ls -A";
		lla = "ll -A";
	};

	# Similar to shellAliases, but are substituted anywhere on a line.
	shellGlobalAliases = { };

	# Environment variables that will be set for zsh session.
	sessionVariables = { };

	# Extra local variables defined at the top of .zshrc.
	localVariables = { };
	# Commands that should be added to top of .zshrc.
	initExtraFirst = "";

	# Extra commands that should be added to .zshrc before compinit.
	initExtraBeforeCompInit = "";
	# Initialization commands to run when completion is enabled.
	completionInit = "autoload -U compinit && compinit";

	# Extra commands that should be added to .zshrc.
	initExtra = "";

	# Extra commands that should be added to .zshenv.
	envExtra = "";

	# Extra commands that should be added to .zprofile.
	profileExtra = "";

	# Extra commands that should be added to .zlogin.
	loginExtra = "";

	# Extra commands that should be added to .zlogout.
	logoutExtra = "";
}
