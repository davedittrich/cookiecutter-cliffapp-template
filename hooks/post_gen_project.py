#!/usr/bin/env python3

import os
import sys

from git import Repo
from git.exc import GitCommandError
from tempfile import mkstemp
from shutil import (
    copymode,
    move,
)


project_path = os.path.realpath(os.path.curdir)


def remove_project_file(filepath):
    full_path = os.path.join(project_path, filepath)
    os.remove(full_path)


def fix_underlines(dirpath, extensions=['.rst']):
    for root, dirs, files in os.walk(dirpath, topdown=False):
        for name in files:
            ext = os.path.splitext(name)[1]
            if ext not in extensions:
                continue
            orig_file = os.path.join(root, name)
            tmp_file = orig_file + '.tmp'
            with open(tmp_file, 'w', newline=None) as f_tmp:
                with open(orig_file, 'r', newline=None) as f_orig:
                    for line in f_orig.readlines():
                        # Assumes this will NEVER be the first line.
                        if 'FIX_UNDERLINE' not in line:
                            f_tmp.write(line)
                            last_line_len = len(line) - 1
                        else:
                            underline_char = line[0]
                            f_tmp.write(f'{underline_char * last_line_len}{os.linesep}')  # noqa
            os.replace(tmp_file, orig_file)


def fix_github_secrets(project_path):
    workflow_file = os.path.join(project_path,
                                 '.github',
                                 'workflows',
                                 'test-build-publish.yml')
    fd, tmp_path = mkstemp()
    with os.fdopen(fd, 'w') as f_out:
        with open(workflow_file, 'r') as f_in:
            for line in f_in:
                f_out.write(
                    line.replace('@PROJECT@',
                                 '{{cookiecutter.project_slug.upper()}}'))
    copymode(workflow_file, tmp_path)
    os.remove(workflow_file)
    move(tmp_path, workflow_file)


def error_for(item, not_valid, valid):
    return (
            f"[-] the character{'' if len(not_valid) == 1 else 's'} "
            f"{','.join(not_valid)}' "
            f"{'is' if len(not_valid) == 1 else 'are' }"
            f"not valid in '{item}': use only {valid}"
        )


def validate_name_and_slug():
    valid_alpha = [chr(i) for i in range(ord('a'), ord('z')+1)]
    valid_name_chars = valid_alpha + ['-']
    valid_slug_chars = valid_alpha + ['_']
    not_valid_in_name = [
        c for c in '{{cookiecutter.project_name}}'
        if c not in valid_name_chars
    ]
    if len(not_valid_in_name):
        sys.exit(error_for('project_name', not_valid_in_name, "'a-z' and '-'"))
    not_valid_in_slug = [
        c for c in '{{cookiecutter.project_slug}}'
        if c not in valid_slug_chars
    ]
    if len(not_valid_in_slug):
        sys.exit(error_for('project_slug', not_valid_in_slug, "'a-z' and '_'"))


# [1-post_gen_project]
def initialize_repo():
    repo = Repo.init(project_path)
    git = repo.git
    # Configure repo settings
    repo.description = '{{cookiecutter.project_short_description}}'
    repo_url = ('git@github.com:{{cookiecutter.github_username}}/'
                '{{cookiecutter.project_name}}.git')
    git.remote('add', 'origin', repo_url)
    # Configure user settings
    repo.config_writer().set_value(
        'user',
        'name',
        '{{cookiecutter.author|escape}}').release()
    repo.config_writer().set_value(
        'user',
        'email',
        '{{cookiecutter.author_email}}').release()
    # Add all files output by template
    repo.index.add([
        filename for filename in os.listdir(project_path)
        if filename != '.git'
    ])
    # Create initial commit on main
    repo.index.commit('Initial commit')
    try:
        git.branch('-m', 'master', 'main')
    except GitCommandError:
        pass
    # Set up a 'develop' branch ala 'git hf' command
    git.checkout('HEAD', b='develop')
    # Create an initial tag to test package publishing
    project_version = 'v{{cookiecutter.project_version}}rc1'
    git.tag('-a', project_version, '-m', project_version)
    # Leave HEAD on main branch
    git.checkout('main')
# ![1-post_gen_project]


if __name__ == '__main__':

    validate_name_and_slug()
    if 'Other/Proprietary License' == '{{cookiecutter.license}}':
        remove_project_file('LICENSE.txt')
    fix_underlines(project_path, extensions=['.rst', '.py'])
    fix_github_secrets(project_path)
    initialize_repo()
    sys.exit(0)


# vim: set ts=4 sw=4 tw=0 et :
