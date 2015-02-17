#!/usr/bin/env bash
# Script to setup the dotfiles automagically.
SELF=$BASH_SOURCE
DIR=$(dirname "$(readlink -f "$SELF")")
BUNDLE_HOME="$HOME/.vim/bundle"
VUNDLE_HOME="$HOME/.vim/vundle"
FONTS="$HOME/.fonts"

WITH_YCM="no"

for I in "$@"; do
    case "$I" in
        with_ycm) WITH_YCM="yes" ;;
    esac
done

test "$WITH_YCM" == "no" ||
    test -d "$BUNDLE_HOME/YouCompleteMe" ||
    mkdir -p "$BUNDLE_HOME/YouCompleteMe"

echo "Setting up dotfiles ..." &&
python $DIR/symlink.py

which fc-cache &>/dev/null &&
test -d "$FONTS" &&
(
    echo "Setting up fonts ..." &&
    (
        fc-cache -vf "$FONTS" &>/dev/null ||
        echo "Failed to setup fonts!"
    )
)

test -d "$VUNDLE_HOME" ||
(
    cd $HOME &&
    git clone https://github.com/gmarik/Vundle.vim $VUNDLE_HOME &>/dev/null
) ||
(
    cd $VUNDLE_HOME &&
    git pull &>/dev/null
)

echo "Setting up vundle (vim plugins) ..." &&
vim +PluginInstall +qall

command -v clang &>/dev/null
if [ $? -eq 0 ]; then
    SYSTEM_CLANG="--system-libclang"
else
    SYSTEM_CLANG=""
fi

test "$WITH_YCM" == "no" ||
(
    cd $HOME &&
    test -d "$BUNDLE_HOME/YouCompleteMe" &&
    echo "Executing YouCompleteMe setup ..." &&
    cd "$BUNDLE_HOME/YouCompleteMe" &&
    ./install.sh --clang-completer --system-boost $SYSTEM_CLANG
)
