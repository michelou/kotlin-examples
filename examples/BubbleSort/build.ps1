#!/usr/bin/env pwsh
#
# Copyright (c) 2018-2026 Stéphane Micheloud
#
# Licensed under the MIT License.
#

## https://powershellisfun.com/2023/04/24/using-the-requires-statement-in-powershell/
#Requires -Version 5.1

## only for interactive debugging !
$DEBUG = $false

#########################################################################
## Environment setup

$EXITCODE = 0

$BAT = ""
$EXE = ""
if ($PSVersionTable.PSVersion -lt "6.0" -or $IsWindows) {
  # Fix case when both the Windows and Linux builds of this program
  # are installed in the same directory.
  $BAT = '.bat'
  $EXE = '.exe'
}

$BASENAME = (Get-Item $PSScriptRoot).Basename
$ROOT_DIR = $PSScriptRoot
$PATH_SEP = [IO.Path]::PathSeparator
$SEP      = [IO.Path]::DirectorySeparatorChar

$SOURCE_DIR        = Join-Path -Path $ROOT_DIR   -ChildPath 'src'
$SOURCE_JAVA_DIR   = [IO.Path]::Combine($SOURCE_DIR, 'main', 'java')
$SOURCE_KOTLIN_DIR = [IO.Path]::Combine($SOURCE_DIR, 'main', 'kotlin')
$TARGET_DIR        = Join-Path -Path $ROOT_DIR   -ChildPath 'target'
$TARGET_DOCS_DIR   = Join-Path -Path $TARGET_DIR -ChildPath 'docs'
$CLASSES_DIR       = Join-Path -Path $TARGET_DIR -ChildPath 'classes'

$DETEKT_CMD = $Env:DETEKT_HOME + $SEP + 'bin' + $SEP + 'detekt-cli' + $BAT
if (! (Test-Path -PathType Leaf -Path $DETEKT_CMD)) {
    Write-Error "Detekt command not found (check variable ""DETEKT_HOME"")"
    Cleanup 1
}
$JAVAC_CMD = $Env:JAVA_HOME + $SEP + 'bin' + $SEP + 'javac' + $EXE
if (! (Test-Path -PathType Leaf -Path $JAVAC_CMD)) {
    Write-Error "Java installation not found (check variable ""JAVA_HOME"")"
    Cleanup 1
}
$JAVA_CMD = $Env:JAVA_HOME + $SEP + 'bin' + $SEP + 'java' + $EXE

$KOTLINC_CMD = $Env:KOTLIN_HOME + $SEP + 'bin' + $SEP + 'kotlinc' + $BAT
if (! (Test-Path -PathType Leaf -Path $KOTLINC_CMD)) {
    Write-Error "Kotlin installation not found (check variable ""KOTLIN_HOME"")"
    Cleanup 1
}
$KOTLIN_CMD = $Env:KOTLIN_HOME + $SEP + 'bin' + $SEP + 'kotlin' + $BAT

$KOTLINC_NATIVE_CMD = $Env:KOTLIN_NATIVE_HOME + $SEP + 'bin' + $SEP + 'kotlinc-native' + $BAT
if (! (Test-Path -PathType Leaf -Path $KOTLINC_NATIVE_CMD)) {
    Write-Error "Kotlin Native installation not found (check variable ""KOTLIN_NATIVE_HOME"")"
    Cleanup 1
}
$CFR_CMD = $Env:CFR_HOME + $SEP + 'bin' + $SEP + 'cfr'
if (! (Test-Path -PathType Leaf -Path $CFR_CMD)) {
    $CFR_CMD = $null
}
$PS_VERSION = $PSVersionTable.PSVersion.ToString() 
$PROJECT_NAME = $BASENAME
$PROJECT_URL = "github.com/$USER/kotlin-examples"
$PROJECT_VERSION = '1.0-SNAPSHOT'

## https://kotlinlang.org/docs/compatibility-guide-22.html
$LANGUAGE_VERSION=2.2

#########################################################################
## Script arguments

$COMMANDS = @()

## Possible values: SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend
$DebugPreference   = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
$WarningPreference = 'Continue'

