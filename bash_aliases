
alias ob="vim ~/.bashrc"
alias sb=". ~/.bashrc"
alias gccpre="g++ -E -dM - </dev/null"
alias tmux="tmux -2"
alias grun='CLASSPATH=`python -c "import carbon; print carbon.CLASSPATH"` java org.antlr.v4.runtime.misc.TestRig'

function upfind
{
    pushd `pwd` &>/dev/null
    while [[ $PWD != "/" ]] ; do
        find "$PWD"/ -maxdepth 1 -name "$@"
        cd ..
    done
    popd &>/dev/null
}

export -f vim
export -f upfind
