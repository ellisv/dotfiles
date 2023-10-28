SHELL = /bin/sh
DOTFILES = $(notdir $(wildcard dotfiles/*))

.PHONY: all
all: $(addprefix $(HOME)/., $(DOTFILES))

$(HOME)/.%: dotfiles/%
	ln -sf "$(PWD)/$<" "$@"
