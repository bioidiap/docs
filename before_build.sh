
# Clone all packages
for pkg in `cat requirements.txt | sed -e '/^\s*#.*/d;/^\s*$/d'`; do
    git clone git@gitlab.idiap.ch:bob/$pkg doc/src/$pkg
done

# Create extra-intersphinx.txt
# Add newlines in the end of files
# remove bobs
# remove comments
# remove trailing whitespace
sed -e '$s/$/\n/' \
    -e '/^bob/d' \
    -e 's:#.*$::g' \
    -e 's/[[:space:]]*$//' \
    -s \
    doc/src/*/doc/extra-intersphinx.txt \
    doc/src/*/requirements.txt \
    doc/src/*/test-requirements.txt \
    | sort -u > doc/extra-intersphinx.txt
