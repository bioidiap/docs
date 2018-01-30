#!/usr/bin/env bash
# Thu 22 Sep 2016 18:23:57 CEST

source $(dirname ${0})/functions.sh

# if the docs will be uploaded to at least one place,
# make sure that the project folder will be available
if [[ ${#DOC_UPLOADS[@]} -gt 0 ]]; then
  dav_recursive_mkdir "${DOC_SERVER_PREFIX}"
fi

# Deletes all existing dav folders that will be overwritten
for k in "${DOC_UPLOADS[@]}"; do
  dav_delete "${k}"
done