$HELP = $false
$TARGET = 'jvm'
$TIMER = $false
$VERBOSE = $false
$N = 0
foreach ($ARG in $args) {
    if ($ARG.StartsWith('-')) {
        ## option
        if ($ARG -ieq '-debug') { $DEBUG = $true; $DebugPreference='Continue'
        } elseif ($ARG -ieq '-help'   ) { $HELP = $true
        } elseif ($ARG -ieq '-jvm'    ) { $TARGET = 'jvm'
        } elseif ($ARG -ieq '-native' ) { $TARGET = 'native'
        } elseif ($ARG -ieq '-timer'  ) { $TIMER = $true
        } elseif ($ARG -ieq '-verbose') { $VERBOSE = $true; $VerbosePreference = 'Continue'
        } else {
            Write-Error "Unknown option ""$ARG"""
            $EXITCODE = 1
            break
        }
    } else {
        ## subcommand
        if ($ARG -ieq 'clean') { $COMMANDS += 'Clean'
        } elseif ($ARG -ieq 'compile') { $COMMANDS += 'Compile'
        } elseif ($ARG -ieq 'doc' ) { $COMMANDS += 'Compile', 'Doc'
        } elseif ($ARG -ieq 'help') { $HELP = $true
        } elseif ($ARG -ieq 'lint') { $COMMANDS += 'Lint'
        } elseif ($ARG -ieq 'run' ) { $COMMANDS += 'Compile', 'Run'
        } elseif ($ARG -ieq 'test') { $COMMANDS += 'Compile', 'Test'
        } else {
            Write-Error "Unknown subcommand ""$ARG"""
            $EXITCODE = 1
            break
        }
        $N++
    }
}
## Source name and class name may differ
$MAIN_NAME = 'Main'
$MAIN_CLASS = $PROJECT_NAME + 'Kt'
$MAIN_ARGS = $null
$EXE_FILE = $TARGET_DIR + $SEP + $PROJECT_NAME + $EXE

if ($COMMANDS -contains 'Lint') {
    if (! $SCALAFMT_CMD) {
        Write-Warning "Scalafmt command not found (installation managed by Coursier)"
        $COMMANDS = $COMMANDS.Replace('Lint', '')
    } elseif (! $SCALAFMT_CONFIG_FILE) {
        Write-Warning "Scalafmt configuration file not found"
        $COMMANDS = $COMMANDS.Replace('Lint', '')
    }
}
if ($COMMANDS -contains 'Decompile' -and ! $CFR_CMD) {
    Write-Warning "CFR command not found (check variable CFR_HOME)"
    $COMMANDS = $COMMANDS.Replace('Decompile', '')
}
Write-Debug "Properties : PROJECT_NAME=$PROJECT_NAME PROJECT_VERSION=$PROJECT_VERSION PS_VERSION=$PS_VERSION"
Write-Debug "Options    : DEBUG=$DEBUG TARGET=$TARGET TIMER=$TIMER VERBOSE=$VERBOSE"
Write-Debug "Subcommands: $COMMANDS"
if ($CFR_CMD) { Write-Debug "Variables  : ""CFR_HOME=$Env:CFR_HOME""" }
Write-Debug "Variables  : ""GIT_HOME=$Env:GIT_HOME"""
Write-Debug "Variables  : ""JAVA_HOME=$Env:JAVA_HOME"""
Write-Debug "Variables  : ""KOTLIN_HOME=$Env:KOTLIN_HOME"""
Write-Debug "Variables  : ""KOTLIN_NATIVE_HOME=$Env:KOTLIN_NATIVE_HOME"""
Write-Debug "Variables  : MAIN_NAME=$MAIN_NAME MAIN_CLASS=$MAIN_CLASS MAIN_ARGS=$MAIN_ARGS"

if ($TIMER) { $TIMER_START = Get-Date }

#########################################################################
## Subroutines

function Main
{
    if ($HELP) {
        Print-Help
        Cleanup $EXITCODE
    }
    foreach($COMMAND in $COMMANDS) {
        &$COMMAND
        if ($EXITCODE -ne 0) { exit $EXITCODE }
    }
    if ($TIMER) {
        $DURATION = New-TimeSpan -Start $TIMER_START -End (Get-Date)
        Write-Output "Total execution time: $DURATION"
    }
    Cleanup $EXITCODE
}

