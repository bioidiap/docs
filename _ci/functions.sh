#!/usr/bin/env bash
# Thu 22 Sep 2016 13:05:54 CEST

# Build utilities
SCRIPTS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Determines the operating system we're using
osname() {
  [[ "$(uname -s)" == "Darwin" ]] && echo "macosx" || echo "linux"
}

# Determines the visibility of the current package
visibility() {
  local code=$(curl --output /dev/null --silent --fail --write-out "%{http_code}" ${CI_PROJECT_URL})
  [[ ${code} == *200 ]] && echo "public" || echo "private"
}


# Determines if we're on the master branch or not
is_master() {
  local retval="${CI_COMMIT_REF_NAME}"
  if [[ -n "${CI_COMMIT_TAG}" ]]; then
    # we're building a tag, check it is available on the master branch
    local count=`git branch -a --contains "tags/${CI_COMMIT_TAG}" | grep master | wc -l`
    if [[ "${count}" -gt "0" ]]; then #tag is on master
      retval="master"
    else
      retval="it-is-not-master"
    fi
  fi
  if [[ "${retval}" == "master" ]]; then
    echo "true"
  else
    echo "false"
  fi
}


# Checks whether to use "date" or "gdate"
gnudate() {
  if hash gdate 2>/dev/null; then
    echo gdate
  else
    echo date
  fi
}
DATE=`gnudate`


# datetime prefix for logging
log_datetime() {
	echo "($(${DATE} +%T.%3N))"
}

# Functions for coloring echo commands
log_debug() {
  echo -e "$(log_datetime) \033[1;32m${@}\033[0m"
}


log_info() {
  echo -e "$(log_datetime) \033[1;34m${@}\033[0m"
}


log_warn() {
  echo -e "$(log_datetime) \033[1;35mWarning: ${@}\033[0m" >&2
}


log_error() {
  echo -e "$(log_datetime) \033[1;31mError: ${@}\033[0m" >&2
}


# Checks a given environment variable is set (non-zero size)
check_env() {
  if [ -z "${1+abc}" ]; then
    log_error "Variable ${1} is undefined - aborting...";
    exit 1
  else
    log_info "${1}=${!1}";
  fi
}


# Exports a given environment variable, verbosely
export_env() {
  if [ -z "${1+abc}" ]; then
    log_error "Variable ${1} is undefined - aborting...";
    exit 1
  else
    export ${1}
    log_info "export ${1}=${!1}";
  fi
}


