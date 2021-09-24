.. {{ cookiecutter.project_slug }} documentation main file, created by
.. cookiecutter on {{ cookiecutter.release_date }}.
.. You can adapt this file completely to your liking, but it should at least
.. contain the root `toctree` directive.

{% set short_description = cookiecutter.project_short_description[0].lower() + cookiecutter.project_short_description[1:].rstrip('.') -%}

.. meta::
   :description: {{cookiecutter.project_short_description}}
   :robots: index, follow
   :keywords: python, cli, app, cliff, {{cookiecutter.project_slug}}

{{ cookiecutter.project_name }}
==FIX_UNDERLINE==

This document (version |release|) describes {{short_description}}
(``{{cookiecutter.project_name}}`` for short).

.. toctree::
   :maxdepth: 2
   :numbered:
   :caption: Contents:

   introduction
   usage
   development-lifecycle
   credits
   license

.. sectionauthor:: {{ cookiecutter.author }} {{ cookiecutter.author_email }}

.. include:: <isonum.txt>


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


Copyright |copy| {{ cookiecutter.copyright_year }} {{ cookiecutter.copyright_name }}. All rights reserved.
