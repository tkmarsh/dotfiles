#!/usr/bin/env bash
SELF=$BASH_SOURCE
DIR=$(dirname "$(readlink -f "$SELF")")
python $DIR/symlink.py

pushd `pwd`

cd
mkdir -p .vim
mkdir -p .vim/backup
if [[ ! -e .vim/vundle ]]
then
    echo "Cloning Vundle repository ..."
    git clone https://github.com/gmarik/Vundle.vim.git .vim/vundle
else
    echo "Updating Vundle repository ..."
    cd .vim/vundle
    git pull
    cd
fi

if [[ ! -e tomorrow-theme ]]
then
    echo "Cloning Tomorrow Night Theme ..."
    git clone https://github.com/chriskempson/tomorrow-theme/
else
    echo "Updating Tomorrow Night Theme ..."
    cd tomorrow-theme
    git pull
    cd
fi

if [[ ! -e .vim/colors/Tomorrow.vim ]]
then
    echo "Symlinking Tomorrow Night Theme (vim) ..."
    mkdir -p .vim/colors
    find tomorrow-theme/vim/colors/ -name '*.vim' -exec sh -c 'ln -fs $(readlink -f {}) .vim/colors/$(basename {})' \;
fi

echo "Executing Vundle plugin installation ..."
vim +PluginInstall +qall

popd
