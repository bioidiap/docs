.. _bob.tutorial:

********************************
 Getting started with |project|
********************************

The following tutorial constitutes a suitable starting point to get to
know how to use |project|'s packages and to learn its fundamental concepts.


Multi-dimensional Arrays
========================

The fundamental data structure of |project| is a multi-dimensional array. In
signal processing and machine learning, arrays are a suitable representation
for many different types of digital signals such as images, audio data and
extracted features. For multi-dimensional arrays, we rely on `NumPy`_.
For an introduction and tutorials about NumPy ndarrays, just visit the `NumPy
Reference`_ website.


Digital signals as multi-dimensional arrays
===========================================

For |project|, we have decided to represent digital signals directly as
:any:`numpy.ndarray` rather than having dedicated classes for each type of
signals. This implies that some convention has been defined.

Vectors and matrices
--------------------

A vector is represented as a 1D NumPy array, whereas a matrix is
represented by a 2D array whose first dimension corresponds to the rows,
and second dimension to the columns.

.. code:: python

    >>> import numpy
    >>> A = numpy.array([[1, 2, 3], [4, 5, 6]], dtype='uint8') # A is a matrix 2x3
    >>> print(A)
    [[1 2 3]
     [4 5 6]]
    >>> b = numpy.array([1, 2, 3], dtype='uint8') # b is a vector of length 3
    >>> print(b)
    [1 2 3]

Images
------

**Grayscale** images are represented as 2D arrays, the first dimension
being the height (number of rows) and the second dimension being the
width (number of columns). For instance:

.. code:: python

    >>> img = numpy.ndarray((480,640), dtype='uint8')

``img`` which is a 2D array can be seen as a gray-scale image of
dimension 640 (width) by 480 (height). In addition, ``img`` can be seen
as a matrix with 480 rows and 640 columns. This is the reason why we
have decided that for images, the first dimension is the height and the
second one the width, such that it matches the matrix convention as
well.

**Color** images are represented as 3D arrays, the first dimension being
the number of color planes, the second dimension the height and the
third the width. As an image is an array, this is the responsibility of
the user to know in which color space the content is stored.
:any:`bob.io.image` provides functions to convert Bob format images into
Matplotlib_ and other formats and back:

.. code:: python

    >>> import bob.io.image
    >>> colored_bob_format = numpy.ndarray((3,480,640), dtype='uint8')
    >>> colored_matplotlib_format = bob.io.image.to_matplotlib(colored_bob_format)
    >>> print(colored_matplotlib_format.shape)
    [480 640 3]
    >>> colored_bob_format = bob.io.image.to_bob(colored_matplotlib_format)
    >>> print(colored_bob_format.shape)
    [3 480 640]
    >>> pillow_img = bob.io.image.bob_to_pillow(colored_bob_format)
    >>> opencv_bgr = bob.io.image.bob_to_opencv(colored_bob_format)

.. note::

    In :ref:`bob.bio.face`, the images are assumed to be in range ``[0,255]``
    irrespective of their data type.

Videos
------

A video can be seen as a sequence of images over time. By convention, the first
dimension is for the frame indices (time index), whereas the remaining ones are
related to the corresponding image frame. The videos have the shape of
``(N,C,H,W)``, where ``N`` is the number of frames, ``H`` the height, ``W`` the
width and ``C`` the number of color planes.


Input and output
================

:ref:`bob.io.base` provides two generic functions :any:`bob.io.base.load` and
:any:`bob.io.base.save` to load and save data of various types, based on the
filename extension. For example, to load a ``.jpg`` image, simply call:

.. code:: python

    >>> import bob.io.base
    >>> img = bob.io.base.load("myimg.jpg")

`HDF5`_ format, through h5py_, and images, through imageio_, are supported.
For loading videos, use imageio-ffmpeg_ directly.


Machine learning
================

:ref:`bob.learn.em` provides implementation of the following methods:

    - K-Means clustering
    - Gaussian Mixture Modeling (GMM)
    - Joint Factor Analysis (JFA)
    - Inter-Session Variability (ISV)
    - Total Variability (TV, also known as i-vector)
    - Probabilistic Linear Discriminant Analysis (PLDA, also known as i-vector)

All implementations use dask_ to parallelize the training computation.

Database interfaces
===================

Bob provides an API on top of CSV files to easily query databases.
A generic implementation is provided in :ref:`bob.pipelines` but packages
such as :ref:`bob.bio.base` and :ref:`bob.pad.base` provide their own implementations.

Performance evaluation
======================

Methods in the :ref:`bob.measure` module can be used evaluate error for
multi-class or binary classification problems. Several evaluation
techniques such as:

    - Root Mean Squared Error (RMSE)
    - F-score
    - Precision and Recall
    - False Positive Rate (FPR)
    - False Negative Rate (FNR)
    - Equal Error Rates (EER)

can be computed. Moreover, functionality for plotting

    - ROC
    - DET
    - CMC
    - EPC

curves are described in more detail in the :ref:`bob.measure`.

.. include:: links.rst