# Checks a given environment variable is set (non-zero size)
check_pass() {
  if [ -z "${1+abc}" ]; then
    log_error "Variable ${1} is undefined - aborting...";
    exit 1
  else
    log_info "${1}=********";
  fi
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


# Uploads a file to our intranet location via curl
# $1: Path to the file to upload (e.g. dist/myfile.whl)
# $2: Path on the server to upload to (e.g. private-upload/wheels/gitlab/)
dav_upload() {
  if [ ! -e $1 ]; then
    log_error "File \`${1}\' does not exist on the local disk"
    exit 1
  fi

  local code=`curl --location --silent --fail --write-out "%{http_code}" --user "${DOCUSER}:${DOCPASS}" --upload-file ${1} ${DOCSERVER}/${2}`
  if [[ ${code} == *204 || ${code} == *201 ]]; then
    log_info "curl: cp ${1} -> ${DOCSERVER}/${2}"
  else
    log_error "Curl command finished with an error condition (code=${code}):"
    curl --location --silent --user "${DOCUSER}:${DOCPASS}" --upload-file ${1} ${DOCSERVER}/${2}
    exit ${code}
  fi
}


# Creates a folder at our intranet location via curl
# $1: Path of the folder to create (e.g. private-upload/docs/test-folder)
# $2: which HTTP response code it should return instead of exit on (e.g. 405 means the folder already exists)
dav_mkdir() {
  local code=$(curl --location --silent --fail --write-out "%{http_code}" --user "${DOCUSER}:${DOCPASS}" -X MKCOL "${DOCSERVER}/${1}")

  if [[ ${code} == *204 || ${code} == *201 ]]; then
    log_info "curl: mkdir ${DOCSERVER}/${1}"
  # if the return code was not a success, the function should usually treat it as an error.
  # however, sometimes the codes must be treated more flexibly, e.g.:
  # dav_recursive_mkdir wants the directory created *or* already existing,
  # which means that a 405 (directory already exists) should not be treated as an error.
  # other codes may also have similar consideration in the future.
  elif [[ "${code}" == "$2" ]]; then
    return "${code}"
  else
    log_error "Curl command finished with an error condition (code=${code}):"
    curl --location --silent --user "${DOCUSER}:${DOCPASS}" -X MKCOL "${DOCSERVER}/${1}"
    exit "${code}"
  fi
}


# Creates a folder and all parent folders at a intranet location via curl (mkdir -p)
# $1: Path of a folder to guarantee to be writeable (e.g. private-upload/docs/bob/bob.admin)
dav_recursive_mkdir() {
  log_info "curl: mkdir -p ${DOCSERVER}/${1}"

  # split path into an array of path segments
  # uses a subshell so setting the IFS doesnt mess up *this* shell
  IFS=/ read -a path_segments <<< "$1"
  local current_subpath=''

  # loop through segments
  for seg in "${path_segments[@]}"; do
    # append each segment to the current subpath
    current_subpath="${current_subpath}${seg}/"
    log_info "mkdir $DOCSERVER/$current_subpath"

    # make sure the current subpath folder is created
    # a 405 exit code is returned when the folder already exists
    dav_mkdir "$current_subpath" 405
    log_info "Directory ${current_subpath} (now) exists."
  done
}


# Deletes a file/folder from our intranet location via curl
# $1: Path to the file/folder to delete (e.g. dist/myfile.whl)
dav_delete() {
  log_info "curl: exists ${DOCSERVER}/${1}?"

  # checks if the directory exists before trying to remove it (use --head)
  local code=$(curl --location --silent --fail --write-out "%{http_code}" --head --user "${DOCUSER}:${DOCPASS}" "${DOCSERVER}/$1")
  if [[ ${code} == *404 ]]; then
    log_info "Directory ${DOCSERVER}/$1 does not exist. Skipping deletion"
    return 0
  fi

  code=$(curl --location --silent --fail --write-out "%{http_code}" --user "${DOCUSER}:${DOCPASS}" -X DELETE "${DOCSERVER}/$1")

  if [[ ${code} == *204 || ${code} == *201 ]]; then
    log_info "curl: rm -rf ${DOCSERVER}/${1}"
  else
    log_error "Curl command finished with an error condition (code=${code}):"
    curl --location --silent --user "${DOCUSER}:${DOCPASS}" -X DELETE "${DOCSERVER}/$1"
    exit "${code}"
  fi
}


# Uploads a folder and all contents recursively to our intranet location via curl
# $1: Path to the folder to upload (e.g. test-folder/)
# $2: Path on the server to upload to (e.g. private-upload/docs/test/ to put contents of test-folder/ in test/)
dav_upload_folder() {
  log_info "curl: cp -r ${1} -> ${DOCSERVER}/${2}..."

  if [ ! -e $1 ]; then
    log_error "Directory \`${1}\' does not exist on the local disk"
    exit 1
  fi

  find "$1" | while read -r fname; do
    # replace the local path prefix ('../folder1/folder2/folder-to-upload/')
    # with the server path prefix ('private-upload/docs/test/')
    # to make something like '../folder1/folder2/folder-to-upload/test.txt'
    # into 'private-upload/docs/test.txt'
    local server_prefix="${2%?}" #without ending slash
    local server_path="${fname/$1/$server_prefix}"

    # if its a file...
    if [[ -f "${fname}" ]]; then
      # upload the file ...
      dav_upload "${fname}" "${server_path}"
    else
      # if its a dir, create the dir
      dav_mkdir "${server_path}"
    fi
  done
}


# Creates (clones), Activates environment and sets up compilation
# $1: root of the conda installation
# $2: your current build prefix
# $3: the name of the conda environment to clone
prepare_build_env() {

  # Readies a conda environment to use for installation
  if [ ! -d $2 ]; then
    log_info "Creating conda installation at $2..."
    run_cmd $1/bin/conda create --clone $3 --prefix $2 --yes
  else
    log_info "Prefix directory $2 exists, not re-installing..."
  fi

  # Activates conda environment for the build
  log_info "$ source $1/bin/activate $2"
  source $1/bin/activate $2

  # Configures CCACHE
  # use_ccache=`which ccache`
  # if [ -z "${use_ccache}" ]; then
  #   log_warn "Cannot find ccache, compiling from scratch..."
  # else
  #   local ccache_bin=$2/lib/ccache
  #   if [ ! -d ${ccache_bin} ]; then
  #     run_cmd mkdir -pv ${ccache_bin}
  #     ln -sf ${use_ccache} ${ccache_bin}/gcc
  #     ln -sf ${use_ccache} ${ccache_bin}/g++
  #     ln -sf ${use_ccache} ${ccache_bin}/cc
  #     ln -sf ${use_ccache} ${ccache_bin}/c++
  #   fi
  #   use_gcc=`which gcc`
  #   PATH=${ccache_bin}:${PATH}
  #   export_env PATH
  #   log_info "ccache installed at ${use_ccache}, caching compilations..."
  #   log_info "gcc installed at ${use_gcc}..."
  # fi
}


# Checks if an array contains a value
# taken from here: https://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
# Parameters: <value-to-check> <array-variable>
# Usage: "a string" "${array[@]}"
contains_element () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}


