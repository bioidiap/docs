#!/usr/bin/env bash
# Thu 22 Sep 2016 13:58:56 CEST

source $(dirname ${0})/functions.sh

for file in dist/*.whl; do
  dav_upload ${file} private-upload/wheels/gitlab/
done
