SHELL = /bin/sh
DOTFILES = $(notdir $(wildcard dotfiles/*))
FONTS = $(notdir $(wildcard fonts/*.otf))
FONT_CONFIGS = $(notdir $(wildcard fonts/*.conf))
FONT_DIR = /usr/share/fonts
FONT_CONFIG_DIR = /etc/fonts/conf.d

.PHONY: all
all: $(addprefix $(HOME)/., $(DOTFILES))

$(HOME)/.%: dotfiles/%
	ln -sf "$(PWD)/$<" "$@"

.PHONY: setupfonts
setupfonts: $(addprefix $(FONT_DIR)/, $(FONTS)) $(addprefix $(FONT_CONFIG_DIR)/, $(FONT_CONFIGS))

.PHONY: fontcache
fontcache:
	fc-cache -vf $(HOME)/usr/share/fonts/

$(FONT_DIR)/%.otf: fonts/%.otf
	cp -f "$<" "$@"

$(FONT_CONFIG_DIR)/%.conf: fonts/%.conf
	cp -f "$<" "$@"
