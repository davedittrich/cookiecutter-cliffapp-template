#!/usr/bin/env python3

import os
from pathlib import Path


project_path = os.path.realpath(os.path.curdir)
try:
    project_slug = os.path.split(project_path)[1]
except IndexError:
    project_slug = os.path.basename(project_path)
try:
    namespace = project_slug.split('.')[0]
except IndexError:
    namespace = project_slug
try:
    package_name = project_slug.split('.')[1]
except IndexError:
    package_name = project_slug
package_path = os.path.join(project_path, namespace, package_name)


def remove_project_file(filepath):
    p = Path(project_path)  / filepath
    p.unlink(missing_ok=True)


def fix_underlines(dirpath):
    for root, dirs, files in os.walk(dirpath, topdown=False):
        for name in files:
            if not name.endswith('.rst'):
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
                            f_tmp.write(f'{underline_char * last_line_len}{os.linesep}')
            os.replace(tmp_file, orig_file)


if __name__ == '__main__':

    if 'Other/Proprietary License' == '{{ cookiecutter.license }}':
        remove_project_file('LICENSE')
    fix_underlines('.')

