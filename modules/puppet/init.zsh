#
# Defines puppet aliases and functions.
#
# Authors:
#   Andrew Stangl <andrewstangl@gmail.com>

#
# Aliases
#

# Finds files and executes a command on them.
function puppet-parse {
  for file in `find . -name '*.pp'`; do echo $file; puppet parser validate $file; done
}