function Print-Help
{
    Write-Output "Usage: $BASENAME { <option> | <subcommand> }"
    Write-Output ""
    Write-Output "   Options:"
    Write-Output "     -debug      print commands executed by this script"
    Write-Output "     -help       print this help message"
    Write-Output "     -jvm        generate class files"
    Write-Output "     -native     generate native executable"
    Write-Output "     -timer      print total execution time"
    Write-Output "     -verbose    print progress messages"
    Write-Output ""
    Write-Output "   Subcommands:"
    Write-Output "     clean       delete generated files"
    Write-Output "     compile     compile Java/Kotlin source files"
    Write-Output "     decompile   decompile generated code with CFR"
    Write-Output "     doc         generate HTML documentation"
    Write-Output "     help        print this help message"
    Write-Output "     lint        analyze kotlin source files with Detekt"
    Write-Output "     run         execute main class ""$MAIN_CLASS"""
}

function Clean
{
    Delete-Directory -DirPath $TARGET_DIR
}

function Delete-Directory
{
    param (
        [string] $DirPath
    )
    if (Test-Path -PathType Container -Path $DirPath) {
        Write-Debug "[System.IO.Directory]::Delete('$DirPath', $true)"
        Write-Verbose "Delete directory ""$($DirPath.Replace($ROOT_DIR + $SEP, ''))"""
        try {
            #[System.IO.Directory]::Delete($DirPath, $true)
            Remove-Item -Path $DirPath -Force -Recurse
        } catch {
            Write-Error "Failed to delete directory ""$($DirPath.Replace($ROOT_DIR + $SEP, ''))"""
            $EXITCODE = 1
            return
        }
    }
}

function Lint
{
    $DETEKT_OPTS = @()
    if ($DEBUG) { $DETEKT_OPTS += '--debug' }

    Write-Debug "$DETEKT_CMD $DETEKT_OPTS ""SOURCE_KOTLIN_DIR"""
    Write-Warning "Analyze Kotlin source files with Detekt"
    &"$DETEKT_CMD" $DETEKT_OPTS "$SOURCE_KOTLIN_DIR"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to analyze Kotlin source files with Detekt"
        $EXITCODE = 1
        return
    }
}

function Compile
{
    if (! (Test-Path -PathType Container -Path $CLASSES_DIR)) {
        $_ = New-Item -ItemType Directory -Path $CLASSES_DIR
    }
    $TIMESTAMP_FILE = Join-Path -Path $TARGET_DIR -ChildPath '.latest-build'
    if (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$SOURCE_JAVA_DIR" -Pattern '*.java') {
        Compile-Java
    }
    if (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$SOURCE_KOTLIN_DIR" -Pattern '*.kt') {
        if ($TARGET -eq 'jvm') { Compile-JVM }
        else { Compile-Native }
    }
    $_ = New-Item -ItemType File -Path $TIMESTAMP_FILE -Force
}

function Test-Action-Required
{
    param (
        [string]$FilePath,
        [string]$DirPath,
        [string]$Pattern
    )
    $REQUIRED = $false
    if (Test-Path -PathType Container -Path $DirPath) {
        $DIR_LAST_TIME = (Get-ChildItem -Path $DirPath -Include $Pattern -Recurse | Sort LastWriteTime | Select -Last 1).LastWriteTime
        if (Test-Path -PathType Leaf -Path $FilePath) {
            $FILE_LAST_TIME = (Get-Item $FilePath).LastWriteTime
            $REQUIRED = $FILE_LAST_TIME -lt $DIR_LAST_TIME
        } else {
            $REQUIRED = $DIR_LAST_TIME -ne $null
        }
    }
    Write-Debug "REQUIRED=$REQUIRED ($Pattern)"
    return $REQUIRED
}

