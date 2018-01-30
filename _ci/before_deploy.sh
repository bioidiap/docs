#!/usr/bin/env bash
# Wed 21 Sep 2016 13:08:05 CEST

source $(dirname ${0})/functions.sh

run_cmd $(dirname ${0})/before_test.sh

prepare_build_env ${CONDA_FOLDER} ${PREFIX} ${CONDA_ENV}

# setup database locally and run `bob_dbmanage.py all download`
# if this is a database package - need auxiliary file for package
if [[ ${CI_PROJECT_NAME} == bob.db.* ]]; then
  use_buildout=`which buildout`
  if [ -z "${use_buildout}" ]; then
    log_error "Cannot find buildout, aborting..."
    exit 1
  else
    log_info "Using buildout: ${use_buildout}"
  fi
  run_cmd ${use_buildout}
  if [ -x ./bin/bob_dbmanage.py ]; then
    run_cmd ./bin/bob_dbmanage.py all download --force;
  fi
fi
