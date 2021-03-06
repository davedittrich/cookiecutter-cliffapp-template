# -*- encoding: utf-8 -*-

"""{{cookiecutter.project_short_description}}"""

# See the COPYRIGHT variable in {{cookiecutter.project_slug}}/__init__.py (also found
# in output of ``{{cookiecutter.project_name}} help``).

# Standard library modules.
import argparse
import logging
import os
import sys
import textwrap

from . import (
    __version__,
    {{cookiecutter.project_slug.upper().replace('_', '')}}_DATA_DIR,
)
from {{cookiecutter.project_slug}}.utils import Timer

# External dependencies.

from cliff.app import App
from cliff.commandmanager import CommandManager


if sys.version_info < (3, 6, 0):
    print(f"The { os.path.basename(sys.argv[0]) } program "
          "prequires Python 3.6.0 or newer\n"
          "Found Python { sys.version }", file=sys.stderr)
    sys.exit(1)

# Initialize a logger for this module.
logger = logging.getLogger(__name__)


def default_environment(default=None):
    """Return environment identifier"""
    return os.getenv('{{cookiecutter.project_slug.upper().replace('_', '')}}_ENVIRONMENT', default)


class {{cookiecutter.project_slug.capitalize()}}App(App):
    """{{cookiecutter.project_short_description}}"""

    def __init__(self):
        super().__init__(
            description=__doc__.strip(),
            version=__version__,
            command_manager=CommandManager(
                namespace='{{cookiecutter.project_slug}}'
            ),
            deferred_help=True,
        )
        self.environment = None
        self.timer = Timer()

    def build_option_parser(self, description, version):
        parser = super().build_option_parser(
            description,
            version
        )
        parser.formatter_class = argparse.RawDescriptionHelpFormatter
        # Global options
        parser.add_argument(
            '-D', '--data-dir',
            metavar='<data-directory>',
            dest='data_dir',
            default={{cookiecutter.project_slug.upper().replace('_', '')}}_DATA_DIR,
            help=('Root directory for holding data files '
                  f"(Env: ``{{cookiecutter.project_slug.upper().replace('_', '')}}_DATA_DIR``; "
                  f"default: { {{cookiecutter.project_slug.upper().replace('_', '')}}_DATA_DIR })")
        )
        parser.add_argument(
            '-e', '--elapsed',
            action='store_true',
            dest='elapsed',
            default=False,
            help=('Include elapsed time (and ASCII bell) '
                  'on exit (default: False)')
        )
        parser.add_argument(
            '-E', '--environment',
            metavar='<environment>',
            dest='environment',
            default=default_environment(),
            help=('Deployment environment selector '
                  "(Env: ``{{cookiecutter.project_slug.upper().replace('_', '')}}_ENVIRONMENT``; "
                  f'default: {default_environment()})')
        )
        from {{cookiecutter.project_slug}} import copyright
        parser.epilog = textwrap.dedent(f"""
        For help information on individual commands, use ``{{cookiecutter.project_name}} <command> --help``.

        Several commands have features that will attempt to open a browser. See
        ``{{cookiecutter.project_name}} about --help`` to see help information about this feature and how
        to control which browser(s) will be used.

        { copyright() }""")  # noqa
        return parser

    def initialize_app(self, argv):
        self.LOG.debug('initialize_app')
        self.set_environment(self.options.environment)

    def prepare_to_run_command(self, cmd):
        if cmd.app_args.verbose_level > 1:
            self.LOG.info('[+] command line: {}'.format(
                " ".join([arg for arg in sys.argv])
            ))
        self.LOG.debug('prepare_to_run_command %s', cmd.__class__.__name__)
        if self.options.elapsed:
            self.timer.start()

    def clean_up(self, cmd, result, err):
        self.LOG.debug('[!] clean_up %s', cmd.__class__.__name__)
        if self.options.elapsed:
            self.timer.stop()
            elapsed = self.timer.elapsed()
            if result != 0:
                self.LOG.debug('[!] elapsed time: %s', elapsed)
            elif (
                self.options.verbose_level >= 0
                and cmd.__class__.__name__ != "CompleteCommand"
            ):
                self.stdout.write('[+] Elapsed time {}\n'.format(elapsed))
                if sys.stdout.isatty():
                    sys.stdout.write('\a')
                    sys.stdout.flush()

    def set_environment(self, environment=default_environment()):
        """Set variable for current environment"""
        self.environment = environment

    def get_environment(self):
        """Get the current environment setting"""
        return self.environment


def main(argv=sys.argv[1:]):
    """
    Command line interface for the ``{{cookiecutter.project_name}}`` project.
    """

    try:
        myapp = {{cookiecutter.project_slug.capitalize()}}App()
        result = myapp.run(argv)
    except KeyboardInterrupt:
        sys.stderr.write("\nReceived keyboard interrupt: exiting\n")
        result = 1
    return result


if __name__ == '__main__':
    # Ensure that running program with either "python -m {{cookiecutter.project_slug}}"
    # or just "{{cookiecutter.project_name}}" result in same argv.
    if sys.argv[0].endswith('__main__.py'):
        sys.argv[0] = os.path.basename(os.path.dirname(sys.argv[0]))
    sys.exit(main(sys.argv[1:]))

# EOF
