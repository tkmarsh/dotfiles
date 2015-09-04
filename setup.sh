#!/usr/bin/env bash
# Script to setup the dotfiles automagically.
self=$(readlink -f "$BASH_SOURCE")
self_name=$(basename "$self")
self_dir=$(dirname "$self")
root_dir="$self_dir"
orig_dir=`pwd`

#
# FUNCTIONS
#

function die {
    echo $@ 1>&2
    exit 1
    return 1
}

function tool_exists {
    which $1 &>/dev/null
    if [[ $? -ne 0 ]]; then
        die "$1 is not installed!!"
    fi
}

function check_failure {
    local rc=${1:-$?}
    test $? -eq 0 || die " - Failed!"
    return 1
}

function skip_setup {
    local no_force_reason="$1"
    if [[ -z "no_force_reason" ]]; then
        test "$force" == "true" && return 1
        echo " - Already setup, use -f (force) to force setup again."
    else
        echo " - Already setup, can't be forced: ${no_force_reason}."
    fi
    return 0
}

function is_link_only {
    test "$link_only" == "true"
}

function is_desktop_mode {
    test "$mode" == "desktop"
}

function is_stage_active {
    local requested="$1"
    # Check explicitly excluded
    while read -r stage; do
        test "$stage" == "$requested" && return 1
    done <<< "$exclude"
    # Check explicitly included
    while read -r stage; do
        test "$stage" == "all" && return 0
        test "$stage" == "$requested" && return 0
    done <<< "$include"
    return 1
}

function is_sudo {
    [ "$(id -u)" -eq 0 ] || return 1
    [ "$SUDO_USER" != "" ] || return 1
    return 0
}

function ensure_sudo {
    is_sudo || die "You must run this script as sudo!"
}

function run_as_sudo {
    ensure_sudo
    sudo -H $*
}

function run_as_user {
    is_sudo && {
        sudo -u $SUDO_USER $*
    } || {
        $*
    }
}

function sync_git {
    local url="$1"
    local dir="${2:-$(basename $url)}"
    echo " - Synchronising $url ..."
    local exists="false"
    (test -d "$dir/.git" &&
        run_as_user git --git-dir "$dir/.git" status &>/dev/null) && {
        exists="true"
        (cd "$dir" && run_as_user git pull 1>/dev/null)
    } || (run_as_user git clone "$url" "$dir" 1>/dev/null)
    check_failure
    test "$exists" == "true" && return 2
    return 0
}

function is_desktop {
    test "$mode" == "desktop"
    return $?
}

function setup_colours {
    is_desktop || return 0
    is_stage_active "colours" || return 0
    echo
    echo "Setting up colours..."
    local solarized_home="$HOME/.vim/solarized"
    sync_git \
        "https://github.com/Anthony25/gnome-terminal-colors-solarized" \
        "$solarized_home"
    test $? -ne 0 && skip_setup && return 0
    "$solarized_home/set_dark.sh" | sed 's/^/ - /g'
    check_failure || echo " - OK!"
}

function setup_dotfiles {
    is_stage_active "dotfiles" || return 0
    echo
    echo "Setting up dotfiles..."
    run_as_user python $self_dir/symlink.py 1>/dev/null
    check_failure || echo " - OK!"
}

function setup_fonts {
    is_desktop || return 0
    is_stage_active "fonts" || return 0
    which fc-cache &>/dev/null || return 0
    echo
    echo "Setting up fonts..."
    local fonts_home="$HOME/.fonts"
    test -d "$fonts_home" && skip_setup && return 0
    run_as_user fc-cache -vf "$fonts_home" 1>/dev/null
    check_failure || echo " - OK!"
}

function setup_libgcrypt11 {
    is_desktop_mode || return 0
    is_stage_active "libgcrypt11" || return 0
    echo
    echo "Setting up libgcrypt11..."
    dpkg -l | grep libgcrypt11 &>/dev/null &&
        skip_setup "uninstall libgcrypt11 instead" && return 0
    local tmp_dir=$(mktemp -d)
    local deb_file="libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb"
    wget "https://launchpad.net/ubuntu/+archive/primary/+files/$deb_file" \
        -O "$tmp_dir/$deb_file"
    run_as_sudo dpkg -i "$tmp_dir/$deb_file"
}

