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

function gitroot
{
    DIR=`upfind .git`
    if [[ "$DIR" == "" ]]; then
        echo `pwd`
    else
        echo `dirname $DIR`
    fi
}

function bootscons
{
    local force="false"
    local raw_defs=()
    local raw_opts=()
    local raw_sources=()
    local target=$(basename $(pwd))
    local cppstd="c++11"

    local OPTIND
    while getopts ":cd:fho:s:t:" OPT; do
        case $OPT in
            c) cppstd="$OPTARG" ;;
            d) raw_defs+=("$OPTARG") ;;
            f) force="true" ;;
            o) raw_opts+=("$OPTARG") ;;
            s) raw_sources+=("$OPTARG") ;;
            t) target="$OPTARG" ;;
            h) cat <<-EOH; return 1 ;;
A quick and dirty command to generate a skeleton SConstruct for test projects.

Usage: bootscons [options]
  -c        Set the C++ standard to use (default: $cppstd)
  -d        Key/value pair of a define (-D) to add to compilation (repeatable)
  -f        Force the SConstruct generation, even if it exists already
  -o        Key/value pair of a flag to add to compilation (repeatable)
  -s        Source files to glob into compilation (repeatable)
  -t        Target binary to generate (default: $target, current dir name)
  -h        Display usage (this text)

E.g. scons -d FEAT1=on -d FEAT2=off -o -someflag -s "*.cpp" -t foo
EOH
            :) die "Error - Option -$OPTARG requires an argument." ;;
            ?) die "Error - Invalid option -$OPTARG (see -h for help)." ;;
        esac
    done

    test "$force" != "true" && test -e "SConstruct" && {
        echo "An SConstruct already exists, not proceeding - Delete it first"
        echo "if you want to proceed with SConstruct generation."
        return 1
    }

    if [[ ${#raw_sources[@]} -eq 0 ]]; then
        raw_sources=("*.c*")
    fi

    sources=""
    for source in "${raw_sources[@]}"; do
        test -z "$sources" || raw_sources+=" + "
        sources+="Glob(\"$source\")"
    done

    opts=""
    for opt in "${raw_opts[@]}"; do
        test -z "$opts" || opts+=$'\n'
        key=$(echo "$opt" | cut -s -d'=' -f1)
        val=$(echo "$opt" | cut -s -d'=' -f2)
        opts+="env.AppendUnique($key=[\"$val\"])"
    done

    defs=""
    for def in "${raw_defs[@]}"; do
        test -z "$defs" || defs+=$'\n'
        key=$(echo "$def" | cut -s -d'=' -f1)
        val=$(echo "$def" | cut -s -d'=' -f2)
        defs+="env.AppendUnique(CPPDEFINES={\"$key\": \"$val\"})"
    done

    cat <<-EOH > SConstruct
import os
vars = Variables()
vars.AddVariables(
    EnumVariable(
        'mode', 'Optimisation mode to build targets in (e.g. release)',
        'debug', allowed_values=('debug', 'release'),
        map={'d': 'debug', 'r': 'release'}, ignorecase=2
    )
)

env = Environment(ENV=os.environ, variables=vars, tools=['default', 'textfile'])
Help("Displaying help:\n" + vars.GenerateHelpText(env, sort=True))
env.AppendUnique(CPPPATH=['.'])
env.AppendUnique(CXXFLAGS='-std=$cppstd')

if 'debug' == env['mode']:
    flags = ['-ggdb', '-O0', '-g3', '-fno-inline']
    defs = {}
else:
    flags = ['-g2', '-O3']
    defs = {'NDEBUG': 1, '_NDEBUG': 1}
env.AppendUnique(CCFLAGS=flags, CPPDEFINES=defs)
env.AppendUnique(CCFLAGS=['-Wall', '-Wextra'])
$opts
$defs
env.Program(target='$target', source=$sources)
EOH
    echo "Created SConstruct with contents:"
    cat SConstruct | sed 's/^/  /'
}

export -f upfind
export -f gitroot
export -f bootscons

