# lua cli starter
#
# Replace all instances of `app` with your cli's root command
#
# Luastatic command line tool is a prerequisite for this build process
# https://github.com/ers35/luastatic

.PHONY: build

build:
	bash ./scripts/build.sh

install: 
	bash ./scripts/install.sh

uninstall:
	sudo rm /usr/local/bin/app