function Compile-Java
{
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR

    $OPTS_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'javac_opts.txt'
    [System.IO.File]::WriteAllLines($OPTS_FILE, "-classpath ""$($CPATH.Replace('\', '\\'))"" -d ""$($CLASSES_DIR.Replace('\', '\\'))""")

    $SOURCE_FILES = (Get-ChildItem -Path $SOURCE_JAVA_DIR -Include "*.java" -Recurse).FullName
    $N = $SOURCE_FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Java source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Java source file"
    } else { $N_FILES = "$N Java source files"
    }
    $SOURCES_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'javac_sources.txt'
    [System.IO.File]::WriteAllLines($SOURCES_FILE, $SOURCE_FILES)

    Write-Debug """$JAVAC_CMD"" ""@$OPTS_FILE"" ""@$SOURCES_FILE"""
    Write-Verbose "Compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR + $SEP, ''))"""
    &"$JAVAC_CMD" "@$OPTS_FILE" "@$SOURCES_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR +$SEP, ''))"""
        $EXITCODE = 1
        return
    }
}

function Compile-JVM
{
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR

    $OPTS_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'kotlinc_opts.txt'
    [System.IO.File]::WriteAllLines($OPTS_FILE, "-classpath ""$($CPATH.Replace('\', '\\'))"" -d ""$($CLASSES_DIR.Replace('\', '\\'))""")

    $SOURCE_FILES = (Get-ChildItem -Path $SOURCE_KOTLIN_DIR -Include "*.kt" -Recurse).FullName
    $N = $SOURCE_FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Kotlin source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Kotlin source file"
    } else { $N_FILES = "$N Kotlin source files"
    }
    $SOURCES_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'kotlinc_sources.txt'
    [System.IO.File]::WriteAllLines($SOURCES_FILE, $SOURCE_FILES)

    Write-Debug """$KOTLINC_CMD"" ""@$OPTS_FILE"" ""@$SOURCES_FILE"""
    Write-Verbose "Compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR + $SEP, ''))"""
    &"$KOTLINC_CMD" "@$OPTS_FILE" "@$SOURCES_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR +$SEP, ''))"""
        $EXITCODE = 1
        return
    }
}

function Compile-Native
{
    $NATIVE_OPTS = @('-language-version', $LANGUAGE_VERSION, '-o', $EXE_FILE, '-e', $PKG_NAME + '.main')

    $OPTS_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'kotlinc-native_opts.txt'
    [System.IO.File]::WriteAllLines($OPTS_FILE, $NATIVE_OPTS)

    $SOURCE_FILES = (Get-ChildItem -Path $SOURCE_KOTLIN_DIR -Include "*.kt" -Recurse).FullName
    $N = $SOURCE_FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Kotlin source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Kotlin source file"
    } else { $N_FILES = "$N Kotlin source files"
    }
    $SOURCES_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'kotlinc-native_sources.txt'
    [System.IO.File]::WriteAllLines($SOURCES_FILE, $SOURCE_FILES)

    Write-Debug """$KOTLINC_NATIVE_CMD"" ""@$OPTS_FILE"" ""@$SOURCES_FILE"""
    Write-Verbose "Compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR + $SEP, ''))"""
    &"$KOTLINC_NATIVE_CMD" "@$OPTS_FILE" "@$SOURCES_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR +$SEP, ''))"""
        $EXITCODE = 1
        return
    }
}
<#
function Build-Classpath
{
    $CPATH = $null

    $REPO_DIR = [IO.Path]::Combine($Env:USERPROFILE, '.m2', 'repository')
    if (! (Test-Path -PathType Container -PATH $REPO_DIR)) {
        Write-Error "Maven local repository not found"
        set $EXITCODE = 1
        return $CPATH
    }
    ## https://mvnrepository.com/artifact/org.scala-lang/scala-library
    $JAR_FILE = (Get-ChildItem -Path ($REPO_DIR + $SEP + 'org' + $SEP + 'scala-lang') -Include 'scala-library-2.13.*.jar' -Recurse)
    if ($JAR_FILE.Count -gt 0) { $CPATH = $CPATH + $($JAR_FILE | Select-Object -Last 1).FullName + $PATH_SEP }

    return $CPATH 
}
#>
function Decompile
{
}

