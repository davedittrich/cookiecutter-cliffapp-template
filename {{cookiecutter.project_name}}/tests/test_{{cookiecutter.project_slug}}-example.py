#!/usr/bin/env python

"""
test_{{cookiecutter.project_slug}}
--FIX_UNDERLINE--

Placeholder tests so pytest has (at least) *something* to do.


This example test should be replaced with unit tests for your
CLI app. You can find some working examples to build from at:

    https://github.com/davedittrich/python_secrets/tree/master/tests
    https://github.com/openstack/cliff/tree/master/cliff/tests


"""

import unittest


class Test_{{cookiecutter.project_slug.title()}}(unittest.TestCase):

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_{{cookiecutter.project_slug}}(self):
        pass


if __name__ == '__main__':
    import sys
    sys.exit(unittest.main())

# vim: set fileencoding=utf-8 ts=4 sw=4 tw=0 et :
