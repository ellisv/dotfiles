SHELL = /bin/sh
DOTFILES = $(notdir $(wildcard dotfiles/*))

.PHONY: all
all: $(addprefix $(HOME)/., $(DOTFILES)) $(HOME)/.config/ghostty/config

$(HOME)/.%: dotfiles/%
	ln -sf "$(PWD)/$<" "$@"

$(HOME)/.config/ghostty/config: ghostty.config
	mkdir -p $(@D)
	ln -sf "$(PWD)/$<" "$@"
