# !/usr/bin/env python
# -*- coding: utf-8 -*-

# Setup script for the `{{cookiecutter.project_slug}}' package.
#
# Author: {{cookiecutter.author}} {{cookiecutter.author_email}}
# URL: https://github.com/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}.git

# from {{cookiecutter.project_slug}} import *

from setuptools import (
    find_packages,
    setup,
)
from setuptools_scm import get_version


# HTTPError: 400 Bad Request from https://test.pypi.org/legacy/
# '2021.9.0rc2.dev1+g25971ae.d20210924' is an invalid value for Version.
# Error: Can't use PEP 440 local versions.
# See https://packaging.python.org/specifications/core-metadata
# for more information.


def local_scheme(version):
    return ""


with open("README.rst", "r") as fh:
    long_description = fh.read()

try:
    with open("requirements.txt", "r") as fh:
        requirements = fh.read()
except FileNotFoundError:
    requirements = ""

try:
    version = get_version(root='.', relative_to=__file__)
except (LookupError, ModuleNotFoundError):
    with open("VERSION", "r") as fh:
        version = fh.read().strip()

setup(
    version=version,
    setup_requires=['setuptools>=40.9.0', 'pip>=20.2.2'],
    use_scm_version={"local_scheme": local_scheme},
    include_package_data=True,
    install_requires=requirements,
    long_description=long_description,
    long_description_content_type="text/x-rst",
    namespace_packages=[],
    package_dir={'{{cookiecutter.project_slug}}': '{{cookiecutter.project_slug}}'},
    packages=find_packages(exclude=['tests']),
    test_suite='tests',
    zip_safe=False,
)

# vim: set ts=4 sw=4 tw=0 et :
