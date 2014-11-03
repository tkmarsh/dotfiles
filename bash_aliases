
alias ob="vim ~/.bashrc"
alias sb=". ~/.bashrc"
alias gccpre="g++ -E -dM - </dev/null"
alias tmux="tmux -2"
alias grun='CLASSPATH=`python -c "import carbon; print carbon.CLASSPATH"` java org.antlr.v4.runtime.misc.TestRig'

function vim
{
    function in_s3fsmount
    {
        MOUNT=$(mount | sed -n '/^s3fs/p' | awk '{print $3}')
        echo "${1:-`pwd`}" | grep -q "^${MOUNT}$"
        test $? -eq 0 && return 1 || return 0
    }

    INS3=0

    if [ $# -gt 0 ]; then
        for I in $@
        do
            DIR=$(dirname $(readlink -f $I))
            in_s3fsmount $DIR
            if [[ $? -eq 1 ]]
            then
                INS3=1
                break
            fi
        done
    else
        in_s3fsmount $DIR
        INS3=$?
    fi

    if [[ ${INS3:-0} -eq 1 ]]
    then
        echo "Disabling plugins due to being within s3fs mount ..."
        OPTS="--noplugin"
    fi

    command vim ${OPTS:-""}$*
    unset OPTS
}
