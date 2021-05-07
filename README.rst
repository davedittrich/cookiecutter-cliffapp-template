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


`Cookiecutter <https://github.com/cookiecutter/cookiecutter>`_ Template for a
Python ``cliff`` command line interface (CLI) package.

Version: 2021.3.0

Features
--------

* Uses the ``cookiecutter-cliffapp-template`` to produce a bare-bones functional
  Python CLI app built on the OpenStack
  `cliff -- Command Line Interface Formulation Framework <https://github.com/openstack/cliff>`_.
* ``cliff`` provides many useful features like modularizing subcommands into
  groups, built-in help for internally documenting commands, and producing
  output in clean tabular form or in one of several data formats you can
  feed into other tools or automation platforms.
* `Sphinx <http://www.sphinx-doc.org/>`_ documentation for generation with `ReadTheDocs <https://readthedocs.com>`_
  including ``cliff`` autoprogram `Sphinx integration <https://docs.openstack.org/cliff/latest/user/sphinxext.html>`_
  for documenting commands from the same ``--help`` output you can get at the command line.
* Preconfigured for unit testing with `pytest <https://docs.pytest.org/en/stable/>`_,
  Python security vulnerability scanning with `bandit <https://bandit.readthedocs.io>`_,
  integration and system testing with BATS (`bats-core <https://bats-core.readthedocs.io>`_),
  and Python library dependency security scanning with GitHub's
  `dependabot <https://docs.github.com/en/code-security/supply-chain-security/configuring-dependabot-security-updates>`_.
* Uses `Tox <https://tox.readthedocs.io/>`_ for testing against Python 3.6, 3.7, 3.8, and 3.9.
* Set up for version number bumping with a single command using `bump2version <https://github.com/c4urself/bump2version>`_.
* Set up for `GitHub Actions <https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions>`_
  workflow processing for automatic testing.
* The GitHub Actions workflow will also auto-release packages to `PyPI <https://pypi.org/>`_ or
  `Test PyPI <https://test.pypi.org>`_ when you push a new version tag on the ``master`` branch, or a
  special ``rc`` tag on the ``develop`` branch.


Quickstart
----------

#. Install the latest Cookiecutter if you haven’t installed it yet (this requires
   Cookiecutter 1.4.0 or higher) into your chosen Python virtual environment::

    $ conda activate myenv
    $ python3 -m pip install -U cookiecutter

#. `Register <https://pypi.org/account/register/>`_ your project with PyPI and Test PyPI.

#. Add the repo to your ReadTheDocs_ account and turn on the ReadTheDocs service hook.

#. Create a GitHub repo and set API tokens for PyPI and Test PyPI access.

#. Generate a Python package project, ready to push::

    $ python3 -m cookiecutter https://github.com/davedittrich/cookiecutter-cliffapp-template.git
    $ cd ~/git/cookiecutter-cliffapp
    $ git log
    commit 42fd5b4405d54b87fc62255da47ff1cfa0449b81 (HEAD -> master, tag: v2021.3.0rc1, develop)
    Author: Dave Dittrich <dave.dittrich@gmail.com>
    Date:   Mon Mar 29 19:18:40 2021 -0700

        Initial commit


#. Push the repo branches and tags:

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
       To github.com:davedittrich/ether-py.git
        * [new branch]      master -> master

   * Using Git commands directly::

       $ git push -u origin master
       . . .
       $ git checkout develop
       $ git push -u origin develop
       . . .

   The push should trigger a GitHub Actions workflow, which should pass all
   tests (but not trigger any release publication at this point.)

#. Release your first package to PyPI and Test PyPI from the new repo
   directory. This assumes you have already set up your ``.pypirc`` file
   with appropriate credential information::

       $ make release-test . . .  twine upload dist/* -r testpypi Uploading
       distributions to https://test.pypi.org/legacy/ Uploading
       ether_py-2021.3.0rc1-py2.py3-none-any.whl
       100%|███████████████████████████████████████████████████████████████|
       19.6k/19.6k [00:01<00:00, 14.1kB/s] Uploading
       ether_py-2021.3.0rc1.tar.gz
       100%|███████████████████████████████████████████████████████████████|
       32.8k/32.8k [00:01<00:00, 27.0kB/s]

       View at:
       https://test.pypi.org/project/ether-py/2021.3.0rc1/


   Once the new project has been created, you can create a project-level token
   to be used in the GitHub Actions workflow.  The publish portion of that
   workflow is automatically triggered by either pushing a new version tag to
   the ``master`` branch (e.g., ``v2021.3.0``), or to Test PyPI by pushing a
   tag with ``rc`` in the name on the ``develop`` branch (e.g.,
   ``v2021.3.1rc1``).


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
