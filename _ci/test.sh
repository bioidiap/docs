#!/usr/bin/env bash
# Wed 21 Sep 2016 13:08:05 CEST

source $(dirname ${0})/functions.sh

prepare_build_env ${CONDA_FOLDER} ${PREFIX}

run_cmd cd ${PREFIX}

# Checks some programs

use_python=`which python`
check_env use_python

use_coverage=`which coverage`
check_env use_coverage

use_nosetests=`which nosetests`
check_env use_nosetests

use_sphinx=`which sphinx-build`
check_env use_sphinx

# The tests:

run_cmd ${use_coverage} run --source=${CI_PROJECT_NAME} ${use_nosetests} -sv ${CI_PROJECT_NAME}
run_cmd ${use_coverage} report
run_cmd ${use_sphinx} -b doctest ${CI_PROJECT_DIR}/doc ${CI_PROJECT_NAME}/sphinx

run_cmd cd ${CI_PROJECT_DIR}
