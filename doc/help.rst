.. _bob.help:

================================
 How to get help and contribute
================================

Example usages of Bob
=====================

Bob paper packages can serve as good examples of how to use Bob. Search for
``bob.paper`` in our Gitlab: https://gitlab.idiap.ch/bob?filter=bob.paper
**AND** in PyPI: https://pypi.org/search/?q=bob.paper&c=Framework+::+Bob for
paper packages. Please note that the older a ``bob.paper`` package is, it is
more likely that it uses some deprecated practices.

For example, you can look at:

* https://gitlab.idiap.ch/bob/bob.paper.icml2017 on how to evaluate a new
  CNN-based face recognition algorithm on face recognition databases. (Note that
  the ``evaluate.py`` command is replaced by ``bob bio evaluate`` in recent
  versions of Bob.)
* https://gitlab.idiap.ch/bob/bob.paper.btas2018_siliconemask/tree/master/bob/paper/btas2018_siliconemask/database
  and https://gitlab.idiap.ch/bob/bob.db.oulunpu/ for good examples of how to
  create new database interfaces for the ``bob.bio`` and ``bob.pad`` frameworks.


How to get help
===============

There are several ways to get help if you are facing a problem.

First, you should search for possible existing answers in:

* https://stackoverflow.com/questions/tagged/python-bob
* https://www.idiap.ch/software/bob/discuss
* https://www.idiap.ch/software/bob/wiki

or you may just want to search on the Internet for possible answers.

Second, feel free to ask us. We encourage you to do so. The preferred way of asking is
by using public channels. Here is a list of places that you can ask questions:

* Ask on https://stackoverflow.com and tag your questions with ``python-bob``.
  This is the preferred way.
* Ask on our mailing list: https://www.idiap.ch/software/bob/discuss


How to contribute
=================

Bob is open source and we welcome contributions.
If you find a bug, please let use know through our mailing list:
https://www.idiap.ch/software/bob/discuss.
If you want to contribute, please also get in touch with us through our mailing list
first.
We maintain a mirror of Bob packages on https://github.com/bioidiap/ which should allow
you to open pull requests on Bob packages.

.. include:: links.rst
