.. _bob.install:

===========================
 Installation instructions
===========================

By now you should know that Bob is made of several :ref:`bob.packages`. There is no single
package that installs all Bob packages because that would just take too much space.
Follow the instruction below to install any Bob package.

We offer pre-compiled binary installations of Bob using `conda`_ for Linux and
MacOS 64-bit operating systems. Follow the guide below to learn to install any Bob
package. Bob does not work on Windows.

#.  Install `conda`_ (miniconda is preferred) and get familiar with it.
#.  Make sure you have an up-to-date `conda`_ installation (conda 4.4 and above
    is needed) with the **correct configuration** by running the commands
    below:

    .. code:: sh

       $ conda update -n base -c defaults conda
       $ conda config --set show_channel_urls True

#.  Create an environment with the specific Bob packages that you need. For example if
    you want to install ``bob.io.image`` and ``bob.bio.face``:

    .. code:: sh

       $ conda create --name bob_env1 --override-channels \
         -c https://www.idiap.ch/software/bob/conda -c defaults \
         python=3 bob.io.image bob.bio.face

#.  Then activate the environment and configure its channels to make sure the channel
    list is correct in the future as well:

    .. code:: sh

       $ conda activate bob_env1
       $ conda config --env --add channels defaults
       $ conda config --env --add channels https://www.idiap.ch/software/bob/conda

#.  If you decide to install more packages in the future, just conda install them:

    .. code:: sh

       $ conda activate bob_env1
       $ conda install bob.io.video bob.bio.video ...

For a comprehensive list of packages that are either part of |project| or use
|project|, please visit :ref:`bob.packages`.

.. warning::

    Be aware that if you use packages from our channel and other user/community
    channels (especially ``conda-forge``) in one environment, you may end up
    with a broken envrionment. We can only guarantee that the packages in our
    channel are compatible with the ``defaults`` channel.

.. note::

    Bob does not work on Windows and hence no conda packages are available for
    it. It will not work even if you install it from source. If you are an
    experienced user and manage to make Bob work on Windows, please let us know
    through our `mailing list`_.

.. note::

    Bob has been reported to run on arm processors (e.g. Raspberry Pi) but is
    not installable with conda. Please see https://stackoverflow.com/questions/50803148
    for installations on how to install Bob from source.


.. _bob.source:

Developing Bob packages
=======================

Use :ref:`bob.devtools <bob.devtools>` if you want to develop Bob packages or create
a new package. **DO NOT** modify (including adding extra files) the source code of Bob
packages in your Conda environments. Typically, Bob packages can be extended without
modifying the original package. So you may want to put your new code in a new package
instead of modifying the original package.

.. warning::

  Conda uses hard links to create new
  environments from a cache folder. Editing a file in one of the environments will edit
  that file in **ALL** of your environments. The only safe way to recover from this is to
  delete your Conda installation completely and installing everything again from scratch.


Installing older versions of Bob
================================

Since Bob 4, you can easily select the Bob version that you want to install
using conda. For example:

.. code:: sh

    $ conda install \
    -c https://www.idiap.ch/software/bob/conda \
    -c defaults \
    -c https://www.idiap.ch/software/bob/conda/label/archive \
    bob=4.0.0 bob.io.base

will install the version of ``bob.io.base`` that was associated with the Bob
4.0.0 release.

.. note::

    If you install the ``bob`` conda package, you may need to change your channel list
    to:

    .. code:: sh

       $ conda activate <bob-env-name>
       $ conda config --env --add channels https://www.idiap.ch/software/bob/conda/label/archive
       $ conda config --env --add channels defaults
       $ conda config --env --add channels https://www.idiap.ch/software/bob/conda

Bob packages that were released before Bob 4 are not easily installable. Here,
we provide conda environment files (**Linux 64-bit only**) that will install
all Bob packages associated with an older release of Bob:

===========  ==============================================================
Bob Version  Environment Files
===========  ==============================================================
2.6.2        :download:`envs/v262py27.yaml`, :download:`envs/v262py35.yaml`
2.7.0        :download:`envs/v270py27.yaml`, :download:`envs/v270py35.yaml`
3.0.0        :download:`envs/v300py27.yaml`, :download:`envs/v300py36.yaml`
===========  ==============================================================

To install them, download one of the files above and run:

.. code:: sh

    $ conda env create --file v300py36.yaml


Details (advanced users)
========================

Since Bob 4, the ``bob`` conda package is just a meta package that pins all
packages to a specific version. Installing ``bob`` will not install anything;
it will just impose pinnings in your environment. Normally, installations of
Bob packages should work without installing ``bob`` itself. For example,
running:

.. code:: sh

    $ conda create --name env_name --override-channels \
      -c https://www.idiap.ch/software/bob/conda -c defaults \
      bob.<package-name>

should always create a working environment. If it doesn't, please let us know.


.. include:: links.rst
