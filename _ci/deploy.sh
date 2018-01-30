#!/usr/bin/env bash
# Wed 11 Oct 2017 15:00:21 CEST

source $(dirname ${0})/functions.sh

# upload documentation on our internal server
run_cmd $(dirname ${0})/before_docs.sh
run_cmd $(dirname ${0})/docs.sh
run_cmd $(dirname ${0})/after_docs.sh

if [ "${VISIBILITY}" != "public" ]; then
  log_warn "WARNING: You cannot publish a PRIVATE to PyPI"
  log_warn "WARNING: Make this package public if you wish to do so next time"
  log_warn "WARNING: Stopping deployment procedure before PyPI/Conda pushes"
  exit 0
fi

log_info "Creating source distribution..."
run_cmd ${PREFIX}/bin/python setup.py check sdist --formats zip

log_info "Uploading package to ${PYPISERVER} on behalf of ${PYPIUSER}..."
twine upload --username ${PYPIUSER} --password ${PYPIPASS} dist/*.zip

condaforge_packages=("bob" \
"bob.buildout" \
"bob.extension" \
"bob.blitz" \
"bob.core" \
"bob.ip.draw" \
"bob.io.base" \
"bob.sp" \
"bob.math" \
"bob.ap" \
"bob.measure" \
"bob.db.base" \
"bob.io.image" \
"bob.io.video" \
"bob.io.matlab" \
"bob.ip.base" \
"bob.ip.color" \
"bob.ip.gabor" \
"bob.learn.activation" \
"bob.learn.libsvm" \
"bob.learn.boosting" \
"bob.io.audio" \
"bob.learn.linear" \
"bob.learn.mlp" \
"bob.db.wine" \
"bob.db.mnist" \
"bob.db.atnt" \
"bob.ip.flandmark" \
"bob.ip.facedetect" \
"bob.ip.optflow.hornschunck" \
"bob.ip.optflow.liu" \
"bob.learn.em" \
"bob.db.iris" \
"bob.ip.qualitymeasure" \
"bob.ip.tensorflow_extractor" \
"bob.bio.vein")

if contains_element ${CI_PROJECT_NAME}  "${condaforge_packages[@]}"; then
  run_cmd ${CONDA_FOLDER}/bin/python _ci/update_feedstock.py ${CI_PROJECT_NAME} recipes
else
  run_cmd ${CONDA_FOLDER}/bin/python _ci/update_feedstock.py ${CI_PROJECT_NAME} skeleton
fi
