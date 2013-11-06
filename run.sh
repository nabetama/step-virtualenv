#!/bin/bash -xe

# Debugging things...
#
# WERCKER_GIT_REPOSITORY=foo-bar
# WERCKER_GIT_BRANCH=master
# WERCKER_VIRTUALENV_PYTHON_PATH=/usr/bin/python2.7
# WERCKER_VIRTUALENV_VIRTUALENV_LOCATION=/home/vagrant/venv
# WERCKER_VIRTUALENV_INSTALL_WHEEL=true
# DEPLOY=false

# success() {
#   echo "${1}"
# }
#
# fail() {
#   echo "${1}"
# }
#
# warn() {
#   echo "${1}"
# }
#
# info() {
#   echo "${1}"
# }
#
# debug() {
#   echo "${1}"
# }
#
# setMessage() {
#   echo "${1}"
# }

VIRTUAL_ENV_COMMAND="virtualenv"

if [[ -n "$WERCKER_STEP_ROOT" && $WERCKER_STEP_ROOT != "/wercker/steps/wercker/script/0.0.0" ]]; then
  source "${WERCKER_STEP_ROOT}/support/wercker-functions.sh"
else
  source ./support/wercker-functions.sh
fi

if [ ! is_python_version ]; then
    fail "Python not found in path: $WERCKER_VIRTUALENV_PYTHON_PATH"
fi

if [ ! is_valid_venv_path ]; then
    fail "Directory for virtual environment already exists"
fi

if [ ! is_virtualenv_installed ]; then
    fail "virtualenv was not found. It probably is not installed?"
fi

$VIRTUAL_ENV_COMMAND --no-site-packages -p $WERCKER_VIRTUALENV_PYTHON_PATH $WERCKER_VIRTUALENV_VIRTUALENV_LOCATION
source $WERCKER_VIRTUALENV_VIRTUALENV_LOCATION/bin/activate

if [ WERCKER_VIRTUALENV_INSTALL_WHEEL = true ]; then
    pip install wheel --find-links=$WERCKER_CACHE_DIR/pip-download-cache
fi

mkdir -p $WERCKER_CACHE_DIR/pip-wheels
mkdir -p $WERCKER_CACHE_DIR/pip-download-cache
