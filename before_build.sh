
# Clone all packages
for pkg in bob `cat requirements.txt | sed -e '/^\s*#.*/d;/^\s*$/d'`; do
    git clone git@gitlab.idiap.ch:bob/$pkg doc/$pkg || \
    git -C doc/$pkg clean -ffdx && \
    git -C doc/$pkg checkout -- . && \
    git -C doc/$pkg checkout master && \
    git -C doc/$pkg pull
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
