load test_helper

setup_file() {
    export PYTHONPATH=$(pwd):$PYTHONPATH
    if [[ "$PATH" == *conda/bin* ]]; then
        export CONDA_PRESENT="YES"
    else
        export CONDA_PRESENT="NO"
    fi
}

setup() {
    # Activate the conda environment on each task instead of per-file
    run bash -c "mkdir -p $BATS_RUN_TMPDIR/mycliffapp"
}

teardown() {
    true
}

@test "Cookiecutter templating produces output directory" {
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    $CONDA_PREFIX/bin/python -m cookiecutter \
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
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && make help"
    assert_success
    assert_output --partial "usage: make"
}

@test "Poetry lock works" {
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && poetry lock --no-update"
    assert_success
    assert_output --partial "Writing lock file"
    [[ -f poetry.lock ]]
}

@test "Poetry installs prerequisites properly" {
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && poetry install --no-root"
    assert_success
    assert_output --partial "Installing dependencies from lock file"
}

@test "Package installs properly" {
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && make install-active \
        && pip freeze"
    assert_success
    assert_output --partial "/dist/mycliffapp"
}

@test "Can run script with '--version' flag via python" {
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && PYTHONPATH=$(pwd) $CONDA_PREFIX/bin/python -m mycliffapp --version"
    assert_output --partial "mycliffapp "
}

@test "Can run script with '--version' flag as command" {
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    run bash -c "\
        cd $BATS_RUN_TMPDIR/mycliffapp \
        && mycliffapp --version"
    assert_output --partial "mycliffapp "
}

@test "'tox -e pep8,bandit,bats' in template output directory passes" {
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && tox -e pep8,bandit,bats"
    refute_output --partial "InvocationError"
}

@test "'tox -e py39,py310,py311,docs,pypi' in template output directory passes" {
    [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
    run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && tox -e py39,py310,py311,docs,pypi"
    refute_output --partial "InvocationError"
}

# @test "'make docs' in template output directory passes" {
#     [[ "$CONDA_PRESENT" = "YES" ]] || skip "conda not present"
#     run bash -c "cd $BATS_RUN_TMPDIR/mycliffapp && make docs"
#     assert_success
# }

# vim: set ts=4 sw=4 tw=0 et :
