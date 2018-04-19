#!/usr/bin/env bash

set -ex

# to fix cloning in docker images
GITLAB_CHECKOUT_STRATEGY="${GITLAB_CHECKOUT_STRATEGY:-git@gitlab.idiap.ch:}"

# Clone all packages
for pkg in bob `cat requirements.txt | sed -e '/^\s*#.*/d;/^\s*$/d'`; do
    git clone --depth 1 ${GITLAB_CHECKOUT_STRATEGY}bob/$pkg doc/$pkg || \
    { git -C doc/$pkg reset --hard HEAD && \
    git -C doc/$pkg checkout master && \
    git -C doc/$pkg pull }
    if [[ -n "${CI_COMMIT_TAG}" ]]; then
      tag=`git -C doc/$pkg tag -l --sort=v:refname | tail -n 1`
      git -C doc/$pkg checkout $tag
    fi
done

# Create extra-intersphinx.txt
# Add newlines in the end of files
# remove bobs, gridtk
# remove comments
# remove trailing whitespace
sed -e '$s/$/\n/' \
    -e '/^bob/d' \
    -e '/^gridtk/d' \
    -e 's:#.*$::g' \
    -e 's/[[:space:]]*$//' \
    -s \
    doc/*/doc/extra-intersphinx.txt \
    doc/*/requirements.txt \
    doc/*/test-requirements.txt \
    | sort -u > doc/extra-intersphinx.txt

# Create nitpick-exceptions.txt
# Add newlines in the end of files
# remove comments
# remove trailing whitespace
sed -e '$s/$/\n/' \
    -e 's:#.*$::g' \
    -e 's/[[:space:]]*$//' \
    -s \
    doc/*/doc/nitpick-exceptions.txt \
    | sort -u > doc/nitpick-exceptions.txt
