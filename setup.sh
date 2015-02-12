#!/usr/bin/env bash
# Script to setup the dotfiles automagically.
SELF=$BASH_SOURCE
DIR=$(dirname "$(readlink -f "$SELF")")
BUNDLE_HOME="$HOME/.vim/bundle"
VUNDLE_HOME="$HOME/.vim/vundle"
FONTS="$HOME/.fonts"
FONTCONFIG="$HOME/.config/fontconfig/conf.d"
COLOURS="$HOME/.vim/colors"

WITH_YCM="no"

for I in "$@"; do
    case "$I" in
        with_ycm) WITH_YCM="yes" ;;
    esac
done

test "$WITH_YCM" == "no" ||
    test -d "$BUNDLE_HOME/YouCompleteMe" ||
    mkdir -p "$BUNDLE_HOME/YouCompleteMe"

echo "Symlinking dotfiles ..." &&
python $DIR/symlink.py

test -d "$VUNDLE_HOME" ||
(
    echo "Cloning Vundle repository ..." &&
    cd $HOME &&
    git clone https://github.com/gmarik/Vundle.vim $VUNDLE_HOME
) ||
(
    echo "Updating Vundle repository ..." &&
    cd $VUNDLE_HOME &&
    git pull
)

test -d "$HOME/.tomorrow-theme" ||
(
    echo "Cloning Tomorrow Night Theme ..." &&
    git clone https://github.com/chriskempson/tomorrow-theme/ .tomorrow-theme
)

test -f "$HOME/.vim/colors/Tomorrow-Night-Bright.vim" ||
(
    echo "Symlinking Tomorrow Night Theme (vim) ..." &&
    (test -d "$COLOURS" || mkdir -p "$COLOURS") &&
    find .tomorrow-theme/vim/colors/ -name '*.vim' -exec \
        sh -c 'ln -fs $(readlink -f {}) .vim/colors/$(basename {})' \;
)

which fc-cache &>/dev/null &&
if [[ $? -eq 0 ]]
then
    echo "Setting up powerline fonts ..."

    test -d "$FONTS" || mkdir -p "$FONTS"
    test -d "$FONTCONFIG" || mkdir -p "$FONTCONFIG"

    cd "$FONTS" &&
    (
        test -f PowerlineSymbols.otf ||
        wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
    )

    cd "$FONTCONFIG" &&
    (
        test -f 10-powerline-symbols.conf ||
        wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
    )

    fc-cache -vf "$FONTS"
fi

echo "Executing Vundle plugin installation ..." &&
vim +PluginInstall +qall

which -v clang &>/dev/null
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
