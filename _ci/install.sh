#!/usr/bin/env bash
# Thu 22 Sep 2016 13:05:54 CEST

# Installation script for our build tools

if [ "${#}" -eq 0 ]; then
  echo "usage: ${0} <ci-support-directory> [<branch>]"
  echo "example: ${0} _ci"
  echo "example: ${0} _ci staging"
  exit 1
fi

if [ -n "$2" ]; then
  BRANCH=$2;
else
  BRANCH=master;
fi


# Functions for coloring echo commands
log_info() {
  echo -e "(`date +%T`) \033[1;34m${@}\033[0m"
}


log_error() {
  echo -e "(`date +%T`) \033[1;31mError: ${@}\033[0m"
}


# Function for running command and echoing results
run_cmd() {
  log_info "$ ${@}"
  ${@}
  local status=$?
  if [ ${status} != 0 ]; then
    log_error "Command Failed \"${@}\""
    exit ${status}
  fi
}


get_script() {
  local url="https://gitlab.idiap.ch/bob/bob.admin/raw/${BRANCH}/gitlab/${2}"
  local curlopt="--location --silent --show-error --output ${1}/${2}"
  if [ -e ${1}/${2} ]; then
    rm -f ${1}/${2}
  fi
  run_cmd curl ${curlopt} ${url}
}


get_exec() {
  get_script ${1} ${2}
  run_cmd chmod 755 ${1}/${2}
}


run_cmd mkdir -pv ${1}
get_script ${1} cacert.pem
get_script ${1} functions.sh
get_exec ${1} install.sh
for stage in "build" "test" "docs" "wheels" "deploy"; do
  get_exec ${1} before_${stage}.sh
  get_exec ${1} ${stage}.sh
  get_exec ${1} after_${stage}.sh
done
get_exec ${1} update_feedstock.py
