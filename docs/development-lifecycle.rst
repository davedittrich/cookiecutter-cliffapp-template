Development Lifecycle Tasks
===========================

This section covers the tasks at various stages in the lifecycle of a Python
project created using the ``cookiecutter-cliffapp-template``.

These instructions assume you will be doing all of the following:

* Maintaining your source code repository on `GitHub <https://github.com>`_
  and using `GitHub Actions <https://docs.github.com/en/actions>`_ workflows
  for driving the continuous integration/continuous development (CI/CD)
  processes;

* Using `PyPI <https://pypi.org>`_ to publish releases of your project as
  Python packages and `Test PyPI <https://test.pypi.org>`_ for testing
  the release process and release candidate packages; and

* Using `ReadTheDocs <https://readthedocs.com>`_ for hosting your project's
  documentation.


.. note::

    Future releases of this template *may* support opting out of one or more
    of the features currently set up by the template. Feel free to submit a
    Pull Request for consideration!


Preparing your accounts
-----------------------

If you haven't do so yet, you will need to create a new account on each of the
services listed.

The three services will be linked in order for pushing commits on GitHub to
in turn push out new documentation and/or packages.

.. admonition:: TL;DR

    * Tokens from PyPI and Test PyPI are stored as `encrypted secrets on GitHub`_.
    * Create a project
    * Create a token

Integration of the services involved is accomplished by enabling the integration
in one or both of the services involved, or by creating an access token on
service ``A`` and storing that token on service ``B`` to authenticate connections
at a later time from ``B`` back to service ``A``.

.. _encrypted secrets on GitHub: https://docs.github.com/en/actions/reference/encrypted-secrets

PyPI and Test PyPI
~~~~~~~~~~~~~~~~~~


.. admonition:: TL;DR

    * Set up your accounts (if necessary)
    * Create a project
    * Create a token


Before starting a Python project that you want to publish on the `Python Packaging Index`_ (PyPI),
you should check to see

* `Python Packaging User Guide`_
* `Packaging Python Projects`_
* `How to Publish an Open-Source Python Package to PyPI`_, by Geir Arne Hjelle, RealPython
* `How to upload your python package to PyPi`_, by joelbarmettlerUZH, Medium, May 7, 2018

.. _Python Packaging Index: https://pypi.org/
.. _Python Packaging User Guide: https://packaging.python.org/
.. _Packaging Python Projects: https://packaging.python.org/tutorials/packaging-projects/
.. _How to Publish an Open-Source Python Package to PyPI: https://realpython.com/pypi-publish-python-package/
.. _How to upload your python package to PyPi: https://medium.com/@joel.barmettler/how-to-upload-your-python-package-to-pypi-65edc5fe9c56


ReadTheDocs
~~~~~~~~~~~

.. admonition:: TL;DR

    * Set up your account (if necessary)
    * Create a project
    * Generate an integration to use as a webhook from GitHub


https://readthedocs.org/dashboard/import/manual/?

The ``.readthedocs.yml`` file includes configuration settings that
control the documentation build process.


GitHub
~~~~~~

.. admonition:: TL;DR

    * Create a new project
    * Enable Dependabot checking on the Security tab for your project
    * Set a webhook for linking to ReadTheDocs




* Setting up a `PyPI project <https://pypi.org>`_ where you will release your
  project as a Python package, and a parallel
  `Test PyPI <https://test.pypi.org>`_ project for releasing test packages.
* Setting up a `GitHub repository <https://docs.github.com/en/github/getting-started-with-github/create-a-repo>`_
  for your project.
* Setting up a `ReadTheDocs documentation project <https://github.com/readthedocs/readthedocs.org#quickstart-for-github-hosted-projects>`_
  that is connected to the GitHub repository.
* Using `GitHub Actions <https://docs.github.com/en/actions>`_ workflows for
  continuous integration testing and publishing your PyPI/test PyPI packages.

See also:

* `Packaging Python Projects <https://packaging.python.org/tutorials/packaging-projects/>`_, PyPA
* `How to Publish an Open-Source Python Package to PyPI <https://realpython.com/pypi-publish-python-package/>`_, RealPython



Bootstrapping the project repository with ``cookiecutter``
----------------------------------------------------------

.. Note that this text is duplicative of the equivalent file in the
   template directory. Ensure changes are reflected there.

When you first create your Python package directory with ``cookiecutter``
using this template, it will prompt you to enter values for the variables below
before using them to generate your initial project directory.

``author``
    Your full name
``author_email``
    Your email address
``github_username``
    Your GitHub username
``project_name``
    The name of your new Python package project. This is used to to create the
    namespace, the package name, and the command name you will type at the
    console. It should be short and only contain lowercase characters ``a-z``
    and the dash (``-``) character.
``project_slug``
    The name of your Python package on PyPi. This name will have dashes converted
    to underscore characters (``_``) for use by ``import`` and variable names.
``project_short_description``
    A 1-sentence description of what your Python package is and does.
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
    Your Python Package Index account username for both PyPI and Test PyPI.
``license``
    The chosen license.

.. note::

   If any of these are not exactly what you need, just chose something (or accept
   the default) and change it after ``cookiecutter`` has rendered files from the
   template.



Development Testing
-------------------

You will want to regularly test your code in one or more ways. The simplest and
most frequent checks you will want to do are ``pep8`` and ``bandit`` tests to
ensure your code is clean and free of security bugs.

There are several levels of testing you may want to perform.

* You can perform limited code quality tests of your source code and documentation
  using ``tox`` directly like this::

     $ tox -e pep8,bandit,docs
     . . .
     pep8: commands succeeded
     bandit: commands succeeded
     docs: commands succeeded
     congratulations :)

* You can do unit testing and runtime integration testing of your code
  against several versions of Python using ``tox`` directly like this::

    $ tox -e py36,py37,py38,py39

* You can do runtime integration testing of your code using ``bats``
  via ``tox`` like this::

    $ tox -e bats

* You can testing of the full Python package using ``twine`` via ``tox``
  like this::

    $ tox -e pypi

* You can also use ``make`` to invoke some or all of the above by specifying
  one or more targets from the ``Makefile``. Use ``make help`` to see a list
  of available targets, or read the file with an editor to see the rules.
  The target for running all of the tests, first code quality, then more
  expensive unit, integration, and package tests, with this command::

    $ make test

When all of the latter tests pass, you can push your commits to GitHub.
If you forget to do this, the GitHub Action workflow will do it for
you and any failures will result in email messages informing you of
the failures.


Releasing on PyPI
-----------------

For Every Release
~~~~~~~~~~~~~~~~~

In addition to making sure that your code passes all of the tests covered in
the last section, you will also want to update documentation, bump version
numbers, merge branches, etc.


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

        $ make test

#. Push the commit:

    .. code-block:: bash

        $ git push

#. Push the tags, creating the new release on both GitHub and PyPI:

    .. code-block:: bash

        $ git push --tags

