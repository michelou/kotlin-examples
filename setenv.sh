#!/usr/bin/env bash

## Usage: $ . ./setenv.sh

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [ -h "$source" ] ; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

getOS() {
    local os
    case "$(uname -s)" in
        Linux*)  os=linux;;
        Darwin*) os=mac;;
        CYGWIN*) os=cygwin;;
        MINGW*)  os=mingw;;
        *)       os=unknown
    esac
    echo $os
}

getPath() {
    local path=""
    for i in $(ls -d "$1"*/ 2>/dev/null); do path=$i; done
    # ignore trailing slash introduced in for loop
    [[ -z "$path" ]] && echo "" || echo "${path::-1}"
}

##############################################################################
## Environment setup

PROG_HOME="$(getHome)"

OS="$(getOS)"
[[ $OS == "unknown" ]] && { echo "Unsuppored OS"; exit 1; }

if [[ $OS == "cygwin" || $OS == "mingw" ]]; then
    [[ $OS == "cygwin" ]] && prefix="/cygdrive" || prefix=""
    export HOME=$prefix/c/Users/$USER
    export ANT_HOME="$(getPath "$prefix/c/opt/apache-ant-1")"
    export GIT_HOME="$(getPath "$prefix/c/opt/Git-2")"
    ## export JAVA_HOME="$(getPath "$prefix/c/opt/jdk-openjdk-11")"
    export JAVA_HOME="$(getPath "$prefix/c/opt/jdk-openjdk-1.8")"
    export KOTLIN_HOME="$(getPath "$prefix/c/opt/kotlinc-1.4")"
    export CFR_HOME="$(getPath "$prefix/c/opt/cfr-0.15")"
    PATH1="$PATH"
    [[ -x "$ANT_HOME/bin/ant" ]] && PATH1="$PATH1:$ANT_HOME/bin"
    [[ -x "$GIT_HOME/bin/git" ]] && PATH1="$PATH1:$GIT_HOME/bin"
    export PATH="$PATH1"
else
    ## export JAVA_HOME=/opt/jdk-1.8
    export KOTLIN_HOME=/opt/kotlinc
fi
## echo "KOTLIN_HOME=$KOTLIN_HOME"
