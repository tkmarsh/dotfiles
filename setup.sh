#!/usr/bin/env bash
DIR=$(dirname "$(readlink -f "$0")")
python27 $DIR/symlink.py
