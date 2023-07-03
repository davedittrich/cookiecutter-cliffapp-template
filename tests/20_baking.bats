#!/usr/bin/env bats

load test_helper

setup_file() {
    true
}

setup() {
    # Activate the conda environment on each task instead of per-file
    run bash -c "mkdir -p $BATS_RUN_TMPDIR/mycliffapp"
}

teardown() {
    true
}

@test "Cookiecutter templating produces output directory" {
    run ${ENVPYTHON} -m cookiecutter \
        --debug-file /tmp/cookiecutter-debug.txt \
		--config-file tests/cookiecutter-test-defaults.yaml \
		--no-input \
		--output-dir $BATS_RUN_TMPDIR/ \
		--overwrite-if-exists \
        $TEMPLATE_SOURCE
    assert_success
    [ -d $BATS_RUN_TMPDIR/mycliffapp ]
    run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && git branch -a"
    assert_output "  develop
* main"
    run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && ls -1"
    assert_output "AUTHORS.rst
LICENSE.txt
Makefile
README.rst
VERSION
bandit.yaml
bin
docs
mycliffapp
pyproject.toml
pytest.ini
secrets.d
setup.cfg
setup.py
tests
tox.ini"
}

@test "Makefile in template output directory works" {
    run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && make help"
    assert_success
    assert_output --partial "usage: make"
}

@test "Poetry lock works" {
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && poetry lock --no-update \
        && [[ -f poetry.lock ]]"
    assert_success
    assert_output --partial "Writing lock file"
}

@test "Poetry installs prerequisites properly" {
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && poetry install --no-root"
    assert_success
    assert_output --partial "Installing dependencies from lock file"
}

@test "Package installs properly" {
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && make install-active \
        && mycliffapp --help"
    assert_success
    assert_output --partial "usage: mycliffapp [--version]"
}

@test "Can run script with '--version' flag via python" {
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && PYTHONPATH=$(pwd) ${ENVPYTHON} -m mycliffapp --version"
    assert_output --partial "mycliffapp "
}

@test "Can run script with '--version' flag as command" {
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && mycliffapp --version"
    assert_output --partial "mycliffapp "
}

@test "'tox -e pep8,bandit,bats' in template output directory passes" {
    run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && tox -e pep8,bandit,bats"
    refute_output --partial "InvocationError"
}

# @test "'tox -e py39,py310,py311,docs,pypi' in template output directory passes" {
#     run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && tox -e py39,py310,py311,docs,pypi"
#     refute_output --partial "InvocationError"
# }

# @test "'make docs' in template output directory passes" {
#     run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && make PYTHON=${ENVPYTHON} docs"
#     assert_success
# }

# vim: set ts=4 sw=4 tw=0 et :