check_env PYTHON_VERSION
check_env CI_PROJECT_URL
check_env CI_PROJECT_DIR
check_env CI_PROJECT_PATH
check_env CI_PROJECT_NAME
check_env CI_COMMIT_REF_NAME
check_pass PYPIUSER
check_pass PYPIPASS
check_pass DOCUSER
check_pass DOCPASS

# Sets up variables
OSNAME=`osname`
VISIBILITY=`visibility`
IS_MASTER=`is_master`

if [ -z "${CONDA_FOLDER}" ]; then
  CONDA_FOLDER=/opt/conda
fi

PYVER=py$(echo ${PYTHON_VERSION} | tr -d '.')
if [ -z "${CONDA_ENV}" ]; then
  if [ -d "${CONDA_FOLDER}/envs/bob-devel-${PYVER}-${CI_COMMIT_REF_NAME}" ]; then
    CONDA_ENV=bob-devel-${PYVER}-${CI_COMMIT_REF_NAME}
  else
    CONDA_ENV=bob-devel-${PYVER}
  fi
fi
BOB_PREFIX_PATH=${CONDA_FOLDER}/envs/${CONDA_ENV}

if [ -z "${DOCSERVER}" ]; then
  DOCSERVER=http://www.idiap.ch
  export_env DOCSERVER
fi

if [ -z "${PREFIX}" ]; then
  PREFIX=${CI_PROJECT_DIR}/build-prefix
fi

check_env OSNAME
check_env VISIBILITY
check_env IS_MASTER
check_env PYVER
check_env PREFIX
export_env PREFIX
check_env DOCSERVER
check_env CONDA_FOLDER
check_env CONDA_ENV
export_env BOB_PREFIX_PATH

# Setup default documentation server
if [ -z "${CI_COMMIT_TAG}" ]; then
  DEFSRV="${DOCSERVER}/software/bob/docs/bob/%(name)s/master/"
else
  DEFSRV="${DOCSERVER}/software/bob/docs/bob/%(name)s/%(version)s/|${DOCSERVER}/software/bob/docs/bob/%(name)s/stable/|http://pythonhosted.org/%(name)s/"
fi
if [ -z "${BOB_DOCUMENTATION_SERVER}" ]; then
  BOB_DOCUMENTATION_SERVER="${DEFSRV}"
else
  BOB_DOCUMENTATION_SERVER="${BOB_DOCUMENTATION_SERVER}|${DEFSRV}"
fi
if [ "${VISIBILITY}" != "public" ]; then
  # If private or internal, allow it to depend on other internal documents
  if [ -z "${CI_COMMIT_TAG}" ]; then
    BOB_DOCUMENTATION_SERVER="${BOB_DOCUMENTATION_SERVER}|${DOCSERVER}/private/docs/bob/%(name)s/master/"
  else
    BOB_DOCUMENTATION_SERVER="${BOB_DOCUMENTATION_SERVER}|${DOCSERVER}/private/docs/bob/%(name)s/%(version)s/|${DOCSERVER}/private/docs/bob/%(name)s/stable/"
  fi
fi
unset DEFSRV
export_env BOB_DOCUMENTATION_SERVER

# Sets up certificates for curl and openssl
CURL_CA_BUNDLE="${SCRIPTS_DIR}/cacert.pem"
export_env CURL_CA_BUNDLE
SSL_CERT_FILE="${CURL_CA_BUNDLE}"
export_env SSL_CERT_FILE

# Sets up upload folders for documentation (just in case we need them)
# See: https://gitlab.idiap.ch/bob/bob.admin/issues/2

# Prefix differs between private & public repos
DOC_SERVER_PREFIX="-upload/docs/${CI_PROJECT_PATH}"
if [[ "${VISIBILITY}" == "public" ]]; then
  DOC_SERVER_PREFIX="public${DOC_SERVER_PREFIX}"
else
  DOC_SERVER_PREFIX="private${DOC_SERVER_PREFIX}"
fi

DOC_UPLOADS=()

if [[ "${IS_MASTER}" == "true" ]]; then
  DOC_UPLOADS+=("${DOC_SERVER_PREFIX}/master/")
fi

if [[ -n "${CI_COMMIT_TAG}" ]]; then
  DOC_UPLOADS+=("${DOC_SERVER_PREFIX}/${CI_COMMIT_TAG}/")
fi

if [[ -n "${CI_COMMIT_TAG}" && "${IS_MASTER}" == "true" ]]; then
  DOC_UPLOADS+=("${DOC_SERVER_PREFIX}/stable/")
fi

export_env DOC_SERVER_PREFIX
check_env DOC_UPLOADS

# Sets up the language so Unicode filenames are considered correctly
LANG="en_US.UTF-8"
LC_ALL="${LANG}"
export_env LANG
export_env LC_ALL
