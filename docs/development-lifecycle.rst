.. _dev_lifecycle:

Development Lifecycle Tasks
===========================

This section covers the tasks at various stages in the lifecycle of a Python
project created using the ``cookiecutter-cliffapp-template``.

.. note::

    If you have not set things up yet, see :ref:`usage` for getting started
    and then come back here.

..


Development Testing
-------------------

You will want to regularly test your Python code in one or more ways. The simplest and
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

    $ tox -e py39,py310,py311

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

