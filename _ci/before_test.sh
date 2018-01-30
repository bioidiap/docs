#!/usr/bin/env bash
# Wed 21 Sep 2016 13:08:05 CEST

source $(dirname ${0})/functions.sh

run_cmd $(dirname ${0})/before_build.sh

prepare_build_env ${CONDA_FOLDER} ${PREFIX} ${CONDA_ENV}

# Verify where pip is installed
use_pip=`which pip`
if [ -z "${use_pip}" ]; then
  log_error "Cannot find pip, aborting..."
  exit 1
else
  log_info "Using pip: ${use_pip}"
fi

# zc.recipe.egg needs some special installation instructions
if [ "${CI_PROJECT_NAME}" == "bob.buildout" ]; then
  run_cmd ${use_pip} install --no-binary ":all:" zc.recipe.egg
fi

run_cmd ${use_pip} install --use-wheel --no-index --pre dist/*.whl

# Downloads databases that may be missing (not shipped with python pkg)
if [ -x ${PREFIX}/bin/bob_dbmanage.py ]; then
  run_cmd ${PREFIX}/bin/bob_dbmanage.py all download --missing;
fi
