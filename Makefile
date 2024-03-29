# Makefile for python_secrets

SHELL:=/bin/bash
VERSION:=$(shell cat VERSION)
PROJECT:=$(shell basename `pwd`)
PYTHON=$(shell which python)

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
	@echo 'docs-tests - generate bats test output for documentation'
	@echo 'docs-help - generate "lim help" output for documentation'
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
	tox -e py36,py37,py38
	$(MAKE) test-bats
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
		if ! type bats 2>/dev/null >/dev/null; then \
			echo "[-] Skipping bats tests"; \
		else \
			echo "[+] Running bats tests: $(shell cd tests && echo [0-9][0-9]*.bats)"; \
			PYTHONWARNINGS="ignore" bats --tap tests/[0-9][0-9]*.bats; \
		fi \
	 fi

#HELP sdist - build a source package
.PHONY: sdist
sdist: clean-docs docs
	rm -f dist/.LATEST_SDIST
	$(PYTHON) setup.py sdist
	ls -t dist/*.tar.gz 2>/dev/null | head -n 1 > dist/.LATEST_SDIST
	ls -l dist/*.tar.gz

#HELP bdist_egg - build an egg package
.PHONY: bdist_egg
bdist_egg:
	rm -f dist/.LATEST_EGG
	$(PYTHON) setup.py bdist_egg
	ls -t dist/*.egg 2>/dev/null | head -n 1 > dist/.LATEST_EGG
	ls -lt dist/*.egg

#HELP bdist_wheel - build a wheel package
.PHONY: bdist_wheel
bdist_wheel:
	rm -f dist/.LATEST_WHEEL
	$(PYTHON) setup.py bdist_wheel
	ls -t dist/*.whl 2>/dev/null | head -n 1 > dist/.LATEST_WHEEL
	ls -lt dist/*.whl

#HELP twine-check
.PHONY: twine-check
twine-check: sdist bdist_egg bdist_wheel
	twine check $(shell cat dist/.LATEST_*)

#HELP clean - remove build artifacts
.PHONY: clean
clean: clean-docs
	$(PYTHON) setup.py clean
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

#HELP docs - build Sphinx docs (NOT INTEGRATED YET FROM OPENSTACK CODE BASE)
.PHONY: docs
docs:
	cd docs && make html


.PHONY: bats-libraries
bats-libraries: bats-core bats-support bats-assert

bats-core:
	@if ! bats --help | grep -q bats-core || [ ! -d tests/libs/bats-core ]; then \
		echo "[+] Cloning bats-core from GitHub"; \
		mkdir -p tests/libs/bats-core; \
		git clone https://github.com/bats-core/bats-core.git tests/libs/bats-core; \
		echo "[+] Installing bats-core in /usr/local with sudo"; \
		sudo tests/libs/bats-core/install.sh /usr/local; \
	 fi


bats-support:
	@[ -d tests/libs/bats-support ] || \
		(mkdir -p tests/libs/bats-support; git clone https://github.com/ztombol/bats-support tests/libs/bats-support)

bats-assert:
	@[ -d tests/libs/bats-assert ] || \
		(mkdir -p tests/libs/bats-assert; git clone https://github.com/ztombol/bats-assert tests/libs/bats-assert)

#EOF
