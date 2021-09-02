---
date: 2021-09-02
title: "vim package management in make"
url: /bits/2021/09/02/vim-package-managment-make.html
---

My [text editor of choice is vim](https://unwiredcouch.com/setup/vim/) and has been for many many years at this point. And while it’s a very configurable editor with all its available plugins, I generally tend to use only a small number of them. Partly because I like being able to have a small and simple setup, and not be slowed down too much when I have to use vim on a different machine or don’t have my setup installed.

Part of this tendency towards simple setups also means that I don’t want to have the management of the few plugins I do use be cumbersome and involving understanding the intricacies of some new tool. And given that vim plugins for the most part also don’t have a ton of dependencies (at least not the ones I use), my needs for managing plugins can be reduced to a small list of requirements:

1. Have plugins I want defined in an authoritative list
2. Have a single command to update plugins to the newest version

## Enter Make
So after having gone through various stages of managing my plugins like git submodules and a ruby script that was doing a lot more than it needed, I was wondering if I could just use one of my favorite tools `make` to do the job for me. After all one of the things it’s really good is, is making sure a defined set of files exists. Which is kinda all that vim plugin management is. And after thinking about this a little bit, I came up with the following things I would need to implement.

1. A way to define a list of plugins with name and URL
2. A way to download all plugins and put them in the right location
3. A way to make sure plugins that don’t exist anymore are removed

So let’s see how this can be done with `make`. First we need to define a list of plugins. This can be easily done by just storing them in variables, e.g.:

	plugin_supertab  := https://github.com/ervandew/supertab/tarball/master
	plugin_syntastic := https://github.com/scrooloose/syntastic/tarball/master
	plugin_fzf       := https://github.com/junegunn/fzf/tarball/master
	plugin_fzf.vim   := https://github.com/junegunn/fzf.vim/tarball/master

This was easy and if you’re wondering about the `plugin_` prefix, you’ve noticed an important part of how to turn this into an easily usable list of plugin definitions. Within 
`make` there exists a meta variable called `.VARIABLES` which contains the list of all defined variables in the current `Makefile`. And since we have chosen a specific prefix for all plugin definitions, we can now get all defined plugins in a programmatic way by filtering all variables with the prefix and then stripping that prefix to get the name we decided to give that plugin via something like:

	# this filters out all variables with a plugin_ prefix and regards them 
	# as plugin definitions
	ALL_DEFINED_PLUGINS := $(filter plugin_%, $(.VARIABLES))
	# from the defined variables list we only extract the name
	ALL_PLUGINS := $(subst plugin_,,$(ALL_DEFINED_PLUGINS))

Now we have a list of plugins (by their names) that we can use to construct a target. I want something easy and nice to type, so I went for a target called `install-plugins`:

	.PHONY: install-plugins
	install-plugins: $(patsubst %, $(PLUGINSDIR)/%, $(ALL_PLUGINS))

The target is `PHONY` because it doesn’t itself describe a file that gets generated, so it’s always "out of date".  But the interesting part of the target is its prerequisites on the right side. There is a path substitution there that defines file targets for all plugins in the plugin directory (I use vim’s built in plugin management, so I have the plugin directory defined as `PLUGINSDIR := pack/plugins/start`). This now means make knows that it needs to create all the files for the generated plugins paths (e.g. `pack/plugins/start/syntastic`) in order to fulfill the `install-plugins` target. However so far there is nothing telling it how to do that and in order to change that, we define a wildcard rule that matches the file path of those plugin definitions:

	$(PLUGINSDIR)/%: $(PLUGINSDIR)
		@echo "Installing $@ from $(plugin_$*)"
		@install -d $@
		@curl -Lfs $(plugin_$*) | tar xz -C $@ --strip-components=1

This rule matches every directory under the plugin path via the wildcard character `%` . And because this is an implicit rule, make provides an automatic variable named `$*` that contains the stem of the match, which in our case is the plugin name. From there we can make sure the directory exists via `install -d $@` (`$@` is an automatic variable that matches the whole target), get the URL for the plugin by reconstructing the original variable we defined for the plugin from the stem (`$(plugin_$*)`)  and then run `curl` and `tar` to unpack the plugin into the newly created directory. You might have noticed that the rule also has a prerequisite on `$(PLUGINSDIR)` on the right side. Which is easily satisfied via this rule:

	$(PLUGINSDIR):
		install -d $@

So now we have all the pieces together to define plugins and install them. However we also want to make sure we don’t keep old plugins around that aren’t defined anymore, or files that were removed from plugins in newer versions. And this is done via deleting the plugins before installing new ones:

	.PHONY: clean-plugins
	clean-plugins:
		rm -rf ./$(PLUGINSDIR)/*

And then we introduce one more convenience task to update plugins by first removing all of them and then installing the ones we want:

	.PHONY: update-plugins
	update-plugins: clean-plugins install-plugins

And with that I can easily update all my vim plugins and commit the update to my dot file repository via the following command sequence:

	make update-plugins
	git add pack/
	git commit -m "update vim plugins"

And the full example of the `Makefile` looks like this:

	PLUGINSDIR := pack/plugins/start
	
	# plugin definitions
	plugin_supertab  := https://github.com/ervandew/supertab/tarball/master
	plugin_syntastic := https://github.com/scrooloose/syntastic/tarball/master
	plugin_fzf       := https://github.com/junegunn/fzf/tarball/master
	plugin_fzf.vim   := https://github.com/junegunn/fzf.vim/tarball/master
	
	# this filters out all variables with a plugin_ prefix and regards them as
	# plugin definitions
	ALL_DEFINED_PLUGINS := $(filter plugin_%, $(.VARIABLES))
	# from the defined variables list we only extract the name
	ALL_PLUGINS := $(subst plugin_,,$(ALL_DEFINED_PLUGINS))
	
	# this will install all plugins via the wildcard matching target below
	.PHONY: install-plugins
	install-plugins: $(patsubst %, $(PLUGINSDIR)/%, $(ALL_PLUGINS))
	
	.PHONY: clean-plugins
	clean-plugins:
		rm -rf ./pack/plugins/start/*
	
	.PHONY: update-plugins
	update-plugins: clean-plugins install-plugins
	
	$(PLUGINSDIR):
		install -d $@
	
	$(PLUGINSDIR)/%: $(PLUGINSDIR)
		@echo "Installing $@ from $(plugin_$*)"
		@install -d $@
		@curl -Lfs $(plugin_$*) | tar xz -C $@ --strip-components=1


## Final words
I’ve been using this way of managing my vim plugins for a while now. And I’m really liking it. It’s small, portable, and easy for me to reason about. I don’t think there will be a need for this to change anytime soon since it’s pretty feature complete for me. From a purely aesthetic perspective it’s not super nice that it removes all plugins every time it runs just to put most of the files back right away. But that doesn’t bother me because it’s fast, reliable, and simple. 

If you’re curious about more of my setup, you can find [my dotfiles on GitHub](https://github.com/mrtazz/dotfiles "mrtazz’s dotfiles on github.com") where I’ve done much more with `make` .