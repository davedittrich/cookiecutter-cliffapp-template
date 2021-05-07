export OS=$(uname -s)
export TEMPLATE_SOURCE=$(pwd)
export PYTHONPATH=$(pwd)
export PYTHONEXE=$(which python)

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

eval "$(conda shell.bash hook)"

# vim: set ts=4 sw=4 tw=0 et :
