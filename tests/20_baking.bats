load test_helper

setup_file() {
    export PYTHONPATH=$(pwd):$PYTHONPATH
    if [[ "$PATH" == *conda* ]]; then
        export CONDA_PRESENT="YES"
    else
        export CONDA_PRESENT="NO"
    fi
}

setup() {
    # Activate the conda environment on each task instead of per-file
    [[ "$CONDA_DEFAULT_ENV" == "test" ]] || conda activate test
}

teardown() {
    true
}

@test "Conda is set up and functions" {
    [[ "$CONDA_PRESENT" == "YES" ]]
}

@test "Cookiecutter templating works" {
    [[ "$CONDA_PRESENT" == "YES" ]] || skip "conda not present"
    $PYTHONEXE -m cookiecutter \
        --debug-file /tmp/cookiecutter-debug.txt \
		--config-file tests/cookiecutter-test-defaults.yaml \
		--no-input \
		--output-dir $BATS_RUN_TMPDIR/ \
		--overwrite-if-exists \
        $TEMPLATE_SOURCE
    assert_success
    [ -d $BATS_RUN_TMPDIR/limtest ]
}

@test "Makefile in template output directory works" {
    [[ "$CONDA_PRESENT" == "YES" ]] || skip "conda not present"
    run bash -c "cd $BATS_RUN_TMPDIR/limtest && make help"
    assert_success
    assert_output --partial "usage: make"
}

@test "Package installs properly" {
    [[ "$CONDA_PRESENT" == "YES" ]] || skip "conda not present"
    run bash -c "\
        cd $BATS_RUN_TMPDIR/limtest \
        && $PYTHONEXE -m pip install -r requirements.txt \
        && make install-active \
        && pip freeze"
    assert_output --partial "/dist/limtest"
}

@test "Can run script with '--version' flag via python" {
    [[ "$CONDA_PRESENT" == "YES" ]] || skip "conda not present"
    run bash -c "\
        cd $BATS_RUN_TMPDIR/limtest \
        && PYTHONPATH=$(pwd) $PYTHONEXE -m limtest --version"
    assert_output --partial "limtest "
}

@test "Can run script with '--version' flag as command" {
    [[ "$CONDA_PRESENT" == "YES" ]] || skip "conda not present"
    run bash -c "\
        cd $BATS_RUN_TMPDIR/limtest \
        && limtest --version"
    assert_output --partial "limtest "
}

@test "'tox -e pep8,bandit,bats' in template output directory passes" {
    [[ "$CONDA_PRESENT" == "YES" ]] || skip "conda not present"
    run bash -c "cd $BATS_RUN_TMPDIR/limtest && tox -e pep8,bandit,bats"
    refute_output --partial "InvocationError"
}

@test "'tox -e py36,py37,py38,docs,pypi' in template output directory passes" {
    [[ "$CONDA_PRESENT" == "YES" ]] || skip "conda not present"
    run bash -c "cd $BATS_RUN_TMPDIR/limtest && tox -e py36,py37,py38,docs,pypi"
    refute_output --partial "InvocationError"
}

# @test "'make docs' in template output directory passes" {
#     [[ "$CONDA_PRESENT" == "YES" ]] || skip "conda not present"
#     run bash -c "cd $BATS_RUN_TMPDIR/limtest && make docs"
#     assert_success
# }

# vim: set ts=4 sw=4 tw=0 et :