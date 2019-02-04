CONFIG_DIR = ${XDG_CONFIG_HOME}

ifeq ($(strip CONFIG_DIR),)
CONFIG_DIR = ${HOME}/.config
endif

.PHONY: repl build

install-config:
	stow --verbose --dir=$(shell pwd) --target=${CONFIG_DIR} config

remove-config:
	stow --verbose --delete --dir=$(shell pwd) --target=${CONFIG_DIR} config

install-helpers:
	stow --verbose --dir=$(shell pwd) --target=/usr/local/bin helper-scripts

remove-helpers:
	stow --verbose --delete --dir=$(shell pwd) --target=/usr/local/bin helper-scripts
