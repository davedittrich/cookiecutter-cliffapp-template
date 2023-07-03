#!/usr/bin/env bats

load test_helper

setup_file() {
    true
}

setup() {
    true
}

teardown() {
    true
}

@test "Verify Python version" {
    run ${ENVPYTHON} --version
    [ "$status" -eq 0 ]
}

@test "No-op usage test" {
    true
    assert_success
}

# vim: set ts=4 sw=4 tw=0 et :
