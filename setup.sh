#!/usr/bin/env bash
# Script to setup the dotfiles automagically.
SELF=$BASH_SOURCE
DIR=$(dirname "$(readlink -f "$SELF")")
python $DIR/symlink.py

pushd `pwd` &>/dev/null

cd
mkdir -p .vim
mkdir -p .vim/backup
if [[ ! -e .vim/vundle ]]
then
    echo "Cloning Vundle repository ..."
    git clone https://github.com/gmarik/Vundle.vim.git .vim/vundle
fi

if [[ ! -e tomorrow-theme ]]
then
    echo "Cloning Tomorrow Night Theme ..."
    git clone https://github.com/chriskempson/tomorrow-theme/ .tomorrow-theme
fi

echo "Symlinking Tomorrow Night Theme (vim) ..."
mkdir -p .vim/colors
find .tomorrow-theme/vim/colors/ -name '*.vim' -exec sh -c 'ln -fs $(readlink -f {}) .vim/colors/$(basename {})' \;

which fc-cache &>/dev/null
if [[ $? -eq 0 ]]
then
    echo "Setting up powerline fonts ..."
    mkdir -p .fonts/
    mkdir -p .config/fontconfig/conf.d
    cd .fonts
    if [[ ! -e PowerlineSymbols.otf ]]
    then
        wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
    fi
    cd ../.config/fontconfig/conf.d/
    if [[ ! -e 10-powerline-symbols.conf ]]
    then
        wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
    fi
    fc-cache -vf ~/.fonts/
else
    echo "Cannot setup powerline fonts because fontconfig isn't installed!"
fi

echo "Executing Vundle plugin installation ..."
vim +PluginInstall +qall

echo "Executing YouCompleteMe setup ..."
cd .vim/bundle/YouComplete
./install.sh --clang-completer --system-libclang --system-boost
cd -

popd &>/dev/null
