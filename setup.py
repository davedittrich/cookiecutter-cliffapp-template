# !/usr/bin/env python

import os

from setuptools import setup
from setuptools_scm import get_version


###################################################################

PACKAGES = []
META_PATH = os.path.join("__about__.py")
INSTALL_REQUIRES = []

###################################################################

about = {}
with open(os.path.join("__about__.py")) as f:
    exec(f.read(), about)

with open("README.rst", "r") as fh:
    long_description = fh.read()

try:
    version = get_version(root='.', relative_to=__file__)
except (LookupError, ModuleNotFoundError):
    with open("VERSION", "r") as fh:
        version = fh.read().strip()

setup(
    packages=PACKAGES,
    version=version,
    long_description=long_description,
    long_description_content_type="text/x-rst",
)
