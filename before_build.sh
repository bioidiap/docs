
# Clone all packages
for pkg in bob `cat requirements.txt | sed -e '/^\s*#.*/d;/^\s*$/d'`; do
    git clone git@gitlab.idiap.ch:bob/$pkg doc/src/$pkg || \
    git -C doc/src/$pkg clean -ffdx && \
    git -C doc/src/$pkg checkout -- . && \
    git -C doc/src/$pkg checkout master && \
    git -C doc/src/$pkg pull
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
    doc/src/*/doc/extra-intersphinx.txt \
    doc/src/*/requirements.txt \
    doc/src/*/test-requirements.txt \
    | sort -u > doc/extra-intersphinx.txt
