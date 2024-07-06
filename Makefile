# standup
#
# Brain dumping on the command line
#
# Luastatic command line tool is a prerequisite for this build process
# https://github.com/ers35/luastatic

.PHONY: build

build:
	bash ./scripts/build.sh

install: 
	bash ./scripts/install.sh

run-local:
	./build/standup --help

uninstall:
	sudo rm /usr/local/bin/standup
