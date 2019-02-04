CONFIG_DIR = ${XDG_CONFIG_HOME}

ifeq ($(strip CONFIG_DIR),)
CONFIG_DIR = ${HOME}/.config
endif

.PHONY: repl build

install:
	stow --verbose --dir=$(shell pwd) --target=${CONFIG_DIR} config

remove:
	stow --verbose --delete --dir=$(shell pwd) --target=${CONFIG_DIR} config
