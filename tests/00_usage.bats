load test_helper

setup_file() {
    export PYTHONPATH=$(pwd):$PYTHONPATH
    if [[ "$PATH" == *conda* ]]; then
        export CONDA_PRESENT="YES"
        [[ "$CONDA_DEFAULT_ENV" == "test" ]] || conda activate test
    else
        export CONDA_PRESENT="NO"
    fi
}

setup() {
    true
}

teardown() {
    true
}

@test "No-op usage test" {
    true
    assert_success
}

# vim: set ts=4 sw=4 tw=0 et :
