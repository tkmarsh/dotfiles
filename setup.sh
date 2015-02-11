#!/usr/bin/env bash
# Script to setup the dotfiles automagically.
SELF=$BASH_SOURCE
DIR=$(dirname "$(readlink -f "$SELF")")
BUNDLE_HOME="$HOME/.vim/bundle"
FONTS="$HOME/.fonts"
FONTCONFIG="$HOME/.config/fontconfig/conf.d"
COLOURS="$HOME/.vim/colors"

echo "Symlinking dotfiles ..."
python $DIR/symlink.py

test -d "$BUNDLE_HOME" ||
(
    echo "Cloning Vundle repository ..." &&
    cd $HOME &&
    git clone https://github.com/gmarik/Vundle.vim .vim/vundle
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

which -v clang &>/dev/null &&
cd $HOME &&
test -d "$BUNDLE_HOME/YouCompleteMe" &&
echo "Executing YouCompleteMe setup ..." &&
cd "$BUNDLE_HOME/YouCompleteMe" &&
./install.sh --clang-completer --system-libclang --system-boost
