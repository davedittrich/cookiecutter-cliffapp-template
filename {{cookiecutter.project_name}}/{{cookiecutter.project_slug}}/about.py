# -*- encoding: utf-8 -*-

import argparse
import logging
import textwrap

from cliff.command import Command
from {{cookiecutter.project_slug}} import (
    __version__,
    copyright,
)
from {{cookiecutter.project_slug}}.utils import (
    add_browser_options,
    open_browser,
)


class About(Command):
    """About the ``{{cookiecutter.project_name}}`` CLI"""

    log = logging.getLogger(__name__)

    def get_parser(self, prog_name):
        parser = super().get_parser(prog_name)
        parser.formatter_class = argparse.RawDescriptionHelpFormatter
        parser.add_argument(
            '--readthedocs',
            action='store_true',
            dest='readthedocs',
            default=False,
            help=("Open a browser to the ``{{cookiecutter.project_name}}`` readthedocs page "
                  "(default: False{}).")
        )
        parser = add_browser_options(parser)
        parser.epilog = textwrap.dedent(f"""\
            Shows information about the ``{{cookiecutter.project_name}}`` CLI.

            ::

                $ {{cookiecutter.project_name}} about
                {{cookiecutter.project_name}} version { __version__ }


            It will also print out copyright and related information (which
            isn't easy to force ``autoprogram-cliff`` to parse correctly in
            help output).

            The ``--readthedocs`` option will open a browser to the ``{{cookiecutter.project_name}}``
            documentation web page.

            ABOUT THE BROWSER OPEN FEATURE

            This program uses the Python ``webbrowser`` module to open a
            browser.

                https://docs.python.org/3/library/webbrowser.html

            This module supports a large set of browsers for various operating
            system distributions. It will attempt to chose an appropriate
            browser from operating system defaults.  If it is not possible to
            open a graphical browser application, it may open the ``lynx`` text
            browser.

            You can choose which browser ``webbrowser`` will open using the
            identifier from the set in the ``webbrowser`` documentation.
            Either specify the browser using the ``--browser`` option on the
            command line, or export the environment variable ``BROWSER``
            set to the identifier (e.g., ``export BROWSER=firefox``).

            It is also possible to set the ``BROWSER`` environment variable
            to a full path to an executable to run. On Windows 10 with Windows
            Subsystem for Linux, you can use this feature to open a Windows
            executable outside of WSL. (E.g., using
            ``export BROWSER='/c/Program Files/Mozilla Firefox/firefox.exe'``
            will open Firefox installed in that path).

            Also note that when this program attempts to open a browser,
            an exception may be thrown if the process has no TTY. If this
            happens, use the ``--force`` option to bypass this behavior and
            attempt to open the browser anyway.
            """)  # noqa
        return parser

    def take_action(self, parsed_args):
        if parsed_args.readthedocs:
            open_browser(page="https://{{cookiecutter.project_name}}.readthedocs.io",
                         browser=parsed_args.browser,
                         force=parsed_args.force)
        else:
            if (
                self.app_args.verbose_level == 0
                or self.cmd_name == "version"
            ):
                print(f'{ __version__ }')
            else:
                # Hacking formatting for `{{cookiecutter.project_name}} help` by adding a tab here.
                print(f'{{cookiecutter.project_name}} version { __version__ }\n{copyright()}')


# EOF
