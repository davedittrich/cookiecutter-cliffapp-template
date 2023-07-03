# Makefile for cookiecutter-cliffapp-template

SHELL:=/bin/bash
VERSION:=$(shell cat VERSION)
PROJECT:=$(shell basename `pwd`)
PYTHON=$(shell type -p python)
POETRY_VERSION=1.4.2
# Install bats into same directory tree as poetry, etc.
DOT_LOCAL=~/.local

.PHONY: default
default: help

.PHONY: help
help:
	@echo 'usage: make [VARIABLE=value] [target [target..]]'
	@echo ''
	@echo 'test - run all tests'
	@echo 'test-tooling - run tests of cookiecutter-cliffapp tooling'
	@echo 'test-baking - run tests for baked cliff app'
	@echo 'test-template - produce /tmp/mycliffapp from template'
	@echo 'clean - remove build artifacts'
	@echo 'spotless - deep clean'
	@echo 'install-dependencies - install package and program dependencies'
	@echo 'install-poetry - install poetry version $(POETRY_VERSION)'
	@echo 'uninstall-poetry - uninstall $(shell (type poetry || echo 'poetry') | sed "s/poetry is //")'
	@echo 'docs-tests - generate bats test output for documentation'
	@echo 'docs - build Sphinx docs'

.PHONY: test
test:
	$(MAKE) test-tooling
	$(MAKE) test-baking
	@echo '[+] All tests succeeded'

.PHONY: test-tooling
test-tooling:
	@# See comment in tox.ini file.
	tox -e pep8

.PHONY: test-baking
test-baking:
	@# See comment in tox.ini file.
	tox -e py39,py310,py311
	@-[[ -f ChangeLog ]] && git checkout ChangeLog || true

.PHONY: test-template
test-template:
	rm -rf /tmp/mycliffapp
	$(PYTHON) -m cookiecutter \
		--config-file tests/cookiecutter-test-defaults.yaml \
		--no-input \
		--output-dir /tmp \
		$(shell pwd)

.PHONY: test-bats
test-bats: bats-libraries
	@if [ "$(TRAVIS)" != "true" ]; then \
		if ! type bats 2>/dev/null >/dev/null || [ ! -f $(DOT_LOCAL)/bin/bats ]; then \
			echo "[-] 'bats' not found: skipping bats tests"; \
		else \
			echo "[+] Running bats tests: $(shell cd tests && echo [0-9][0-9]*.bats)"; \
			PYTHONWARNINGS="ignore" $(DOT_LOCAL)/bin/bats --tap tests/[0-9][0-9]*.bats; \
		fi \
	 fi

#HELP build - build package with poetry
.PHONY: build
build: clean-docs
	rm -f dist/.LATEST_SDIST
	rm -f dist/.LATEST_WHEEL
	$(DOT_LOCAL)/bin/poetry build
	ls -t dist/*.tar.gz 2>/dev/null | head -n 1 > dist/.LATEST_SDIST
	ls -t dist/*.whl 2>/dev/null | head -n 1 > dist/.LATEST_WHEEL
	ls -lt dist/*.whl

#HELP twine-check
.PHONY: twine-check
twine-check: build
	twine check $(shell cat dist/.LATEST_*)

#HELP clean - remove build artifacts
.PHONY: clean
clean: clean-docs
	rm -rf /tmp/mycliffapp
	rm -rf dist build *.egg-info
	find . -name '*.pyc' -delete

.PHONY: clean-docs
clean-docs:
	cd docs && make clean

#HELP spotless - deep clean
.PHONY: spotless
spotless: clean
	rm -rf .eggs .tox
	rm -rf tests/libs/{bats-core,bats-support,bats-assert}

#HELP install-dependencies - install package dependencies
.PHONY: install-dependencies
install-dependencies: install-poetry bats-libraries
	$(DOT_LOCAL)/bin/poetry install --with=dev --no-root

#HELP docs - build Sphinx docs (NOT INTEGRATED YET FROM OPENSTACK CODE BASE)
.PHONY: docs
docs:
	cd docs && make html


.PHONY: bats-libraries
bats-libraries: bats-core bats-support bats-assert

bats-core:
	@if ! $(DOT_LOCAL)/bin/bats --help 2>/dev/null | grep -q Bats || [ ! -d tests/libs/bats-core ]; then \
		echo "[+] Cloning bats-core from GitHub"; \
		mkdir -p tests/libs/bats-core; \
		git clone https://github.com/bats-core/bats-core.git tests/libs/bats-core; \
		echo "[+] Installing bats-core in $(DOT_LOCAL)"; \
		mkdir -p $(DOT_LOCAL)/bin || true; \
		tests/libs/bats-core/install.sh $(DOT_LOCAL); \
	 fi

.PHONY: install-poetry
install-poetry:
	@if [[ "$(shell $(DOT_LOCAL)/bin/poetry --version 2>/dev/null)" =~ "$(POETRY_VERSION)" ]]; then \
		echo "[+] poetry version $(POETRY_VERSION) is already installed"; \
	else \
		(curl -sSL https://install.python-poetry.org | python3 - --version $(POETRY_VERSION)); \
		$(DOT_LOCAL)/bin/poetry self add "poetry-dynamic-versioning[plugin]"; \
	fi
	@if [[ "$(CONDA_DEFAULT_ENV)" == "base" ]]; then \
		echo "[-] refusing to install poetry packages in conda env 'base'"; \
		exit 1; \
	else \
		$(DOT_LOCAL)/bin/poetry install --no-root --with=dev; \
	fi

.PHONY: uninstall-poetry
uninstall-poetry:
	curl -sSL https://install.python-poetry.org | python3 - --version $(POETRY_VERSION) --uninstall

bats-support:
	@[ -d tests/libs/bats-support ] || \
		(mkdir -p tests/libs/bats-support; git clone https://github.com/ztombol/bats-support tests/libs/bats-support)

bats-assert:
	@[ -d tests/libs/bats-assert ] || \
		(mkdir -p tests/libs/bats-assert; git clone https://github.com/ztombol/bats-assert tests/libs/bats-assert)

#EOF
