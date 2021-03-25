Development Lifecycle Tasks
===========================

This section covers the tasks at various stages in the
lifecycle of a Python project. It starts with initializing
the repository directory from a ``cookiecutter`` template
and takes you all the way through to the release process
on PyPI.

Initializing the project repository with ``cookiecutter``
---------------------------------------------------------

When you create the intitial Python package directory with ``cookiecutter``
using this template, it will prompt you to enter values for the variables below
before using them to generate your initial project directory.

``author``
    Your full name
``email``
    Your email address
``github_username``
    Your GitHub username
``project_name``
    The name of your new Python package project. This is used to to create the
    namespace and the package name. So spaces, dashes, and other special
    characters should be avoided.
``project_slug``
    The name of your Python package on PyPi. This name will have any spaces
    and dashes converted to underlines (``_``).
``package_name``
    The namespace of your Python package. This should be Python import-friendly.
    Typically, it is the slugified version of ``project_name``.
``project_short_description``
    A 1-sentence description of what your Python package does.
``release_date``
    The date of the first release (*YYYY-MM-DD* format).
``project_version``
    The starting version number of the package (defaults to *YYYY.MM.0* format).
``copyright_name``
    Name of copyright holder (defaults to ``author``).
``copyright_year``
    The year of the initial package copyright in the license file (defaults
    to the current year).
``pypi_username``
    Your Python Package Index account username.

Development Testing
-------------------


Releasing on PyPI
-----------------

For Every Release
^^^^^^^^^^^^^^^^^

#. Update ``HISTORY.rst``

#. Commit the changes:

    .. code-block:: bash

        $ git add HISTORY.rst
        $ git commit -m "Changelog for upcoming release 0.1.1."

#. Update version number (can also be patch or major)

    .. code-block:: bash

        $ bump2version minor

#. Install the package again for local development, but with the new version
   number:

    .. code-block:: bash

        $ python setup.py develop

#. Run the tests:

    .. code-block:: bash

        $ tox

#. Push the commit:

    .. code-block:: bash

        $ git push

#. Push the tags, creating the new release on both GitHub and PyPI:

    .. code-block:: bash

        $ git push --tags

#. Check the PyPI listing page to make sure that the README, release notes, and
   roadmap display properly. If not, try one of these:

    #. Copy and paste the RestructuredText into http://rst.ninjs.org/ to find
       out what broke the formatting.

    #. Check your ``long_description`` locally:

        .. code-block:: bash

            $ pip install {{cookiecutter.project_slug}}
            $ python setup.py check -r -s

