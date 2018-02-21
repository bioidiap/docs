******************************************
Bob's Documentation Aggregation Repository
******************************************

This repository will build the documentation of all Bob packages at the same
time.

Adding a new package
====================

To add a new package:

* Make sure the package is **public** first. Do not add private packages here.
* Add it in ``conda/meta.yaml``.
* Add it in ``doc/index.rst``.
* If it plots something using matplotlib during its documentation generation,
  make sure you add a symlink for it in the docs folder.
