
# Public key authentication (no passphrase)
#if ! `ssh-add -l | grep id_dsa &>/dev/null`; then
#    ssh-add ~/.ssh/id_dsa &>/dev/null 2>&1
#fi

LIB_X86=/usr/lib/x86_64-linux-gnu
LIB_LOCAL=/usr/local/lib
LIB_OPENMAMA=/opt/openmama/lib

set -o vi

export LD_LIBRARY_PATH=$LIB_X86:$LIB_LOCAL:$LIB_OPENMAMA
export EDITOR=vim

cmd_exists () {
    type "$1" &> /dev/null ;
}

bash ~/.xinitrc
bash ~/.bash_aliases
