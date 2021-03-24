# Makefile for python_secrets

SHELL=bash
VERSION=$(shell cat VERSION)
PROJECT:=$(shell basename `pwd`)
PYTHON=python3

.PHONY: default
default: test

.PHONY: help
help:
	@echo 'usage: make [VARIABLE=value] [target [target..]]'
	@echo ''
	@echo 'test - run tests exercising cookitcutter templating'
	@echo 'clean - remove build artifacts'
	@echo 'spotless - deep clean'
	@echo 'docs-tests - generate bats test output for documentation'
	@echo 'docs-help - generate "lim help" output for documentation'
	@echo 'docs - build Sphinx docs'

.PHONY: test
test: test-bats
	@echo '[+] All tests succeeded'

.PHONY: test-template
test-template:
	rm -rf /tmp/limtest
	python3 -m cookiecutter \
		--config-file tests/cookiecutter-test-defaults.yaml \
		--no-input \
		--output-dir /tmp \
		--overwrite-if-exists \
		$(shell pwd)

.PHONY: test-bats
test-bats: bats-libraries
	@if [ "$(TRAVIS)" != "true" ]; then \
		if ! type bats 2>/dev/null >/dev/null; then \
			echo "[-] Skipping bats tests"; \
		else \
			echo "[+] Running bats tests: $(shell cd tests && echo [0-9][0-9]*.bats)"; \
			PYTHONWARNINGS="ignore" bats --tap tests/[0-9][0-9]*.bats; \
		fi \
	 fi

#HELP clean - remove build artifacts
.PHONY: clean
clean: clean-docs
	$(PYTHON) setup.py clean
	rm -rf /tmp/limtest
	rm -rf dist build *.egg-info
	find . -name '*.pyc' -delete

.PHONY: clean-docs
clean-docs:
	cd docs && make clean

.PHONY: bats-libraries
bats-libraries: bats-core bats-support bats-assert

bats-core:
	@if [ ! -d tests/libs/bats-core ]; then \
		echo "[+] Cloning bats-core from GitHub"; \
		mkdir -p tests/libs/bats-core; \
		git clone https://github.com/bats-core/bats-core.git tests/libs/bats-core; \
		echo "[+] Installing in /usr/local with sudo"; \
		sudo tests/libs/bats-core/install.sh /usr/local; \
	 fi


bats-support:
	@[ -d tests/libs/bats-support ] || \
		(mkdir -p tests/libs/bats-support; git clone https://github.com/ztombol/bats-support tests/libs/bats-support)

bats-assert:
	@[ -d tests/libs/bats-assert ] || \
		(mkdir -p tests/libs/bats-assert; git clone https://github.com/ztombol/bats-assert tests/libs/bats-assert)

#EOF
