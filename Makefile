# standup
#
# Brain dumping on the command line
#
# Luastatic command line tool is a prerequisite for this build process
# https://github.com/ers35/luastatic

.PHONY: build clean install install-local run-local uninstall

build:
	bash ./scripts/build.sh

clean:
	rm -rf ~/.standup
	./build/standup init

install: 
	bash ./scripts/install.sh

install-local:
	bash ./scripts/install.sh --local

run-local:
	./build/standup --help

uninstall:
	sudo rm /usr/local/bin/standup
