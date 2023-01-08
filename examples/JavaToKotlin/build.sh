#!/usr/bin/env bash
#
# Copyright (c) 2018-2023 Stéphane Micheloud
#
# Licensed under the MIT License.
#

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

debug() {
    local DEBUG_LABEL="[46m[DEBUG][0m"
    $DEBUG && echo "$DEBUG_LABEL $1" 1>&2
}

warning() {
    local WARNING_LABEL="[46m[WARNING][0m"
    echo "$WARNING_LABEL $1" 1>&2
}

error() {
    local ERROR_LABEL="[91mError:[0m"
    echo "$ERROR_LABEL $1" 1>&2
}

# use variables EXITCODE, TIMER_START
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    if $TIMER; then
        local TIMER_END=$(date +'%s')
        local duration=$((TIMER_END - TIMER_START))
        echo "Total elapsed time: $(date -d @$duration +'%H:%M:%S')" 1>&2
    fi
    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

args() {
    [[ $# -eq 0 ]] && HELP=true && return 1

    for arg in "$@"; do
        case "$arg" in
        ## options
        -debug)    DEBUG=true ;;
        -help)     HELP=true ;;
        -timer)    TIMER=true ;;
        -verbose)  VERBOSE=true ;;
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        clean)     CLEAN=true ;;
        compile)   COMPILE=true ;;
        decompile) COMPILE=true && DECOMPILE=true ;;
        doc)       COMPILE=true && DOC=true ;;
        help)      HELP=true ;;
        run)       COMPILE=true && RUN=true ;;
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
    if $DECOMPILE && [ ! -x "$CFR_CMD" ]; then
        warning "cfr installation not found"
        DECOMPILE=false
    fi
    debug "Properties : PROJECT_NAME=$PROJECT_NAME PROJECT_VERSION=$PROJECT_VERSION"
    debug "Options    : TIMER=$TIMER VERBOSE=$VERBOSE"
    debug "Subcommands: CLEAN=$CLEAN COMPILE=$COMPILE DECOMPILE=$DECOMPILE HELP=$HELP RUN=$RUN"
    [[ -n "$CFR_HOME" ]] && debug "Variables  : CFR_HOME=$CFR_HOME"
    debug "Variables  : DOKKA_HOME=$DOKKA_HOME"
    debug "Variables  : JAVA_HOME=$JAVA_HOME"
    debug "Variables  : KOTLIN_HOME=$KOTLIN_HOME"
    debug "Variables  : KOTLIN_NATIVE_HOME=$KOTLIN_NATIVE_HOME"
    # See http://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/
    $TIMER && TIMER_START=$(date +"%s")
}

help() {
    cat << EOS
Usage: $BASENAME { <option> | <subcommand> }

  Options:
    -debug       show commands executed by this script
    -timer       display total elapsed time
    -verbose     display progress messages

  Subcommands:
    clean        delete generated files
    compile      compile Java/Kotlin source files
    decompile    decompile generated code with CFR
    doc          generate HTML documentation
    help         display this help message
    run          execute main class $MAIN_CLASS
EOS
}

clean() {
    if [ -d "$TARGET_DIR" ]; then
        if $DEBUG; then
            debug "Delete directory $TARGET_DIR"
        elif $VERBOSE; then
            echo "Delete directory ${TARGET_DIR/$ROOT_DIR\//}" 1>&2
        fi
        rm -rf "$TARGET_DIR"
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
}

lint() {
    echo "lint"
}

compile() {
    [[ -d "$CLASSES_DIR" ]] || mkdir -p "$CLASSES_DIR"

    local timestamp_file="$TARGET_DIR/.latest-build"

    local required=0
    required=$(action_required "$timestamp_file" "$SOURCE_DIR/main/java/" "*.java")
    if [[ $required -eq 1 ]]; then
        compile_java
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
    required=$(action_required "$timestamp_file" "$MAIN_SOURCE_DIR/" "*.kt")
    if [[ $required -eq 1 ]]; then
        compile_kotlin
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
    touch "$timestamp_file"
}

