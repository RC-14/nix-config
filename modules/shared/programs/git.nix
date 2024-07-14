{ name, email, ... }: {
	enable = true;
	ignores = [ ".DS_Store" ];
	userName = name;
	userEmail = email;
	lfs.enable = true;
	extraConfig = {
		init.defaultBranch = "main";
		core = {
			editor = "vim";
		};
		pull.rebase = true;
	};
	aliases = {
		# Undo the last commit, keeping all files and changes
		shit = "reset --soft HEAD~1";
		# Reset files to the state of the current commit. Does not delete untracked files, use clean -i for that.
		wipe = "reset --hard";
	};
}
