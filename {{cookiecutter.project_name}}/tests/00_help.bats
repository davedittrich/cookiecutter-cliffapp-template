load test_helper

setup() {
    true
}

teardown() {
    true
}

@test "\"{{cookiecutter.project_name}} about\" contains \"version\"" {
    run bash -c "${{cookiecutter.project_slug.upper()}} about"
    assert_output --partial 'version'
}

@test "'{{cookiecutter.project_name}} help' can load all entry points" {
    run bash -c "${{cookiecutter.project_slug.upper()}} help 2>&1"
    refute_output --partial "Could not load EntryPoint"
}

@test "'{{cookiecutter.project_name}} --version' works" {
    run ${{cookiecutter.project_slug.upper()}} --version
    assert_output --partial "{{cookiecutter.project_name}} "
}

# vim: set ts=4 sw=4 tw=0 et :
