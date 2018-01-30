#!/usr/bin/env bash
# Mon  8 Aug 17:40:24 2016 CEST

source $(dirname ${0})/functions.sh

if [ -z "${WHEELS_REPOSITORY}" ]; then
  WHEELS_REPOSITORY="${DOCSERVER}/private/wheels/gitlab/"
  WHEELS_SERVER=`echo ${DOCSERVER} | sed 's;http.*://;;'`
  check_env WHEELS_SERVER
fi
check_env WHEELS_REPOSITORY

prepare_build_env ${CONDA_FOLDER} ${PREFIX} ${CONDA_ENV}

# Verify where pip is installed
use_pip=`which pip`
if [ -z "${use_pip}" ]; then
  log_error "Cannot find pip, aborting..."
  exit 1
else
  log_info "Using pip: ${use_pip}"
fi

use_python=`which python`
if [ -z "${use_python}" ]; then
  log_error "Cannot find python, aborting..."
  exit 1
else
  log_info "Using python: ${use_python}"
fi

# Install this package's build dependencies
PIPOPTS="--find-links ${WHEELS_REPOSITORY}"
if [ ! -z "${WHEELS_SERVER}" ]; then
  PIPOPTS="${PIPOPTS} --trusted-host ${WHEELS_SERVER}"
fi

# When building a tag, do not use beta wheels
PIPOPTS="${PIPOPTS} --use-wheel --no-index"
if [ -z "${CI_COMMIT_TAG}" ]; then
  PIPOPTS="${PIPOPTS} --pre"
fi

if [ -e requirements.txt ]; then
  run_cmd ${use_pip} install ${PIPOPTS} --requirement requirements.txt
else
  log_info "No requirements.txt file found, skipping 'pip install <build-deps>'..."
fi

# Install this package's test dependencies
if [ -e test-requirements.txt ]; then
  run_cmd ${use_pip} install ${PIPOPTS} --requirement test-requirements.txt
else
  log_info "No test-requirements.txt file found, skipping 'pip install <test-deps>'..."
fi
