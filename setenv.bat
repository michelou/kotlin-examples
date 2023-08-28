@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)

set _ANT_PATH=
set _BAZEL_PATH=
set _GRADLE_PATH=
set _MAKE_PATH=
set _MAVEN_PATH=
set _GIT_PATH=

call :ant
if not %_EXITCODE%==0 goto end

call :bazel
if not %_EXITCODE%==0 goto end

call :cfr
if not %_EXITCODE%==0 goto end

call :gradle
if not %_EXITCODE%==0 goto end

call :java11
if not %_EXITCODE%==0 goto end

call :kotlin_jvm
if not %_EXITCODE%==0 goto end

call :kotlin_native
if not %_EXITCODE%==0 goto end

call :dokka
if not %_EXITCODE%==0 (
    echo %_WARNING_LABEL% Dokka CLI library not available 1>&2
    set _EXITCODE=0
    @rem goto end
)
call :detekt
if not %_EXITCODE%==0 goto end

call :ktlint
if not %_EXITCODE%==0 goto end

call :make
if not %_EXITCODE%==0 goto end

call :maven
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m
goto :eof

@rem input parameter: %*
:args
set _BASH=0
set _HELP=0
set _VERBOSE=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-bash" ( set _BASH=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto args_loop
:args_done
call :drive_name "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _BASH=%_BASH% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% 1&2
    echo %_DEBUG_LABEL% Variables  : _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter: %1: path to be substituted
@rem output parameter: _DRIVE_NAME (2 characters: letter + ':')
:drive_name
set "__GIVEN_PATH=%~1"

