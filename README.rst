===================================
Cookiecutter ``cliff`` App Template
===================================

|Versions| |Contributors| |License| |Docs|

.. |Versions| image:: https://img.shields.io/pypi/pyversions/cookiecutter-cliffapp-template.svg
   :target: https://pypi.org/project/cookiecutter-cliffapp-template
.. |Contributors| image:: https://img.shields.io/github/contributors/davedittrich/cookiecutter-cliffapp-template.svg
   :target: https://github.com/davedittrich/cookiecutter-cliffapp-template/graphs/contributors
.. |License| image:: https://img.shields.io/github/license/davedittrich/cookiecutter-cliffapp-template.svg
   :target: https://github.com/davedittrich//cookiecutter-cliffapp-template/blob/master/LICENSE
.. |Docs| image:: https://readthedocs.org/projects/cookiecutter-cliffapp-template/badge/?version=latest
   :target: https://cookiecutter-cliffapp-template.readthedocs.io


`Cookiecutter <https://github.com/cookiecutter/cookiecutter>`_ template for a
Python ``cliff`` command line interface (CLI) package.

Version: 2021.3.0

Features
--------

* Uses the ``cookiecutter-cliffapp-template`` to produce a bare-bones functional
  Python CLI app built on the OpenStack
  `cliff -- Command Line Interface Formulation Framework <https://github.com/openstack/cliff>`_.

  ``cliff`` provides many useful features like modularizing subcommands into
  groups, built-in help for internally documenting commands, and producing
  output in clean tabular form or in one of several data formats you can
  feed into other tools or automation platforms.

* Immediately after ``cookiecutter`` generates the app directory, it sets up the Git
  repository for your new app with ``master`` and ``develop`` branches and an initial
  version tag, ready to push to GitHub.

  The app directory is also pre-configured with these features ready to go:

  * `Sphinx <http://www.sphinx-doc.org/>`_ documentation for generation with
    `ReadTheDocs <https://readthedocs.com>`_ including ``cliff`` autoprogram
    `Sphinx integration <https://docs.openstack.org/cliff/latest/user/sphinxext.html>`_
    for documenting commands from the same ``--help`` output you get at the
    command line.

  * Unit testing with `pytest <https://docs.pytest.org/en/stable/>`_, Python security
    vulnerability scanning with `bandit <https://bandit.readthedocs.io>`_, integration and
    system testing with BATS (`bats-core <https://bats-core.readthedocs.io>`_),
    and Python library dependency security scanning with GitHub's
    `dependabot <https://docs.github.com/en/code-security/supply-chain-security/configuring-dependabot-security-updates>`_.

  * Testing against Python versions 3.6, 3.7, 3.8, and 3.9 using `Tox <https://tox.readthedocs.io/>`_.

  * Version number bumping with a single command using `bump2version <https://github.com/c4urself/bump2version>`_
    and version number generation for packages and ``--version`` output using `setuptools_scm <https://pypi.org/project/setuptools-scm/>`_.

  * Workflow processing for automatic testing using
    `GitHub Actions <https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions>`_.

  * The GitHub Actions workflow will also auto-release packages to `PyPI <https://pypi.org/>`_ or
    `Test PyPI <https://test.pypi.org>`_ when you push a new version tag on the ``master`` branch or
    a special ``rc`` tag on the ``develop`` branch.


Quickstart
----------

#. Start with naming your project.

   You won't have an issue with namespace clashes between projects on GitHub,
   but PyPI, Test PyPI, and ReadTheDocs have flat namespaces and the name you
   want to use for your Python app may already be in use by someone else. Before
   creating your new project, check to make sure the same name is available on all
   of these services.

   Once you have settled on a usable name, make sure you have done the following:

   #. Register an account on both `PyPI <https://pypi.org/account/register/>`_ and
      `Test PyPI <https://test.pypi.org/account/register/>`_ and
      `set up <https://packaging.python.org/specifications/pypirc/>`_  your
      ``~/.pypirc`` file to access both services.

   #. Register an account on ReadTheDocs_ and
      `connect it to your GitHub account <https://readthedocs.org/accounts/social/connections/>`_.

   #. Create a new bare GitHub repo for the project that you can push with ``git``
      using SSH.

#. `Miniconda <https://docs.conda.io/en/latest/miniconda.html>`_ provides the most
   consistent Python virtual environment experience across Mac OSX, Windows 10,
   and Linux (either native, or on Windows 10 using
   `Windows Subsystem for Linux (WSL2) <https://docs.microsoft.com/en-us/windows/wsl/about>`_).

   Create a Conda environment with the version of Python you prefer for
   developing your new app. It's easier to remember which environment to activate
   if the environment name matches that of your app::

   $ conda create -n cliffapp python=3.9

#. Install the latest Cookiecutter if you haven’t installed it yet (Cookiecutter 1.4.0
   or higher is required) into your chosen Python virtual environment::

    $ conda activate cliffapp
    $ python3 -m pip install -U cookiecutter

