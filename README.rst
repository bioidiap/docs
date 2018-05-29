******************************************
Bob's Documentation Aggregation Repository
******************************************

This repository will build the documentation of all Bob packages at the same
time.

Adding a new package
====================

To add a new package:

* Make sure the package is **public** first. Do not add private packages here.
* Add it in ``conda/meta.yaml`` and ``requirements.txt``.
* Add it in ``doc/index.rst`` (you need to add it in several places in this file).
* Add it in ``doc/readme_index.rst``.
* Add it in ``.gitignore``.
* If it plots something using matplotlib during its documentation generation,
  make sure you add a symlink for it in the docs folder.

Test this package (build the documentation)
===========================================

The steps to test this package is similar to other bob packages except that you
need to run the `before_build.sh` script before testing. Checkout bob.admin in
an upper folder and make sure its repository is up-to-date. Then, run::

    $ ./before_build.sh
    $ conda activate base
    $ ../bob.admin/conda/conda-build.sh --python=3 conda

See https://gitlab.idiap.ch/bob/bob/wikis/Save-the-CI-time for up-to-date
instructions.