function setup_packages {
    is_desktop_mode || return 0
    is_stage_active "packages" || return 0
    echo
    echo "Setting up packages..."
    while read -r package; do
        echo " - Installing $package..."
        run_as_sudo apt-get install $package 1>/dev/null
    done < <(cat "$self_dir/packages.txt")
    check_failure || echo " - OK!"
}

function setup_pip {
    is_stage_active "pip" || return 0
    echo
    echo "Setting up pip..."
    (is_sudo && run_as_sudo pip install --upgrade pip 1>/dev/null) ||
        (is_sudo || run_as_user pip install --user --upgrade pip 1>/dev/null)
    check_failure || echo " - OK!"
}

function setup_ycm {
    is_desktop_mode || return 0
    is_stage_active "ycm" || return 0
    local create_only="$1"
    local bundle_home="$HOME/.vim/bundle"
    local ycm_home="$bundle_home/YouCompleteMe"
    if [[ "$create_only" == "true" ]]; then
        run_as_user mkdir -p "$ycm_home" &>/dev/null
        return 0
    else
        test -d "$ycm_home" ||
            die "YouCompleteMe home doesn't exist: $ycm_home"
    fi

    echo
    echo "Setting up YouCompleteMe (might take awhile)..."

    local ycmd_home="$ycm_home/third_party/ycmd"
    test -f "$ycmd_home/ycm_core.so" &&
        test -f "$ycmd_home/ycm_client_support.so" &&
        skip_setup && return 0

    (cd $ycm_home &&
        run_as_user ./install.py --clang-completer 1>/dev/null | sed 's/^/ - /')
    check_failure || echo " - OK!"
}

function setup_vundle {
    is_stage_active "vundle" || return 0
    echo
    echo "Setting up Vim Bundle (Vundle)..."
    vundle_repo="https://github.com/VundleVim/Vundle.vim"
    vundle_home="$HOME/.vim/vundle"
    sync_git "$vundle_repo" "$vundle_home"
    run_as_user vim -c PluginInstall -c qall
    check_failure || echo " - OK!"
}

function usage {
    cat <<-EOH
Setup dotfiles and environment.

Usage: ./$self_name [options]
  -e <stages(s)> A CSV-list of stages to exclude (default: $exclude).
                   See -i for a full list of stages.
  -f             Force setup (by default anything that has already been setup
                   before will be skipped.)
  -m <mode>      Mode to setup (desktop/server, default: $mode)
                   This influences what is installed, where server mode
                   is for headless or terminal-only servers, possibly
                   without sudo access.  See -i for a full list of stages.
  -i <stage(s)> A CSV-list of stages to execute (default: $include)
                   Stages (asterisks are desktop-only):
                    - dotfiles: Link dotfiles.
                    * colours: Setup terminal colours.
                    * fonts: Setup terminal fonts.
                    * libgcrypt11: Setup libgcrypt11 (Ubuntu 15.04+ only).
                    * packages: Install packages from packages.txt
                    - pip: Install pip/python packages from requirements.txt
                    - vundle: Install Vim Bundle (Vundle) plugins.
                    * ycm: Install YouCompleteMe (requires vundle installation).
                   E.g. to only link dotfiles, use -i dotfiles.
  -h           Display usage (this text)

EOH
    exit 0
}

#
# START MAIN SCRIPT
#

# Variables
force="false"
mode="desktop"
include=$(cat "$self_dir/stages.txt" | grep -oP "(?<=include=).*" | head -n 1)
exclude=$(cat "$self_dir/stages.txt" | grep -oP "(?<=exclude=).*" | head -n 1)

# Get options
while getopts ":e:fhi:m:" OPT; do
    case $OPT in
        e) exclude="$OPTARG" ;;
        f) force="true" ;;
        h) usage ;;
        i) include="$OPTARG" ;;
        m) mode="$OPTARG" ;;
        :) die "Error - Option -$OPTARG requires an argument." ;;
        ?) die "Error - Invalid option -$OPTARG (see -h for help)." ;;
    esac
done

# Cleanup after completion
function finish {
    cd $orig_dir
}

trap finish exit

setup_packages
setup_ycm "true"

# Check required tools
tool_exists cmake
tool_exists git
tool_exists pip
tool_exists python

setup_dotfiles
setup_pip
setup_vundle
setup_fonts
setup_colours
setup_libgcrypt11
setup_ycm

# https://github.com/Anthony25/gnome-terminal-colors-solarized
echo
echo "You're ready to rock!"
echo
echo "Try sourcing your .bashrc ('. ~/.bashrc') or restarting your shell."
