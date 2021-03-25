===============================
Cookiecutter Cliff App Template
===============================

|Versions| |Contributors| |License| |Docs|
.. |Versions| image:: https://img.shields.io/pypi/pyversions/{{cookiecutter.project_slug}}.svg
   :target: https://pypi.org/project/{{cookiecutter.project_slug}}
.. |Contributors| image:: https://img.shields.io/github/contributors/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}.svg
   :target: https://github.com/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}/graphs/contributors
.. |License| image:: https://img.shields.io/github/license/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}.svg
   :target: https://github.com/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}/blob/master/LICENSE
.. |Docs| image:: https://readthedocs.org/projects/{{cookiecutter.project_slug}}/badge/?version=latest
   :target: https://{{cookiecutter.project_slug}}.readthedocs.io/en/latest/


`Cookiecutter <https://github.com/cookiecutter/cookiecutter>`_ Template for a
Python Cliff command line interface (CLI) package.

Version: 2021.3.0


Features
--------

* Testing setup with ``pytest``, ``bandit``, and BATS.
* `Tox <https://tox.readthedocs.io/>`_ testing: Setup to easily test for Python
  3.6, 3.7, 3.8, and 3.9
* `Sphinx <http://www.sphinx-doc.org/>`_ docs: Documentation ready for
  generation with, for example, ReadTheDocs_
* `bump2version <https://github.com/c4urself/bump2version>`_: Pre-configured
  version bumping with a single command
* Cliff autoprogram `Sphinx integration <https://docs.openstack.org/cliff/latest/user/sphinxext.html>`_ for documenting commands
* Optional auto-release to `PyPI <https://pypi.org/>`_ or `Test PyPI <https://test.pypi.org>`_
  when you push a new tag to `master` or `develop` (optional)


Quickstart
----------

#. Install the latest Cookiecutter if you haven’t installed it yet (this requires
   Cookiecutter 1.4.0 or higher) into your chosen Python virtual environment::

    $ conda activate myenv
    $ python3 -m pip install -U cookiecutter

#. Generate a Python package project::

    $ python3 -m cookiecutter https://github.com/davedittrich//cookiecutter-cliffapp-template.git

#. Create a GitHub repo and push it there.

#. `Register <https://pypi.org/account/register/>`_ your project with PyPI.

#. Add the repo to your `ReadTheDocs <https://readthedocs.io/>`_ account and
   turn on the ReadTheDocs service hook.

#. Release your package to PyPI by pushing a new tag to the `master` branch,
   or to Test PyPI by pushing a tag with `RC` in the name on the `develop` branch.

Pull requests
~~~~~~~~~~~~~

If you have differences in your preferred setup, I encourage you to fork this
to create your own version. I also accept pull requests on this, if they’re
small, atomic, and if they make my own packaging experience better.

Credits
-------

This template repository derives some of its features and inspiration from:

* https://github.com/veit/cookiecutter-namespace-template
* https://github.com/audreyfeldroy/cookiecutter-pypackage
