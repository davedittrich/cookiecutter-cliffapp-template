load test_helper

setup() {
    true
}

teardown() {
    true
}

@test "\"{{cookiecutter.project_slug}} about\" contains \"version\"" {
    run bash -c "${{cookiecutter.project_slug.upper()}} about"
    assert_output --partial 'version'
}

@test "'{{cookiecutter.project_slug}} help' can load all entry points" {
    run bash -c "${{cookiecutter.project_slug.upper()}} help 2>&1"
    refute_output --partial "Could not load EntryPoint"
}

@test "\"lim cafe --help\" properly lists subcommands" {
    run bash -c "$LIM cafe --help"
    assert_output 'Command "{{cookiecutter.project_slug}}" matches:
  {{cookiecutter.project_slug}} about'
}

@test "'{{cookiecutter.project_slug}} --version' works" {
    run ${{cookiecutter.project_slug.upper()}} --version
    assert_output --partial "{{cookiecutter.project_slug}} "
}

# vim: set ts=4 sw=4 tw=0 et :
