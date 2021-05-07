export OS=$(uname -s)
export PYTHONPATH=$(pwd)
export {{cookiecutter.project_slug.upper()}}="python3 -m {{cookiecutter.project_slug}} --debug"

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# vim: set ts=4 sw=4 tw=0 et :