function Doc
{
    if (! (Test-Path -PathType Container -Path $TARGET_DOCS_DIR)) {
        $_ = New-Item -ItemType Directory -Path $TARGET_DOCS_DIR
    }
    $TIMESTAMP_FILE = Join-Path -Path $TARGET_DOCS_DIR -ChildPath '.latest-build'
    if (! (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$CLASSES_DIR" '*.tasty')) { return }

    $SOURCES_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'scaladoc_sources.txt'
    if (Test-Path -Path $SOURCES_FILE) { Remove-Item $SOURCES_FILE }

    $FILES = (Get-ChildItem -Path $CLASSES_DIR -Include "*.tasty" -Recurse).FullName
    Write-Output > $SOURCES_FILE

    $OPTS_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'scaladoc_opts.txt'
    Write-Output "-d ""$($TARGET_DOCS_DIR.Replace($SEP, $SEP + $SEP))"" -project ""$PROJECT_NAME"" -project-version ""$PROJECT_VERSION""" > $OPTS_FILE
    Write-Debug "$SCALADOC_CMD @$OPTS_FILE @$SOURCES_FILE"
    Write-Verbose "Generate HTML documentation into directory ""$($TARGET_DOCS_DIR.Replace($ROOT_DIR, ''))"""

    &"$SCALADOC_CMD"  "@$SOURCES_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to generate HTML documentation into directory ""$($TARGET_DOCS_DIR.Replace($ROOT_DIR, ''))"""
        Cleanup 1
    }
    Write-Debug "HTML documentation saved into directory ""$TARGET_DOCS_DIR"""
    Write-Verbose "HTML documentation saved into directory ""$($TARGET_DOCS_DIR.Replace($ROOT_DIR, ''))"""

    $_ = New-Item -ItemType File -Path $TIMESTAMP_FILE -Force
}

function Run
{
    if ($TARGET -eq 'jvm') { Run-JVM } else { Run-Native }

}

function Run-JVM
{
    $MAIN_CLASS_FILE = Join-Path -Path $CLASSES_DIR -ChildPath $($MAIN_CLASS.Replace('.', $SEP) + '.class')
    if (! (Test-Path -PathType Leaf -Path $MAIN_CLASS_FILE)) {
        Write-Error "Kotlin main class ""$MAIN_CLASS"" not found ($MAIN_CLASS_FILE)"
        Cleanup 1
    }
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR
    $KOTLIN_OPTS = @('-classpath', """$CPATH""")
    $KOTLIN_OPTS_DEBUG = @('-classpath', """$($CPATH.Replace($Env:USERPROFILE,'%USERPROFILE%'))""")

    Write-Debug """$KOTLIN_CMD"" $KOTLIN_OPTS_DEBUG $MAIN_CLASS $MAIN_ARGS"
    Write-Verbose "Execute Kotlin main class ""$MAIN_CLASS"""
    &"$KOTLIN_CMD" $KOTLIN_OPTS $MAIN_CLASS $MAIN_ARGS
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to execute Kotlin main class ""$MAIN_CLASS"""
        Cleanup 1
    }
    if ($TASTY) {
        Write-Output "call :run_tasty"
        #[[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    }
}

function Run-Native
{
    if (! (Test-Path -PathType Leaf -Path $EXE_FILE)) {
        Write-Error "Kotlin executable not found (""$($EXE_FILE.Replace($ROOT_DIR, ''))"")"
        $EXITCODE = 1
        return
    }
    Write-Debug """$EXE_FILE"""
    Write-Verbose "Execute Kotlin native application ""$($EXE_FILE.Replace($ROOT_DIR, ''))"""
    &"$EXE_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to execute Kotlin native application ""$($EXE_FILE.Replace($ROOT_DIR, ''))"""
        $EXITCODE = 1
        return
    }
}

function Compile-Test
{
    Write-Warning "Subcommand 'Compile-Test' is not yet implemented"
}

function Test
{
    Write-Warning "Subcommand 'Test' is not yet implemented"
}

function Cleanup
{
    param (
        [int] $ExitCode
    )
    Write-Debug "ExitCode=$ExitCode"
    exit $ExitCode
}

#########################################################################
## Entry-point

Main