action_required() {
    local timestamp_file=$1
    local search_path=$2
    local search_pattern=$3
    local latest=
    for f in $(find $search_path -name $search_pattern 2>/dev/null); do
        [[ $f -nt $latest ]] && latest=$f
    done
    if [ -z "$latest" ]; then
        ## Do not compile if no source file
        echo 0
    elif [ ! -f "$timestamp_file" ]; then
        ## Do compile if timestamp file doesn't exist
        echo 1
    else
        ## Do compile if timestamp file is older than most recent source file
        local timestamp=$(stat -c %Y $timestamp_file)
        [[ $timestamp_file -nt $latest ]] && echo 1 || echo 0
    fi
}

compile_java() {
    local opts_file="$TARGET_DIR/javac_opts.txt"
    local cpath="$LIBS_CPATH$(mixed_path $CLASSES_DIR)"
    echo -classpath "$cpath" -d "$(mixed_path $CLASSES_DIR)" > "$opts_file"

    local sources_file="$TARGET_DIR/javac_sources.txt"
    [[ -f "$sources_file" ]] && rm "$sources_file"
    local n=0
    for f in $(find $SOURCE_DIR/main/java/ -name *.java 2>/dev/null); do
        echo $(mixed_path $f) >> "$sources_file"
        n=$((n + 1))
    done
    if $DEBUG; then
        debug "$JAVAC_CMD @$(mixed_path $opts_file) @$(mixed_path $sources_file)"
    elif $VERBOSE; then
        echo "Compile $n Java source files to directory \"${CLASSES_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "$JAVAC_CMD" "@$(mixed_path $opts_file)" "@$(mixed_path $sources_file)"
    if [[ $? -ne 0 ]]; then
        error "Compilation of $n Java source files failed"
        cleanup 1
    fi
}

compile_kotlin() {
    local opts_file="$TARGET_DIR/kotlinc_opts.txt"
    local cpath="$CLASSES_DIR"
    echo -classpath "$(mixed_path $cpath)" -d "$(mixed_path $CLASSES_DIR)" > "$opts_file"

    local sources_file="$TARGET_DIR/kotlinc_sources.txt"
    [[ -f "$sources_file" ]] && rm "$sources_file"
    local n=0
    for f in $(find $SOURCE_DIR/main/kotlin/ -name *.kt 2>/dev/null); do
        echo $(mixed_path $f) >> "$sources_file"
        n=$((n + 1))
    done
    if $DEBUG; then
        debug "$KOTLINC_CMD @$(mixed_path $opts_file) @$(mixed_path $sources_file)"
    elif $VERBOSE; then
        echo "Compile $n Kotlin source files to directory \"${CLASSES_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "$KOTLINC_CMD" "@$(mixed_path $opts_file)" "@$(mixed_path $sources_file)"
    if [[ $? -ne 0 ]]; then
        error "Compilation of $n Kotlin source files failed"
        cleanup 1
    fi
}

mixed_path() {
    if [ -x "$CYGPATH_CMD" ]; then
        $CYGPATH_CMD -am $1
    elif $mingw || $msys; then
        echo $1 | sed 's|/|\\\\|g'
    else
        echo $1
    fi
}

