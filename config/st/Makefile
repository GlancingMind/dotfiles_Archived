.POSIX:
.PHONY: clean

st-version := 0.8.2
st-extracted-name := st-${st-version}
st-archive-name := ${st-extracted-name}.tar.gz

all: download build pacman-install

download:
	curl -O https://dl.suckless.org/st/${st-archive-name}
	mkdir -p patches && cd patches \
	&& curl	-O https://st.suckless.org/patches/iso14755/st-iso14755-20180911-67d0cb6.diff \
	 		-O https://st.suckless.org/patches/vertcenter/st-vertcenter-20180320-6ac8c8a.diff \
			-O https://st.suckless.org/patches/xresources/st-xresources-20190105-3be4cf1.diff


build:
	tar -xf ${st-archive-name}
	cd ${st-extracted-name} && patch < ../patches/st-iso14755-20180911-67d0cb6.diff
	cd ${st-extracted-name} && patch < ../patches/st-vertcenter-20180320-6ac8c8a.diff
	cd ${st-extracted-name} && patch < ../patches/st-xresources-20190105-3be4cf1.diff
	make -C ${st-extracted-name} all

pacman-install:
	makepkg -sicC

clean:
	#delete every file except Makefile, PKGBUILD and config.
	find . -maxdepth 1 ! -name . ! -name .. ! -name Makefile ! -name PKGBUILD ! -name config.h -exec rm -r "{}" +

