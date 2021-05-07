# -*- coding: utf-8 -*-

import datetime
import os
import textwrap

{{cookiecutter.project_slug.upper().replace('_', '')}}_DATA_DIR = os.environ.get(
    "{{cookiecutter.project_slug.upper().replace('_', '')}}_DATA_DIR",
    os.getcwd()
)


def copyright():
    """Copyright string"""
    this_year = str(datetime.datetime.today().year)
    copyright_years = (
        f'{{cookiecutter.copyright_year}}-{this_year}'
        if '{{cookiecutter.copyright_year}}' != this_year
        else '{{cookiecutter.copyright_year}}'
    )
    copyright = textwrap.dedent(f"""
        This program was bootstrapped from a ``cookiecutter`` template created
        by Dave Dittrich <dave.dittrich@gmail.com>:

            https://github.com/davedittrich/cookiecutter-cliffapp-template.git
            https://cookiecutter-cliffapp-template.readthedocs.io

        Author:    {{cookiecutter.author}} <{{cookiecutter.author_email}}>
        Copyright: {copyright_years}, {{cookiecutter.author}}. All rights reserved.
        License:   {{cookiecutter.license}}
        URL:       https://pypi.python.org/pypi/{{cookiecutter.project_name}}""")  # noqa
    return copyright


__author__ = '{{cookiecutter.author}}'
__copyright__ = copyright()
__email__ = '{{cookiecutter.author_email}}'
__license__ = '{{cookiecutter.license}}'
__name__ = '{{cookiecutter.project_name}}'
__release__ = '{{cookiecutter.project_version}}'
__version__ = None
__summary__ = '{{cookiecutter.project_short_description}}'
__title__ = '{{cookiecutter.project_name}}'
__url__ = 'https://github.com/{{cookiecutter.github_username}}/{{cookiecutter.project_name}}'

# Get development version from repository tags?
try:
    from setuptools_scm import get_version
    __version__ = get_version(root='..', relative_to=__file__)
except (LookupError, ModuleNotFoundError):
    pass

if __version__ is None:
    from pkg_resources import get_distribution, DistributionNotFound
    try:
        __version__ = get_distribution("{{cookiecutter.project_slug}}").version
    except (DistributionNotFound, ModuleNotFoundError):
        pass

if __version__ is None:
    __version__ = __release__


__all__ = [
    '__author__',
    '__copyright__',
    '__email__',
    '__release__',
    '__summary__',
    '__title__',
    '__url__',
    '__version__',
]

# vim: set ts=4 sw=4 tw=0 et :