decompile() {
    local output_dir="$TARGET_DIR/cfr-sources"
    [[ -d "$output_dir" ]] || mkdir -p "$output_dir"

    local cfr_opts="--extraclasspath "$(extra_cpath)" --outputdir "$(mixed_path $output_dir)""

    local n="$(ls -n $CLASSES_DIR/*.class | wc -l)"
    local class_dirs=
    [[ $n -gt 0 ]] && class_dirs="$CLASSES_DIR"
    for f in $(ls -d $CLASSES_DIR 2>/dev/null); do
        n="$(ls -n $CLASSES_DIR/*.class | wc -l)"
        [[ $n -gt 0 ]] && class_dirs="$class_dirs $f"
    done
    $VERBOSE && echo "Decompile Java bytecode to directory \"${output_dir/$ROOT_DIR\//}\"" 1>&2
    for f in $class_dirs; do
        debug "$CFR_CMD $cfr_opts $(mixed_path $f)/*.class"
        eval "$CFR_CMD" $cfr_opts "$(mixed_path $f)/*.class" $STDERR_REDIRECT
        if [[ $? -ne 0 ]]; then
            error "Failed to decompile generated code in directory $f"
            cleanup 1
        fi
    done
    local version_list=($(version_string))
    local version_string="${version_list[0]}"
    local version_suffix="${version_list[1]}"

    ## output file contains Kotlin and CFR headers
    local output_file="$TARGET_DIR/cfr-sources$version_suffix.java"
    echo // Compiled with $version_string > "$output_file"

    if $DEBUG; then
        debug "echo $output_dir/*.java >> $output_file"
    elif $VERBOSE; then
        echo "Save generated Java source files to file ${output_file/$ROOT_DIR\//}" 1>&2
    fi
    local java_files=
    for f in $(find $output_dir/ -name *.java 2>/dev/null); do
        java_files="$java_files $(mixed_path $f)"
    done
    [[ -n "$java_files" ]] && cat $java_files >> "$output_file"

    if [ ! -x "$DIFF_CMD" ]; then
        if $DEBUG; then
            warning "diff command not found"
        elif $VERBOSE; then
            echo "diff command not found" 1>&2
        fi
        return 0
    fi
    local diff_opts=--strip-trailing-cr

    local check_file="$SOURCE_DIR/build/cfr-source$VERSION_SUFFIX.java"
    if [ -f "$check_file" ]; then
        if $DEBUG; then
            debug "$DIFF_CMD $diff_opts $(mixed_path $output_file) $(mixed_path $check_file)"
        elif $VERBOSE; then
            echo "Compare output file with check file ${check_file/$ROOT_DIR\//}" 1>&2
        fi
        eval "$DIFF_CMD" $diff_opts "$(mixed_path $output_file)" "$(mixed_path $check_file)"
        if [[ $? -ne 0 ]]; then
            error "Output file and check file differ"
            cleanup 1
        fi
    fi
}