@rem https://serverfault.com/questions/62578/how-to-get-a-list-of-drive-letters-on-a-system-through-a-windows-shell-bat-cmd
set __DRIVE_NAMES=F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:
for /f %%i in ('wmic logicaldisk get deviceid ^| findstr :') do (
    set "__DRIVE_NAMES=!__DRIVE_NAMES:%%i=!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(WMIC^) 1>&2
if not defined __DRIVE_NAMES (
    echo %_ERROR_LABEL% No more free drive name 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst') do (
    set "__SUBST_DRIVE=%%f"
    set "__SUBST_DRIVE=!__SUBST_DRIVE:~0,2!"
    set "__SUBST_PATH=%%h"
    if "!__SUBST_DRiVE!"=="!__GIVEN_PATH:~0,2!" (
        set _DRIVE_NAME=!__SUBST_DRIVE:~0,2!
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    ) else if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set "_DRIVE_NAME=!__SUBST_DRIVE!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    )
)
for /f "tokens=1,2,*" %%i in ('subst') do (
    set __USED=%%i
    call :drive_names "!__USED:~0,2!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(SUBST^) 1>&2

set "_DRIVE_NAME=!__DRIVE_NAMES:~0,2!"
if /i "%_DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%_DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign drive %_DRIVE_NAME% to path "%__GIVEN_PATH%" 1>&2
)
subst "%_DRIVE_NAME%" "%__GIVEN_PATH%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to assign drive %_DRIVE_NAME% to path "%__GIVEN_PATH%" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=Used drive name
@rem output parameter: __DRIVE_NAMES
:drive_names
set "__USED_NAME=%~1"
set "__DRIVE_NAMES=!__DRIVE_NAMES:%__USED_NAME%=!"
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%      display commands executed by this script
echo     %__BEG_O%-verbose%__END%    display environment settings
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
goto :eof

@rem output parameters: _ANT_HOME, _ANT_PATH
:ant
set _ANT_HOME=
set _ANT_PATH=

set __ANT_CMD=
for /f %%f in ('where ant.bat 2^>NUL') do set "__ANT_CMD=%%f"
if defined __ANT_CMD (
    for %%i in ("%__ANT_CMD%") do set "__ANT_BIN_DIR=%%~dpi"
    for %%f in ("!__ANT_BIN_DIR!\.") do set "_ANT_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Ant executable found in PATH 1>&2
    @rem keep _ANT_PATH undefined since executable already in path
    goto :eof
) else if defined ANT_HOME (
    set "_ANT_HOME=%ANT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable ANT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\apache-ant\" ( set "_ANT_HOME=!__PATH!\apache-ant"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set "_ANT_HOME=!__PATH!\%%f"
        if not defined _ANT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set "_ANT_HOME=!__PATH!\%%f"
        )
    )
    if defined _ANT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Ant installation directory !_ANT_HOME! 1>&2
    )
)
if not exist "%_ANT_HOME%\bin\ant.cmd" (
    echo %_ERROR_LABEL% Ant executable not found ^("%_ANT_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_ANT_PATH=;%_ANT_HOME%\bin"
goto :eof

@rem output parameters: _BAZEL_HOME, _BAZEL_PATH
:bazel
set _BAZEL_HOME=
set _BAZEL_PATH=

set __BAZEL_CMD=
for /f "delims=" %%f in ('where bazel.exe 2^>NUL') do set "__BAZEL_CMD=%%f"
if defined __BAZEL_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Bazel executable found in PATH 1>&2
    for /f "delims=" %%i in ("%__BAZEL_CMD%") do set "_BAZEL_HOME=%%~dpi"
    @rem keep _BAZEL_PATH undefined since executable already in path
    goto :eof
) else if defined BAZEL_HOME (
    set "_BAZEL_HOME=%BAZEL_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BAZEL_HOME 1>&2
) else (
    set "__PATH=%ProgramFiles%"
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "_BAZEL_HOME=!__PATH!\%%f"
    if not defined _BAZEL_HOME (
        set __PATH=C:\opt
        for /f %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "_BAZEL_HOME=!__PATH!\%%f"
    )
)
if not exist "%_BAZEL_HOME%\bazel.exe" (
    echo %_ERROR_LABEL% Bazel executable not found ^("%_BAZEL_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BAZEL_PATH=;%_BAZEL_HOME%"
goto :eof

@rem output parameter: _CFR_HOME
@rem http://www.benf.org/other/cfr/
:cfr
set _CFR_HOME=

set __CFR_CMD=
for /f "delims=" %%f in ('where cfr.bat 2^>NUL') do set "__CFR_CMD=%%f"
if defined __CFR_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of cfr executable found in PATH 1>&2
    for %%i in ("%__CFR_CMD%") do set "__CFR_BIN_DIR=%%~dpi"
    for %%f in ("!__CFR_BIN_DIR!\.") do set "_CFR_HOME=%%~dpf"
    goto :eof
) else if defined CFR_HOME (
    set "_CFR_HOME=%CFR_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable CFR_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\cfr*" 2^>NUL') do set "_CFR_HOME=!_PATH!\%%f"
    if defined _CFR_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default cfr installation directory "!_CFR_HOME!" 1>&2
    )
)
if not exist "%_CFR_HOME%\bin\cfr.bat" (
    echo %_ERROR_LABEL% cfr executable not found ^("%_CFR_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _GRADLE_HOME, _GRADLE_PATH
:gradle
set _GRADLE_HOME=
set _GRADLE_PATH=

set __GRADLE_CMD=
for /f "delims=" %%f in ('where gradle.bat 2^>NUL') do set "__GRADLE_CMD=%%f"
if defined __GRADLE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Gradle executable found in PATH 1>&2
    for %%i in ("%__GRADLE_CMD%") do set "__GRADLE_BIN_DIR=%%~dpi"
    for %%f in ("!__GRADLE_BIN_DIR!\.") do set "_GRADLE_HOME=%%~dpf"
    @rem keep _GRADLE_PATH undefined since executable already in path
    goto :eof
) else if defined GRADLE_HOME (
    set "_GRADLE_HOME=%GRADLE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GRADLE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\gradle*" 2^>NUL') do set "_GRADLE_HOME=!__PATH!\%%f"
    if not defined _GRADLE_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\gradle*" 2^>NUL') do set "_GRADLE_HOME=!__PATH!\%%f"
    )
)
if not exist "%_GRADLE_HOME%\bin\gradle.bat" (
    echo %_ERROR_LABEL% Executable gradle.bat not found ^("%_GRADLE_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GRADLE_PATH=;%_GRADLE_HOME%\bin"
goto :eof

@rem output parameter: _JAVA_HOME
:java11
set _JAVA_HOME=

set __JAVA_DISTRO=temurin
set __JAVAC_CMD=
for /f "delims=" %%f in ('where javac.exe 2^>NUL') do set "__JAVAC_CMD=%%f"
@rem ignore command if Java version is not 11
if defined __JAVAC_CMD (
    for /f "tokens=1,*" %%i in ('"%__JAVAC_CMD%" -version') do (
        set __JAVAC_VERSION=%%j
        if "!__JAVAC_VERSION:11.=!"=="!__JAVAC_VERSION!" (
            echo %_WARNING_LABEL% Expected: Java 11 executable, found: !__JAVAC_VERSION! 1>&2
            set __JAVAC_CMD=
        )
    )
)
if defined __JAVAC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of javac executable found in PATH 1>&2
    for %%i in ("%__JAVAC_CMD%") do set "__JAVA_BIN_DIR=%%~dpi"
    for %%f in ("!__JAVA_BIN_DIR!\.") do set "_JAVA_HOME=%%~dpf"
    goto :eof
) else if defined JAVA_HOME (
    set "_JAVA_HOME=%JAVA_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JAVA_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\jdk-%__JAVA_DISTRO%-11*" 2^>NUL') do set "_JAVA_HOME=!__PATH!\%%f"
    if not defined _JAVA_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jdk-%__JAVA_DISTRO%-11*" 2^>NUL') do set "_JAVA_HOME=!__PATH!\%%f"
    )
)
if not exist "%_JAVA_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% Executable javac.exe not found ^(%_JAVA_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _KOTLIN_HOME
:kotlin_jvm
set _KOTLIN_HOME=

set __KOTLINC_CMD=
for /f "delims=" %%f in ('where kotlinc.bat 2^>NUL') do set "__KOTLINC_CMD=%%f"
@rem We need to differentiate kotlinc-jvm from kotlinc-native
if defined __KOTLINC_CMD (
    for /f "tokens=1,2,*" %%i in ('%__KOTLINC_CMD% -version 2^>^&1') do (
        if not "%%j"=="kotlinc-jvm" set __KOTLINC_CMD=
    )
)
if defined __KOTLINC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Kotlin executable found in PATH 1>&2
    for %%i in ("%__KOTLINC_CMD%") do set "__KOTLINC_BIN_DIR=%%~dpi"
    for %%f in ("!__KOTLINC_BIN_DIR!\.") do set "_KOTLIN_HOME=%%~dpf"
    goto :eof
) else if defined KOTLIN_HOME (
    set "_KOTLIN_HOME=%KOTLIN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KOTLIN_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\kotlinc*" 2^>NUL') do set "_KOTLIN_HOME=!__PATH!\%%f"
    if not defined _KOTLIN_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\kotlinc*" 2^>NUL') do set "_KOTLIN_HOME=!__PATH!\%%f"
    )
)
if not exist "%_KOTLIN_HOME%\bin\kotlinc.bat" (
    echo %_ERROR_LABEL% kotlinc not found in Kotlin installation directory ^(%_KOTLIN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _KOTLIN_NATIVE_HOME
:kotlin_native
set _KOTLIN_NATIVE_HOME=

set __KOTLINC_NATIVE_CMD=
for /f "delims=" %%f in ('where kotlinc-native.bat 2^>NUL') do set "__KOTLINC_NATIVE_CMD=%%f"
if defined __KOTLINC_NATIVE_CMD (
    for %%i in ("%__KOTLINC_NATIVE_CMD%") do set "__KOTLINC_NATIVE_BIN_DIR=%%~dpi"
    for %%f in ("!__KOTLINC_NATIVE_BIN_DIR!\.") do set "_KOTLIN_NATIVE_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Kotlin executable found in PATH 1>&2
    goto :eof
) else if defined KOTLIN_NATIVE_HOME (
    set "_KOTLIN_NATIVE_HOME=%KOTLIN_NATIVE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KOTLIN_NATIVE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\kotlin-native*" 2^>NUL') do set "_KOTLIN_NATIVE_HOME=!__PATH!\%%f"
    if not defined _KOTLIN_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\kotlin-native*" 2^>NUL') do set "_KOTLIN_NATIVE_HOME=!__PATH!\%%f"
    )
)
if not exist "%_KOTLIN_NATIVE_HOME%\bin\kotlinc-native.bat" (
    echo %_ERROR_LABEL% kotlinc-native not found in Kotlin/Native installation directory ^(%_KOTLIN_NATIVE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _DOKKA_CLI_JAR
:dokka
set _DOKKA_CLI_JAR=
@rem https://repo1.maven.org/maven2/org/jetbrains/dokka/dokka-cli/1.7.20/dokka-cli-1.7.20.jar
set "__DOKKA_CLI_DIR=%USERPROFILE%\.m2\repository\org\jetbrains\dokka\dokka-cli"
for /f "delims=" %%f in ('dir /a-d /b /s "%__DOKKA_CLI_DIR%\*.jar" 2^>NUL') do (
     set "_DOKKA_CLI_JAR=%%f"
)
if not defined _DOKKA_CLI_JAR (
    @rem echo %_ERROR_LABEL% Dokka CLI library not found in Dokka installation directory ^(%__DOKKA_CLI_DIR%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _DETEKT_HOME
:detekt
set _DETEKT_HOME=

set __DETEKT_CMD=
for /f "delims=" %%f in ('where detekt-cli.bat 2^>NUL') do set "__DETEKT_CMD=%%f"
if defined __DETEKT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Detekt executable found in PATH 1>&2
    for %%i in ("%__DETEKT_CMD%") do set "__DETEKT_BIN_DIR=%%~dpi"
    for %%f in ("!__DETEKT_BIN_DIR!\.") do set "_DETEKT_HOME=%%~dpf"
) else if defined DETEKT_HOME (
    set "_DETEKT_HOME=%DETEKT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable DETEKT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\detekt-cli\" ( set "_DETEKT_HOME=!__PATH!\detekt-cli"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\detekt-cli*" 2^>NUL') do set "_DETEKT_HOME=!__PATH!\%%f"
        if not defined _DETEKT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\detekt-cli*" 2^>NUL') do set "_DETEKT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_DETEKT_HOME%\bin\detekt-cli.bat" (
    echo %_ERROR_LABEL% Detekt executable not found ^(%_DETEKT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _KTLINT_HOME
:ktlint
set _KTLINT_HOME=

set __KTLINT_CMD=
for /f "delims=" %%f in ('where ktlint.bat 2^>NUL') do set "__KTLINT_CMD=%%f"
if defined __KTLINT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of KtLint executable found in PATH 1>&2
    for %%i in ("%__KTLINT_CMD%") do set "__KTLINT_BIN_DIR=%%~dpi"
    for %%f in ("!__KTLINT_BIN_DIR!\.") do set "_KTLINT_HOME=%%~dpf"
    goto :eof
) else if defined KTLINT_HOME (
    set "_KTLINT_HOME=%KTLINT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KTLINT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\ktlint\" ( set "_KTLINT_HOME=!__PATH!\ktlint"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\ktlint*" 2^>NUL') do set "_KTLINT_HOME=!__PATH!\%%f"
        if not defined _KTLINT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\ktlint*" 2^>NUL') do set "_KTLINT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_KTLINT_HOME%\bin\ktlint.bat" (
    echo %_ERROR_LABEL% KtLint executable not found ^(%_KTLINT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _MAKE_HOME, _MAKE_PATH
:make
set _MAKE_HOME=
set _MAKE_PATH=

set __MAKE_CMD=
for /f "delims=" %%f in ('where make.exe 2^>NUL') do set "__MAKE_CMD=%%f"
if defined __MAKE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Make executable found in PATH 1>&2
    rem keep _MAKE_PATH undefined since executable already in path
    goto :eof
) else if defined MAKE_HOME (
    set "_MAKE_HOME=%MAKE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAKE_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\make-3*" 2^>NUL') do set "_MAKE_HOME=!_PATH!\%%f"
    if defined _MAKE_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Make installation directory !_MAKE_HOME! 1>&2
    )
)
if not exist "%_MAKE_HOME%\bin\make.exe" (
    echo %_ERROR_LABEL% Make executable not found ^(%_MAKE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAKE_PATH=;%_MAKE_HOME%\bin"
goto :eof

@rem output parameters: _MAVEN_HOME, _MAVEN_PATH
:maven
set _MAVEN_HOME=
set _MAVEN_PATH=

set __MVN_CMD=
for /f "delims=" %%f in ('where /q mvn.cmd 2^>NUL') do set "__MVN_CMD=%%f"
if defined __MVN_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Maven executable found in PATH 1>&2
    @rem keep _MAVEN_PATH undefined since executable already in path
    goto :eof
) else if defined MAVEN_HOME (
    set "_MAVEN_HOME=%MAVEN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAVEN_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\apache-maven-*" 2^>NUL') do set "_MAVEN_HOME=!_PATH!\%%f"
    if defined _MAVEN_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Maven installation directory "!_MAVEN_HOME!"
    )
)
if not exist "%_MAVEN_HOME%\bin\mvn.cmd" (
    echo %_ERROR_LABEL% Maven executable not found ^(%_MAVEN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAVEN_PATH=;%_MAVEN_HOME%\bin"
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f "delims=" %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^(%_GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\mingw64\bin;%_GIT_HOME%\usr\bin"
goto :eof

@rem %JAVA_HOME%\bin\jar xvf c:\opt\dokka-1.4.20\lib\dokka-cli-1.4.20.jar META-INF/dokka/dokka-version.properties
@rem type META-INF\dokka\dokka-version.properties
@rem dokka-version=1.4.20
:print_env
set __VERBOSE=%1
set "__VERSIONS_LINE1=  "
set "__VERSIONS_LINE2=  "
set "__VERSIONS_LINE3=  "
set __WHERE_ARGS=
where /q "%ANT_HOME%\bin:ant.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('"%ANT_HOME%\bin\ant.bat" -version ^| findstr version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% ant %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%ANT_HOME%\bin:ant.bat"
)
where /q bazel.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('bazel.exe --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% bazel %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% bazel.exe
)
where /q gradle.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('gradle.bat -version 2^<^&1 ^| findstr Gradle') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% gradle %%~j,"
    set __WHERE_ARGS=%__WHERE_ARGS% gradle.bat
)
where /q "%JAVA_HOME%\bin:java.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%JAVA_HOME%\bin\java.exe" -version 2^<^&1 ^| findstr version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% java %%~k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%JAVA_HOME%\bin:java.exe"
)
where /q "%DETEKT_HOME%\bin:detekt-cli.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('"%DETEKT_HOME%\bin\detekt-cli.bat" --version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% detekt-cli %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%DETEKT_HOME%\bin:detekt-cli.bat"
)
where /q "%KOTLIN_HOME%\bin:kotlinc.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%KOTLIN_HOME%\bin\kotlinc.bat" -version 2^>^&1 ^| findstr kotlinc') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% kotlinc %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%KOTLIN_HOME%\bin:kotlinc.bat"
)
where /q "%KOTLIN_NATIVE_HOME%\bin:kotlinc-native.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%KOTLIN_NATIVE_HOME%\bin\kotlinc-native.bat" -version 2^>^&1 ^| findstr kotlinc-native') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% kotlinc-native %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%KOTLIN_NATIVE_HOME%\bin:kotlinc-native.bat"
)
where /q "%KTLINT_HOME%:ktlint.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('"%KTLINT_HOME%\ktlint.bat" --version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% ktlint %%~i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%KTLINT_HOME%:ktlint.bat"
)
where /q "%CFR_HOME%\bin:cfr.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%CFR_HOME%\bin\cfr.bat" 2^>^&1 ^| findstr /b CFR') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% cfr %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%CFR_HOME%\bin:cfr.bat"
)
where /q "%MAKE_HOME%\bin:make.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%MAKE_HOME%\bin\make.exe" --version 2^>^&1 ^| findstr Make') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% make %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MAKE_HOME%\bin:make.exe"
)
where /q "%MAVEN_HOME%\bin:mvn.cmd"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%MAVEN_HOME%\bin\mvn.cmd" -version ^| findstr Apache') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% mvn %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MAVEN_HOME%\bin:mvn.cmd"
)
where /q git.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('git.exe --version') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% git %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% git.exe
)
where /q diff.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('diff.exe --version ^| findstr /B diff') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% diff %%l"
    set __WHERE_ARGS=%__WHERE_ARGS% diff.exe
)
echo Tool versions:
echo %__VERSIONS_LINE1%
echo %__VERSIONS_LINE2%
echo %__VERSIONS_LINE3%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% where %__WHERE_ARGS%
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p 1>&2
    echo Environment variables: 1>&2
    if defined ANT_HOME echo    "ANT_HOME=%ANT_HOME%" 1>&2
    if defined CFR_HOME echo    "CFR_HOME=%CFR_HOME%" 1>&2
    if defined DETEKT_HOME echo    "DETEKT_HOME=%DETEKT_HOME%" 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined GRADLE_HOME echo    "GRADLE_HOME=%GRADLE_HOME%" 1>&2
    if defined JAVA_HOME echo    "JAVA_HOME=%JAVA_HOME%" 1>&2
    if defined KOTLIN_HOME echo    "KOTLIN_HOME=%KOTLIN_HOME%" 1>&2
    if defined KOTLIN_NATIVE_HOME echo    "KOTLIN_NATIVE_HOME=%KOTLIN_HOME%" 1>&2
    if defined KTLINT_HOME echo    "KTLINT_HOME=%KTLINT_HOME%" 1>&2
    if defined MAKE_HOME echo    "MAKE_HOME=%MAKE_HOME%" 1>&2
    if defined MAVEN_HOME echo    "MAVEN_HOME=%MAVEN_HOME%" 1>&2
    echo Path associations: 1>&2
    for /f "delims=" %%i in ('subst') do echo    %%i 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if not defined ANT_HOME set "ANT_HOME=%_ANT_HOME%"
    if not defined CFR_HOME set "CFR_HOME=%_CFR_HOME%"
    if not defined DETEKT_HOME set "DETEKT_HOME=%_DETEKT_HOME%"
    if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
    if not defined GRADLE_HOME set "GRADLE_HOME=%_GRADLE_HOME%"
    if not defined JAVA_HOME set "JAVA_HOME=%_JAVA_HOME%"
    if not defined KOTLIN_HOME set "KOTLIN_HOME=%_KOTLIN_HOME%"
    if not defined KOTLIN_NATIVE_HOME set "KOTLIN_NATIVE_HOME=%_KOTLIN_NATIVE_HOME%"
    if not defined KTLINT_HOME set "KTLINT_HOME=%_KTLINT_HOME%"
    if not defined MAKE_HOME set "MAKE_HOME=%_MAKE_HOME%"
    if not defined MAVEN_HOME set "MAVEN_HOME=%_MAVEN_HOME%"
    set "PATH=%PATH%%_ANT_PATH%%_BAZEL_PATH%%_GRADLE_PATH%%_MAKE_PATH%%_MAVEN_PATH%%_GIT_PATH%;%~dp0bin"
    call :print_env %_VERBOSE%
    if not "%CD:~0,2%"=="%_DRIVE_NAME%" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME% 1>&2
        cd /d %_DRIVE_NAME%
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
