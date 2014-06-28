#!/bin/bash -xe

# Debugging things...
#
# WERCKER_GIT_REPOSITORY=foo-bar
# WERCKER_GIT_BRANCH=master
# WERCKER_VIRTUALENV_PYTHON_LOCATION=/usr/bin/python2.7
# WERCKER_VIRTUALENV_VIRTUALENV_LOCATION=/home/vagrant/venv
# WERCKER_VIRTUALENV_INSTALL_WHEEL=true
# DEPLOY=false

success() {
  echo "${1}"
}

fail() {
  echo "${1}"
 # exit $?
}

warn() {
  echo "${1}"
}

info() {
  echo "${1}"
}

debug() {
  echo "${1}"
}

setMessage() {
  echo "${1}"
}

VIRTUAL_ENV_COMMAND="virtualenv"

if [[ -n "$WERCKER_STEP_ROOT" && $WERCKER_STEP_ROOT != "/wercker/steps/wercker/script/0.0.0" ]]; then
  source "${WERCKER_STEP_ROOT}/support/wercker-functions.sh"
else
  source ./support/wercker-functions.sh
fi

is_python_version || fail "Python not found for path: $WERCKER_VIRTUALENV_PYTHON_LOCATION"
is_exec_python || fail "Python not exec for path: $WERCKER_VIRTUALENV_PYTHON_LOCATION"

is_valid_venv_path || fail "Directory for virtual environment already exists"

is_virtualenv_installed || fail "virtualenv was not found. It probably is not installed?"

$VIRTUAL_ENV_COMMAND --no-site-packages -p $WERCKER_VIRTUALENV_PYTHON_LOCATION $WERCKER_VIRTUALENV_VIRTUALENV_LOCATION

info "Activating virtual enviromnent."
source $WERCKER_VIRTUALENV_VIRTUALENV_LOCATION/bin/activate

mkdir -p $WERCKER_CACHE_DIR/pip-download-cache

info "Enabling generic pip environment variables:"
echo "PIP_DOWNLOAD_CACHE=$WERCKER_CACHE_DIR/pip-download-cache"
export PIP_DOWNLOAD_CACHE=$WERCKER_CACHE_DIR/pip-download-cache

if [ $WERCKER_VIRTUALENV_INSTALL_WHEEL = "true" ]; then

    info "Installing wheel package"
    pip install wheel

    mkdir -p $WERCKER_CACHE_DIR/pip-wheels

    info "Setting wercker wheel enviromnent variable:"
    info "WERCKER_WHEEL_DIR=$WERCKER_CACHE_DIR/pip-wheels"
    export PIP_WHEEL_DIR=$WERCKER_CACHE_DIR/pip-wheels
    echo "Updating"
    echo "PIP_FIND_LINKS=$WERCKER_CACHE_DIR/pip-wheels"
    export PIP_FIND_LINKS=$WERCKER_CACHE_DIR/pip-wheels
    info "Enabling enviromnent variables for pip:"
    info "PIP_USE_WHEEL=true"
    export PIP_USE_WHEEL=true

else
    echo "PIP_FIND_LINKS=$WERCKER_CACHE_DIR/pip-download-cache"
    export PIP_FIND_LINKS=$WERCKER_CACHE_DIR/pip-download-cache
    info "Wheel will not be installed"
fi

