#!/usr/bin/env python

import os
import sys

# Work from wherever we're called
os.chdir(sys.path[0])

for filename in os.listdir('.'):
    if filename.startswith('.') and not filename.endswith('.swp'):
        symlink_name = os.path.expanduser('~/%s' % filename)
        if os.path.isfile(filename) and not os.path.exists(symlink_name):
            os.symlink(os.path.abspath(filename), symlink_name)
