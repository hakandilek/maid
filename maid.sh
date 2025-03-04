#!/bin/sh

# This script calls the Makefile in the same folder with the passed arguments.

make --makefile="$(dirname "$0")/Makefile" "$@"
