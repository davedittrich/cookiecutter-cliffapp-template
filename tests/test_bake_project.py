import datetime
import os
import shlex
import subprocess

from cookiecutter.utils import rmtree
from contextlib import contextmanager

# List of tuples with a list of file path components (to be joined at
# runtime with project directory) and a string that should be found
# in the file.

CONTENTS = [
    (
        ["README.rst"],
        "Version: "
    ),
    (
        [".github", "workflows", "test-build-publish.yml"],
        "COOKIECUTTER_CLIFFAPP_TEST_PYPI_PASSWORD"
    ),
]


@contextmanager
def inside_dir(dirpath):
    """
    Execute code from inside the given directory
    :param dirpath: String, path of the directory the command is being run.
    """
    old_path = os.getcwd()
    try:
        os.chdir(dirpath)
        yield
    finally:
        os.chdir(old_path)


@contextmanager
def bake_in_temp_dir(cookies, *args, **kwargs):
    """
    Delete the temporal directory that is created when executing the tests
    :param cookies: pytest_cookies.Cookies, cookie to be baked and its
                    temporal files will be removed
    """
    result = cookies.bake(*args, **kwargs)
    try:
        yield result
    finally:
        if result.project is not None:
            rmtree(str(result.project))


def run_inside_dir(command, dirpath):
    """
    Run a command from inside a given directory, returning the exit status
    :param command: Command that will be executed
    :param dirpath: String, path of the directory the command is being run.
    """
    with inside_dir(dirpath):
        return subprocess.check_call(shlex.split(command))


def check_output_inside_dir(command, dirpath):
    "Run a command from inside a given directory, returning the command output"
    with inside_dir(dirpath):
        return subprocess.check_output(shlex.split(command), shell=True)


def project_info(result):
    """Get toplevel dir, project_slug, and project dir from baked cookies"""
    project_path = str(result.project)
    project_name = os.path.split(project_path)[-1]
    project_slug = project_name.lower().replace(' ', '_').replace('-', '_')
    package_dir = os.path.join(project_path, project_slug, project_slug)
    return project_path, project_slug, package_dir


def test_year_compute_in_license_file(cookies):
    with bake_in_temp_dir(cookies) as result:
        license_file_path = result.project.join('LICENSE')
        now = datetime.datetime.now()
        assert str(now.year) in license_file_path.read()


def test_bake_with_defaults(cookies):
    with bake_in_temp_dir(cookies) as result:
        assert result.exit_code == 0
        assert result.exception is None
        assert result.project.basename == 'cookiecutter-cliffapp'
        assert result.project.isdir()

        found_toplevel_files = [f.basename for f in result.project.listdir()]
        assert 'setup.py' in found_toplevel_files
        assert 'cookiecutter_cliffapp' in found_toplevel_files
        assert 'tox.ini' in found_toplevel_files
        assert 'tests' in found_toplevel_files

        found_testlevel_files = [
            f.basename
            for f in result.project.join('tests').listdir()
        ]
        assert 'test_cookiecutter_cliffapp-example.py' in found_testlevel_files

        found_bin_files = [
            f.basename
            for f in result.project.join('bin').listdir()
        ]
        assert 'cookiecutter-cliffapp' in found_bin_files


def test_bake_with_defaults_contents(cookies):
    with bake_in_temp_dir(cookies) as result:
        for path_components, file_contains in CONTENTS:
            file_contents = result.project.join(*path_components).read()  # noqa
            assert file_contains in file_contents


def test_bake_with_nameoverride(cookies):
    with bake_in_temp_dir(
        cookies,
        extra_context={"project_name": "mycliffapp"}
    ) as result:
        assert result.exit_code == 0
        assert result.exception is None
        assert result.project.basename == 'mycliffapp'
        assert result.project.isdir()

        found_toplevel_files = [f.basename for f in result.project.listdir()]
        assert 'setup.py' in found_toplevel_files
        assert 'mycliffapp' in found_toplevel_files
        assert 'tox.ini' in found_toplevel_files
        assert 'tests' in found_toplevel_files

        found_testlevel_files = [
            f.basename
            for f in result.project.join('tests').listdir()
        ]
        assert 'test_mycliffapp-example.py' in found_testlevel_files

        found_bin_files = [
            f.basename
            for f in result.project.join('bin').listdir()
        ]
        assert 'mycliffapp' in found_bin_files


def test_bake_bad_project_names(cookies):
    for name in ['project name', 'Project-Name', 'pr0ject_name!']:
        with bake_in_temp_dir(
            cookies,
            extra_context={"project_name": name}
        ) as result:
            assert result.exit_code != 0


def test_bake_bad_project_slugs(cookies):
    for slug in ['slug name', 'Slug-Name', '5lug_name!']:
        with bake_in_temp_dir(
            cookies,
            extra_context={"project_slug": slug}
        ) as result:
            assert result.exit_code != 0


def test_bake_and_validate_env_vars(cookies):
    with bake_in_temp_dir(cookies) as result:
        assert result.project.isdir()
        for file_name in ['__init__.py', '__main__.py']:
            file_contents = result.project.join('cookiecutter_cliffapp',
                                                file_name).read()
            assert "COOKIECUTTERCLIFFAPP_DATA_DIR" in file_contents


def test_bake_and_run_tests(cookies):
    with bake_in_temp_dir(cookies) as result:
        assert result.project.isdir()
        run_inside_dir('pytest tests', str(result.project)) == 0
        print("test_bake_and_run_tests path", str(result.project))


def test_bake_withspecialchars_and_run_tests(cookies):
    """Ensure that a `author` with double quotes does not break setup.py"""
    with bake_in_temp_dir(
        cookies,
        extra_context={"author": "Dave \"Vegas\" Dittrich"}
    ) as result:
        assert result.project.isdir()
        run_inside_dir('pytest tests', str(result.project)) == 0


def test_bake_with_apostrophe_and_run_tests(cookies):
    """Ensure that a `author` with apostrophes does not break setup.py"""
    with bake_in_temp_dir(
        cookies,
        extra_context={"author": "Donner O\'Connor"}
    ) as result:
        assert result.project.isdir()
        run_inside_dir('pytest tests', str(result.project)) == 0


def test_bake_selecting_license(cookies):
    license_strings = {
        'MIT license': 'MIT ',
        'BSD license': ('Redistributions of source code must retain the above '
                        'copyright notice, this'),
        'ISC license': 'ISC License',
        'Apache Software License 2.0': ('Licensed under the Apache License, '
                                        'Version 2.0'),
        'GNU General Public License v3': 'GNU GENERAL PUBLIC LICENSE',
    }
    for license, target_string in license_strings.items():
        with bake_in_temp_dir(
            cookies,
            extra_context={"license": license}
        ) as result:
            assert target_string in result.project.join('LICENSE').read()
            assert license in result.project.join(
                'cookiecutter_cliffapp', '__init__.py').read()
            assert 'Private :: Do Not Upload' not in result.project.join('setup.cfg').read()  # noqa


def test_bake_not_open_source(cookies):
    with bake_in_temp_dir(
        cookies,
        extra_context={"license": "Other/Proprietary License"}
    ) as result:
        found_toplevel_files = [f.basename for f in result.project.listdir()]
        assert 'setup.py' in found_toplevel_files
        assert 'LICENSE' not in found_toplevel_files
        assert 'Proprietary license' in result.project.join('README.rst').read()  # noqa
        assert 'Private :: Do Not Upload' in result.project.join('setup.cfg').read()  # noqa


# vim: set ts=4 sw=4 tw=0 et :

