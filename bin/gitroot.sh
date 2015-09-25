#!/usr/bin/env bash
DIR=`upfind .git`
if [[ "$DIR" == "" ]]; then
    echo `pwd`
else
    echo `dirname $DIR`
fi
