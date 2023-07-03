export OS=$(uname -s)
export TEMPLATE_SOURCE=$(pwd)
export PYTHONPATH=$(pwd):$PYTHONPATH
export ENVPYTHON=${ENVPYTHON:-$(type -p python)}

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

eval "$(conda shell.bash hook)"

# vim: set ts=4 sw=4 tw=0 et :
