#!/usr/bin/env bash
# Wed 21 Sep 2016 13:08:05 CEST

source $(dirname ${0})/functions.sh

prepare_build_env ${CONDA_FOLDER} ${PREFIX}

use_buildout=`which buildout`
if [ -z "${use_buildout}" ]; then
  log_error "Cannot find buildout, aborting..."
  exit 1
else
  log_info "Using buildout: ${use_buildout}"
fi

run_cmd ${use_buildout}

# if [ -x ./bin/bob_dbmanage.py ]; then
#   run_cmd ./bin/bob_dbmanage.py all download --missing;
# fi

if [ -d ./doc ] && [ "${STABLE}" != "true" ]; then
  run_cmd ./bin/sphinx-build doc sphinx
fi
