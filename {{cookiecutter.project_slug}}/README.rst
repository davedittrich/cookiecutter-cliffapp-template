.. {{cookiecutter.project_slug}} documentation master file, created by
   cookiecutter on {{cookiecutter.release_date}}.

{{cookiecutter.project_name}}
==FIX_UNDERLINE==

{{cookiecutter.project_short_description}}

Version: {{cookiecutter.project_version}}


|Versions| |Contributors| |License| |Docs|
.. |Versions| image:: https://img.shields.io/pypi/pyversions/{{cookiecutter.project_slug}}.svg
   :target: https://pypi.org/project/{{cookiecutter.project_slug}}
.. |Contributors| image:: https://img.shields.io/github/contributors/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}.svg
   :target: https://github.com/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}/graphs/contributors
.. |License| image:: https://img.shields.io/github/license/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}.svg
   :target: https://github.com/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}/blob/master/LICENSE
.. |Docs| image:: https://readthedocs.org/projects/{{cookiecutter.project_slug}}/badge/?version=latest
   :target: https://{{cookiecutter.project_slug}}.readthedocs.io/en/latest/


* GitHub repo: https://github.com/{{cookiecutter.github_username}}/{{cookiecutter.project_slug}}/
* License: {{cookiecutter.license}}

Features
--------

* ``{{cookiecutter.project_slug}}`` uses the `openstack/cliff`_ framework to organize
  features into related groups of subcommands with lots of built-in help internally
  documenting their use and producing output in clean tabular form or in several other
  data formats that can feed into other tools or automation platforms.
* Testing set up for ``pytest``, ``bandit``, and BATS.
* Uses `Tox <https://tox.readthedocs.io/>`_ for testing against Python
  3.6, 3.7, 3.8, and 3.9.
* `Sphinx <http://www.sphinx-doc.org/>`_ documentation for generation with, for example,
  `ReadTheDocs <https://readthedocs.com>`_


Contact
-------

{{ cookiecutter.author }} {{ cookiecutter.author_email }}

.. |copy|   unicode:: U+000A9 .. COPYRIGHT SIGN

Copyright |copy| {{ cookiecutter.copyright_year }} {{ cookiecutter.copyright_name }}. All rights reserved.

Credits
-------

This package was created with `Cookiecutter
<https://github.com/cookiecutter/cookiecutter>`_ from the
<https://davedittrich/cookiecutter-cliffapp-template.git> project template.  It
derives some of its features and inspiration from
<https://github.com/veit/cookiecutter-namespace-template> and
<https://github.com/audreyfeldroy/cookiecutter-pypackage>.


.. _openstack/cliff: https://github.com/openstack/cliff

.. EOF
