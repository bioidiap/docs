******************************************
Bob's Documentation Aggregation Repository
******************************************

This repository will build the documentation of all Bob packages at the same
time.
The built documentation is served at: https://www.idiap.ch/software/bob/documentation

Adding a new package
====================

To add a new package:

* Make sure the package is **public** first. Do not add private packages here.
* Make sure the package is in https://gitlab.idiap.ch/bob/bob first.
* The list of packages here should be in sync with `bob/bob`.
* **Remove** packages which are here but no longer are in `bob/bob`.
* Add it in ``conda/meta.yaml`` and ``packages.txt``.
* Add it in ``doc/index.rst`` (you need to add it in several places in this file).
* Add it in ``doc/readme_index.rst``.
* If it plots something using matplotlib during its documentation generation,
  make sure you add a symlink for it in the docs folder.

Test this package (build the documentation)
===========================================

To build and test this package, you can use bob.devtools.
After installing bob.devtools, run::

    $ bdt local docs -vv packages.txt

This will setup everything and build the documentation.

However, if you want to iterate on the documentation and keep building it, it's faster
to create a conda environment and build the docs manually::

    $ bdt local docs -vv packages.txt  # run this once so it setups everything for you
    $ bdt create -vv bob_docs  # create a conda environment named ``bob_docs``
    $ conda activate bob_docs

Then, to build the documentation, run::

    $ sphinx-build doc sphinx

Pay attention to warning messages and carefully inspect the built documentation.
