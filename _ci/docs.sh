#!/usr/bin/env bash
# Wed 21 Sep 2016 13:08:05 CEST

source $(dirname ${0})/functions.sh

# Deletes all existing dav folders that will be overwritten
for k in "${DOC_UPLOADS[@]}"; do
  dav_upload_folder sphinx "${k}"
done