## output parameter: _EXTRA_CPATH
extra_cpath() {
    local extra_cpath=
    for f in $(ls $KOTLIN_HOME/lib/*.jar); do
        extra_cpath="$extra_cpath$(mixed_path $f)$PSEP"
    done
    echo $extra_cpath
}

## output parameter: ($version $suffix)
version_string() {
    local tool_version="$($KOTLINC_CMD -version 2>&1 | cut -d " " -f 3)"
    local version="kotlin_$tool_version"                                
    local suffix="$tool_version"
    local arr=($version $suffix)
    echo "${arr[@]}"
}

doc() {
    [[ -d "$TARGET_DOCS_DIR" ]] || mkdir -p "$TARGET_DOCS_DIR"

    local doc_timestamp_file="$TARGET_DOCS_DIR/.latest-build"

    local required="$(action_required "$doc_timestamp_file" "$MAIN_SOURCE_DIR/" "*.kt")"
    [[ $required -eq 0 ]] && return 1

    ## see https://github.com/Kotlin/dokka/releases
    DOKKA_CPATH="/c/opt/dokka-cli-1.4.0/dokka-cli-1.4.0.jar"
    DOKKA_JAR="/c/opt/dokka-cli-1.4.0/dokka-cli-1.4.0.jar"
    local args="-src $(mixed_path $MAIN_SOURCE_DIR)"
    local dokka_args="-pluginsClasspath $(mixed_path $DOKKA_CPATH) -moduleName $PROJECT_NAME -moduleVersion $PROJECT_VERSION -outputDir $(mixed_path $TARGET_DOCS_DIR) -sourceSet \"$args\""
    if $DEBUG; then
        debug "$JAVA_CMD -jar $(mixed_path $DOKKA_JAR) $dokka_args"
    elif $VERBOSE; then
        echo "Generate HTML documentation into directory ${TARGET_DOCS_DIR/$ROOT_DIR\//}" 1>&2
    fi
    eval "$JAVA_CMD" -jar "$(mixed_path $DOKKA_JAR)" $dokka_args
    if [[ $? -ne 0 ]]; then
        error "Generation of HTML documentation failed"
        cleanup 1
    fi
    if $DEBUG; then
        debug "HTML documentation saved into directory $TARGET_DOCS_DIR"
    elif $VERBOSE; then
        echo "HTML documentation saved into directory ${TARGET_DOCS_DIR/$ROOT_DIR\//}" 1>&2
    fi
    touch "$doc_timestamp_file"
}

run() {
    local main_class_file="$CLASSES_DIR/${MAIN_CLASS//.//}.class"
    if [[ ! -f "$main_class_file" ]]; then
        error "Kotlin main class '$MAIN_CLASS' not found ($main_class_file)"
        cleanup 1
    fi
    local kotlin_opts="-classpath $(mixed_path $CLASSES_DIR)"

    if $DEBUG; then
        debug "$KOTLIN_CMD $kotlin_opts $MAIN_CLASS $MAIN_ARGS"
    elif $VERBOSE; then
        echo "Execute Kotlin main class $MAIN_CLASS" 1>&2
    fi
    eval "$KOTLIN_CMD" $kotlin_opts $MAIN_CLASS $MAIN_ARGS
    if [[ $? -ne 0 ]]; then
        error "Program execution failed ($MAIN_CLASS)"
        cleanup 1
    fi
}

run_tests() {
    echo "tests"
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

ROOT_DIR="$(getHome)"

SOURCE_DIR=$ROOT_DIR/src
MAIN_SOURCE_DIR=$SOURCE_DIR/main/kotlin
TARGET_DIR=$ROOT_DIR/target
TARGET_DOCS_DIR=$TARGET_DIR/docs
CLASSES_DIR=$TARGET_DIR/classes

CLEAN=false
COMPILE=false
DEBUG=false
DECOMPILE=false
DOC=false
HELP=false
MAIN_CLASS="MainKt"
MAIN_ARGS=
RUN=false
SCALA_VERSION=3
SCALAC_OPTS_PRINT=false
TASTY=false
TEST=false
TIMER=false
VERBOSE=false

COLOR_START="[32m"
COLOR_END="[0m"

cygwin=false
mingw=false
msys=false
darwin=false
case "`uname -s`" in
  CYGWIN*) cygwin=true ;;
  MINGW*)  mingw=true ;;
  MSYS*)   msys=true ;;
  Darwin*) darwin=true      
esac
unset CYGPATH_CMD
PSEP=":"
if $cygwin || $mingw || $msys; then
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
    PSEP=";"
    [[ -n "$CFR_HOME" ]] && CFR_HOME="$(mixed_path $CFR_HOME)"
    [[ -n "$JAVA_HOME" ]] && JAVA_HOME="$(mixed_path $JAVA_HOME)"
    [[ -n "$KOTLIN_HOME" ]] && KOTLIN_HOME="$(mixed_path $KOTLIN_HOME)"
    [[ -n "$KTLINT_HOME" ]] && KTLINT_HOME="$(mixed_path $KTLINT_HOME)"
    [[ -n "$DOKKA_HOME" ]] && DOKKA_HOME="$(mixed_path $DOKKA_HOME)"
    DIFF_CMD="$GIT_HOME/usr/bin/diff.exe"
else
    DIFF_CMD="$(which diff)"
fi
if [ ! -x "$JAVA_HOME/bin/javac" ]; then
    error "Java SDK installation not found"
    cleanup 1
fi
JAVA_CMD="$JAVA_HOME/bin/java"
JAVAC_CMD="$JAVA_HOME/bin/javac"
JAVADOC_CMD="$JAVA_HOME/bin/javadoc"

if [ ! -x "$KOTLIN_HOME/bin/kotlinc" ]; then
    error "Kotlin installation not found"
    cleanup 1
fi
KOTLIN_CMD="$KOTLIN_HOME/bin/kotlin"
KOTLINC_CMD="$KOTLIN_HOME/bin/kotlinc"

PROJECT_NAME="$(basename $ROOT_DIR)"
PROJECT_URL="github.com/$USER/kotlin-examples"
PROJECT_VERSION="1.0-SNAPSHOT"

unset KTLINT_CMD
[ -x "$KTLINT_HOME/bin/ktlint" ] && KTLINT_CMD="$KTLINT_HOME/bin/ktlint"

unset CFR_CMD
[ -x "$CFR_HOME/bin/cfr" ] && CFR_CMD="$CFR_HOME/bin/cfr"

args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1
##############################################################################
## Main

$HELP && help && cleanup

if $CLEAN; then
    clean || cleanup 1
fi
if $COMPILE; then
    compile || cleanup 1
fi
if $DECOMPILE; then
    decompile || cleanup 1
fi
if $DOC; then
    doc || cleanup 1
fi
if $RUN; then
    run || cleanup 1
fi
if $TEST; then
    run_tests || cleanup 1
fi
cleanup