#. In the directory where you keep your Git repos, use ``cookiecutter`` to generate
   a new Git repo directory for your Python package project (changing the answers to
   suit your project, of course)::

    $ cd ~/git
    $ python3 -m cookiecutter https://github.com/davedittrich/cookiecutter-cliffapp-template.git
    author [Dave Dittrich]:
    author_email [dave.dittrich@gmail.com]:
    github_username [davedittrich]:
    project_name [cookiecutter-cliffapp]:
    project_slug [cookiecutter_cliffapp]:
    project_short_description [The cookiecutter-cliffapp project command line interface.]:
    release_date [2021-03-29]:
    project_version [2021.3.0]:
    copyright_name [Dave Dittrich]:
    copyright_year [2021]:
    pypi_username [davedittrich]:
    Select license:
    1 - MIT license
    2 - BSD license
    3 - ISC license
    4 - Apache Software License 2.0
    5 - GNU General Public License v3
    6 - Other/Proprietary License
    Choose from 1, 2, 3, 4, 5, 6 [1]: 4
    $ cd cookiecutter-cliffapp

   As you can see, the repo is all set up with ``develop`` and ``master``
   branches, with the ``master`` branch checked out and ready to push to
   GitHub!::

    $ git remote -v
    origin  git@github.com:davedittrich/cookiecutter-cliffapp.git (fetch)
    origin  git@github.com:davedittrich/cookiecutter-cliffapp.git (push)
    $ git log
    commit 42fd5b4405d54b87fc62255da47ff1cfa0449b81 (HEAD -> master, tag: v2021.3.0rc1, develop)
    Author: Dave Dittrich <dave.dittrich@gmail.com>
    Date:   Mon Mar 29 19:18:40 2021 -0700

        Initial commit


#. Push the repo branches:

   * Using Git ``hubflow``::

       $ git hf init
       Using default branch names.

       Which branch should be used for tracking production releases?
          - develop
          - master
       Branch name for production releases: [master]

       Which branch should be used for integration of the "next release"?
          - develop
       Branch name for "next release" development: [develop]

       How to name your supporting branch prefixes?
       Feature branches? [feature/]
       Release branches? [release/]
       Hotfix branches? [hotfix/]
       Support branches? [support/]
       Version tag prefix? []
       . . .
       To github.com:davedittrich/cookiecutter-cliffapp.git
        * [new branch]      master -> master

   * Using Git commands directly::

       $ git push -u origin master
       . . .
       $ git checkout develop
       $ git push -u origin develop
       . . .

   The pushes should trigger GitHub Actions workflows, which should pass all
   tests (but not trigger any release publication at this point.)

#. Manually release your first test package to Test PyPI from the new repo
   directory. This initializes the project (which needs to be done _before_
   you can create API tokens). You can use this command::

       $ make release-test
       . . .
       twine upload dist/* -r testpypi
       Uploading distributions to https://test.pypi.org/legacy/
       Uploading cookiecutter_cliffapp-2021.3.0rc1-py2.py3-none-any.whl
       100%|███████████████████████████████████████████████████████████████|
       19.6k/19.6k [00:01<00:00, 14.1kB/s]
       Uploading cookiecutter_cliffapp-2021.3.0rc1.tar.gz
       100%|███████████████████████████████████████████████████████████████|
       32.8k/32.8k [00:01<00:00, 27.0kB/s]

       View at:
       https://test.pypi.org/project/cookiecutter-cliffapp/2021.3.0rc1/


#. Once the new project has been created on Test PyPI, log in, select the project,
   choose **Settings**, then choose **Create a token for <yourprojectname>**. Token
   names must be unique to your account, so use part of your project name
   (e.g., ``CLIFFAPP_TEST_PYPI_PASSWORD``) to differentiate this token from those
   for your other projects. Limit the scope of the token to just this
   project and then **Add token**. Note that you will only be able to see
   the token value once.

   Copy the token and paste it into the **Value** field for a new token (using
   the same name) in an `encrypted secret
   <https://docs.github.com/en/actions/reference/encrypted-secrets>`_ in your
   GitHub project window to be used in the GitHub Actions workflow.

   Test the workflow by creating a new tag with ``rc`` in the name (e.g.,
   ``v2021.3.0rc2``) on the ``develop`` branch and doing ``git push --tags``,
   which will then automatically trigger a workflow. The result should be that
   the publish portion pushes a new package to your Test PyPI project.

   When you are comfortable that tagging and publishing release candidates to Test
   PyPI is working smoothly, repeat the token creation and storage steps for
   PyPI (this time using ``CLIFFAPP_PYPI_PASSWORD`` as the token name).  Check out the
   ``master`` branch and use ``make release`` to push the initial package and
   create the project.  From then on, when you create a new release version tag
   (e.g., ``v2021.3.1``) on the ``master`` branch and push to GitHub, the
   GitHub Actions workflow will publish the package on PyPI (after the tests
   succeed, of course).


Pull requests
~~~~~~~~~~~~~

If you have major differences in your preferred setup, I encourage you to fork this
repo to create your own version. I also accept Pull Requests on this, if they’re
small, atomic, and if they make my own packaging experience better.

Credits
-------

This template repository derives some of its features and inspiration from:

* https://github.com/veit/cookiecutter-namespace-template
* https://github.com/audreyfeldroy/cookiecutter-pypackage
