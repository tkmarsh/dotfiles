#!/usr/bin/env bash
pushd `pwd` &>/dev/null
while [[ $PWD != "/" ]] ; do
    find "$PWD"/ -maxdepth 1 -name "$@"
    cd ..
done
popd &>/dev/null
