#!/usr/bin/env python
# vim: set fileencoding=utf-8 :
"""A package that builds all the documentations of Bob packages
"""

from setuptools import setup

# Define package version
version = open("version.txt").read().rstrip()

setup(
    name="bob.docs",
    version=version,
    description="A package that builds all the documentations of Bob packages",
    url='http://gitlab.idiap.ch/bob/docs',
    license="BSD",
    author='Amir Mohammadi',
    author_email='amir.mohammadi@idiap.ch',
    long_description=open('README.rst').read(),

    packages=None,
    include_package_data=True,
    zip_safe=False,

    classifiers=[
        'Framework :: Bob',
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ],
)
