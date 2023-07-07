# Makefile for {{cookiecutter.project_name}} ({{cookiecutter.project_slug}})

SHELL:=/bin/bash
VERSION:=$(shell cat VERSION)
CWD:=$(shell pwd)
PROJECT:={{cookiecutter.project_name}}
MODULE:={{cookiecutter.project_slug}}
SLUG_ENV:="{{cookiecutter.project_slug.upper().replace('_', '')}}"
PYTHON=$(shell type -p python)
POETRY_VERSION=1.4.2
# Install bats into same directory tree as poetry, etc.
DOT_LOCAL=~/.local


# Phony target to default action for just typing "make"
.PHONY: default
default: help

.PHONY: help
help:
	@echo 'usage: make [VARIABLE=value] [target [target..]]'
	@echo ''
	@echo 'test - generic target for both "test-tox" and "test-bats"'
	@echo 'test-tox - run tox tests'
	@echo 'test-bats - run Bats unit tests'
	@echo 'test-bats-runtime - run Bats runtime integration/system tests'
	@echo 'build - build package with poetry'
	@echo 'release - produce a pypi production release'
	@echo 'release-test - produce a pypi test release'
	@echo 'release-prep - final documentation preparations for release'

#HELP test - generic target for both "test-tox" and "test-bats"
.PHONY: test
test: test-tox test-bats
	@echo "[+] using $(PYTHON)"
	$(MAKE) test-tox
	$(MAKE) test-bats
	@echo '[+] All tests succeeded'

#HELP test-tox - run tox tests
.PHONY: test-tox
test-tox:
	@# See comment in tox.ini file.
	tox -e pep8,bandit,docs

#HELP test-bats - run Bats unit tests
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
build:
	rm -f dist/.LATEST_WHEEL
	$(DOT_LOCAL)/bin/poetry build
	cd dist && ls -t *.whl 2>/dev/null | head -n 1 > .LATEST_WHEEL
	ls -lt dist/*.whl

#HELP twine-check
.PHONY: twine-check
twine-check: sdist
	twine check dist/"$(shell cat dist/.LATEST_TARGZ)"

#HELP clean - remove build artifacts
.PHONY: clean
clean:
	find . -name '*.pyc' -delete
	rm -rf docs/_build/{html,doctrees}
	rm -f ctu*-cache.json
	rm -rf dist build *.egg-info

#HELP spotless - deep clean
.PHONY: spotless
spotless: clean
	rm -rf .eggs .tox
	(cd docs && make clean)
	rm -rf tests/libs/{bats,bats-support,bats-assert}

#HELP install - install in required Python virtual environment (default $(REQUIRED_VENV))
.PHONY: install
install:
	@if [ ! -d $(VENV_DIR) ]; then \
		echo "Required virtual environment '$(REQUIRED_VENV)' not found."; \
		exit 1; \
	fi
	@if [ ! -e "$(VENV_DIR)/bin/python3" ]; then \
		echo "Cannot find $(VENV_DIR)/bin/python3"; \
		exit 1; \
	else \
		echo "Installing into $(REQUIRED_VENV) virtual environment"; \
		$(VENV_DIR)/bin/python3 -m pip uninstall -y $(PROJECT) 2>/dev/null; \
		$(DOT_LOCAL)/bin/poetry install; \
	fi

#HELP install-active - install in the active Python virtual environment
.PHONY: i
.PHONY: install-active
i install-active:
	$(PYTHON) -m pip uninstall -y $(PROJECT) 2>/dev/null
	$(DOT_LOCAL)/bin/poetry install
	-$(MAKE) docs-help

#HELP install-dependencies - install package dependencies
.PHONY: install-dependencies
install-dependencies: bats-libraries
	$(DOT_LOCAL)/bin/poetry install --with=dev --no-root

#HELP docs-tests - generate bats test output for documentation
.PHONY: docs-tests
PR=pr --omit-header --omit-pagination --page-width 80
docs-tests:
	$(MAKE) -B docs/test-tox.txt
	$(MAKE) -B docs/test-bats.txt
	$(MAKE) -B docs/test-bats-runtime.txt

docs/test-tox.txt:
	(echo '$$ make test-tox' && $(MAKE) test-tox) |\
	       $(PR) | tee docs/test-tox.txt

docs/test-bats.txt:
	$(MAKE) test-bats | $(PR) | tee docs/test-bats.txt

docs/test-bats-runtime.txt:
	(echo '$$ make test-bats-runtime' && $(MAKE) test-bats-runtime) |\
	       $(PR) | tee docs/test-bats-runtime.txt

#HELP docs-help - generate help output for documentation
.PHONY: docs-help
docs-help:
	(export $(SLUG_ENV)_DATA_DIR='/path/to/data'; \
	 export PYTHONPATH=$(CWD); \
	 unset BROWSER; \
	 $(PYTHON) -m $(MODULE) help) > docs/$(PROJECT)-help.txt

#HELP docs - build Sphinx docs (NOT INTEGRATED YET FROM OPENSTACK CODE BASE)
.PHONY: docs
docs: docs-help
	(export $(SLUG_ENV)_DATA_DIR='/path/to/data'; \
	 unset BROWSER; \
	 cd docs && \
	 make clean html)

#HELP examples - produce some example output for docs
.PHONY: examples
examples:
	$(PROJECT) --help

# Git submodules and subtrees are both a huge PITA. This is way simpler.

.PHONY: bats-libraries
bats-libraries: bats-core bats-support bats-assert

bats-core:
	@if ! $(DOT_LOCAL)/bin/bats --help 2>/dev/null | grep -q bats-core || [ ! -d tests/libs/bats-core ]; then \
		echo "[+] Cloning bats-core from GitHub"; \
		mkdir -p tests/libs/bats-core; \
		git clone https://github.com/bats-core/bats-core.git tests/libs/bats-core; \
		echo "[+] Installing bats-core in $(DOT_LOCAL)"; \
		mkdir -p $(DOT_LOCAL)/bin || true; \
		tests/libs/bats-core/install.sh $(DOT_LOCAL); \
	 fi

.PHONY: install-poetry
install-poetry:
	@if [[ "$(shell poetry --version 2>/dev/null)" =~ "$(POETRY_VERSION)" ]]; then \
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
