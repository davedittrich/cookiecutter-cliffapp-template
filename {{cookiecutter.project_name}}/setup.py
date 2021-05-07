# !/usr/bin/env python
# -*- coding: utf-8 -*-

# Setup script for the `{{cookiecutter.project_slug}}' package.
#
# Author: {{cookiecutter.author}} {{cookiecutter.author_email}}
# URL: https://github.com/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}.git

# from {{cookiecutter.project_slug}} import *

from setuptools import (
    setup,
    find_packages,
)
from setuptools_scm import get_version

###################################################################

###################################################################

with open("README.rst", "r") as fh:
    long_description = fh.read()

with open("requirements.txt", "r") as fh:
    requirements = fh.read()

try:
    version = get_version(root='.', relative_to=__file__)
except (LookupError, ModuleNotFoundError):
    with open("VERSION", "r") as fh:
        version = fh.read().strip()

setup(
    version=version,
    long_description=long_description,
    long_description_content_type="text/x-rst",
    namespace_packages=[],
    package_dir={'{{cookiecutter.project_slug}}': '{{cookiecutter.project_slug}}'},
    packages=find_packages(exclude=['tests']),
    include_package_data=True,
    install_requires=requirements,
    test_suite='tests',
    zip_safe=False,
)

# vim: set ts=4 sw=4 tw=0 et :
