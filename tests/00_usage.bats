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
