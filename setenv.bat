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

set _BAZEL_PATH=
set _CFR_PATH=
set _GRADLE_PATH=
set _JAVA_PATH=
set _KOTLIN_PATH=
set _KOTLIN_NATIVE_PATH=
set _DETEKT_PATH=
set _KTLINT_PATH=
set _MAVEN_PATH=
set _GIT_PATH=

call :bazel
if not %_EXITCODE%==0 goto end

call :cfr
if not %_EXITCODE%==0 goto end

call :gradle
if not %_EXITCODE%==0 goto end

call :javac
if not %_EXITCODE%==0 goto end

call :kotlinc-jvm
if not %_EXITCODE%==0 goto end

call :kotlinc-native
if not %_EXITCODE%==0 goto end

call :detekt
if not %_EXITCODE%==0 goto end

call :ktlint
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
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
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
    set /a __N+=1
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%%_UNDERSCORE%
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

@rem output parameter(s): _BAZEL_PATH
:bazel
set _BAZEL_PATH=

set __BAZEL_HOME=
set __BAZEL_CMD=
for /f %%f in ('where bazel.exe 2^>NUL') do set "__BAZEL_CMD=%%f"
if defined __BAZEL_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Bazel executable found in PATH 1>&2
    for /f "delims=" %%i in ("%__BAZEL_CMD%") do set "__BAZEL_HOME=%%~dpi"
    @rem keep _BAZEL_PATH undefined since executable already in path
    goto :eof
) else if defined BAZEL_HOME (
    set "__BAZEL_HOME=%BAZEL_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BAZEL_HOME 1>&2
) else (
    set "__PATH=%ProgramFiles%"
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "__BAZEL_HOME=!__PATH!\%%f"
    if not defined __BAZEL_HOME (
        set __PATH=C:\opt
        for /f %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "__BAZEL_HOME=!__PATH!\%%f"
    )
)
if not exist "%__BAZEL_HOME%\bazel.exe" (
    echo %_ERROR_LABEL% Bazel executable not found ^("%__BAZEL_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BAZEL_PATH=;%__BAZEL_HOME%"
goto :eof

@rem http://www.benf.org/other/cfr/
:cfr
where /q cfr.bat
if %ERRORLEVEL%==0 goto :eof

if defined CFR_HOME (
    set "_CFR_HOME=%CFR_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable CFR_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\cfr*" 2^>NUL') do set "_CFR_HOME=!_PATH!\%%f"
    if defined _CFR_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default cfr installation directory !_CFR_HOME! 1>&2
    )
)
if not exist "%_CFR_HOME%\bin\cfr.bat" (
    echo %_ERROR_LABEL% cfr executable not found ^(%_CFR_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CFR_PATH=;%_CFR_HOME%\bin"
goto :eof

@rem output parameter(s): _GRADLE_HOME, _GRADLE_PATH
:gradle
set _GRADLE_HOME=
set _GRADLE_PATH=

set __GRADLE_CMD=
for /f %%f in ('where gradle.bat 2^>NUL') do set "__GRADLE_CMD=%%f"
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
    echo %_ERROR_LABEL% Executable gradle.bat not found ^(%_GRADLE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GRADLE_PATH=;%_GRADLE_HOME%\bin"
goto :eof

@rem output parameter(s): _JAVA_HOME, _JAVA_PATH
:javac
set _JAVA_HOME=
set _JAVA_PATH=

set __JAVAC_CMD=
for /f %%f in ('where javac.exe 2^>NUL') do set "__JAVAC_CMD=%%f"
if defined __JAVAC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of javac executable found in PATH 1>&2
    for %%i in ("%__JAVAC_CMD%") do set "__JAVA_BIN_DIR=%%~dpi"
    for %%f in ("!__JAVA_BIN_DIR!\.") do set "_JAVA_HOME=%%~dpf"
    @rem keep _JAVA_PATH undefined since executable already in path
    goto :eof
) else if defined JAVA_HOME (
    set "_JAVA_HOME=%JAVA_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JAVA_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\jdk-1.8*" 2^>NUL') do set "_JAVA_HOME=!__PATH!\%%f"
    if not defined _JAVA_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jdk-1.8*" 2^>NUL') do set "_JAVA_HOME=!__PATH!\%%f"
    )
)
if not exist "%_JAVA_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% Executable javac.exe not found ^(%_JAVA_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem Here we use trailing separator because it will be prepended to PATH
set "_JAVA_PATH=%_JAVA_HOME%\bin;"
goto :eof

@rem output parameter(s): _KOTLIN_HOME, _KOTLIN_PATH
:kotlinc-jvm
set _KOTLIN_HOME=
set _KOTLIN_PATH=

set __KOTLINC_CMD=
for /f %%f in ('where kotlinc.bat 2^>NUL') do set "__KOTLINC_CMD=%%f"
@rem We need to differentiate kotlinc-jvm from kotlinc-native
if defined __KOTLINC_CMD (
    for /f "tokens=1,2,*" %%i in ('%__KOTLINC_CMD% -version 2^>^&1') do (
        if not "%%j"=="kotlinc-jvm" set __KOTLINC_CMD=
    )
)
if defined __KOTLINC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Kotlin executable found in PATH 1>&2
    @rem keep _KOTLIN_PATH undefined since executable already in path
    goto :eof
) else if defined KOTLIN_HOME (
    set "_KOTLIN_HOME=%KOTLIN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KOTLIN_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\kotlinc*" 2^>NUL') do set "_KOTLIN_HOME=!__PATH!\%%f"
    if not defined _KOTLIN_HOME (
        set "__PATH=%ProgramFiles%"
        for /f %%f in ('dir /ad /b "!__PATH!\kotlinc*" 2^>NUL') do set "_KOTLIN_HOME=!__PATH!\%%f"
    )
)
if not exist "%_KOTLIN_HOME%\bin\kotlinc.bat" (
    echo kotlinc not found in Kotlin installation directory ^(%_KOTLIN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_KOTLIN_PATH=;%_KOTLIN_HOME%\bin"
goto :eof

@rem output parameter(s): _KOTLIN_NATIVE_HOME, _KOTLIN_NATIVE_PATH
:kotlinc-native
set _KOTLIN_NATIVE_HOME=
set _KOTLIN_NATIVE_PATH=

set __KOTLINC_NATIVE_CMD=
for /f %%f in ('where kotlinc-native.bat 2^>NUL') do set "__KOTLINC_NATIVE_CMD=%%f"
if defined __KOTLINC_NATIVE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Kotlin executable found in PATH 1>&2
    @rem keep _KOTLIN_NATIVE_PATH undefined since executable already in path
    goto :eof
) else if defined KOTLIN_NATIVE_HOME (
    set "_KOTLIN_NATIVE_HOME=%KOTLIN_NATIVE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KOTLIN_NATIVE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\kotlin-native*" 2^>NUL') do set "_KOTLIN_NATIVE_HOME=!__PATH!\%%f"
    if not defined _KOTLIN_HOME (
        set "__PATH=%ProgramFiles%"
        for /f %%f in ('dir /ad /b "!__PATH!\kotlin-native*" 2^>NUL') do set "_KOTLIN_NATIVE_HOME=!__PATH!\%%f"
    )
)
if not exist "%_KOTLIN_NATIVE_HOME%\bin\kotlinc-native.bat" (
    echo kotlinc-native not found in Kotlin/Native installation directory ^(%_KOTLIN_NATIVE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_KOTLIN_NATIVE_PATH=;%_KOTLIN_NATIVE_HOME%\bin"
goto :eof

@rem output parameter(s): _DETEKT_HOME, _DETEKT_PATH
:detekt
set _DETEKT_HOME=
set _DETEKT_PATH=

set __DETEKT_CMD=
for /f %%f in ('where detekt-cli.bat 2^>NUL') do set "__DETEKT_CMD=%%f"
if defined __DETEKT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Detekt executable found in PATH 1>&2
    for %%i in ("%__JAVAC_CMD%") do set "__JAVA_BIN_DIR=%%~dpi"
    for %%f in ("!__JAVA_BIN_DIR!\.") do set "_JAVA_HOME=%%~dpf"
    @rem keep _DETEKT_PATH undefined since executable already in path
    goto :eof
) else if defined DETEKT_HOME (
    set "_DETEKT_HOME=%DETEKT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable DETEKT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\detekt-cli\" ( set _DETEKT_HOME=!__PATH!\detekt-cli
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\detekt-cli*" 2^>NUL') do set "_DETEKT_HOME=!__PATH!\%%f"
        if not defined _DETEKT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\detekt-cli*" 2^>NUL') do set "_DETEKT_HOME=!__PATH!\%%f"
        )
    )
)
set "_DETEKT_PATH=;%_DETEKT_HOME%\bin"
goto :eof

@rem output parameter(s): _KTLINT_HOME, _KTLINT_PATH
:ktlint
set _KTLINT_PATH=

set __KTLINT_CMD=
for /f %%f in ('where ktlint.bat 2^>NUL') do set "__KTLINT_CMD=%%f"
if defined __KTLINT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of KtLint executable found in PATH 1>&2
    @rem keep _KTLINT_PATH undefined since executable already in path
    goto :eof
) else if defined KTLINT_HOME (
    set "_KTLINT_HOME=%KTLINT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KTLINT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\ktlint\" ( set _KTLINT_HOME=!__PATH!\ktlint
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\ktlint*" 2^>NUL') do set "_KTLINT_HOME=!__PATH!\%%f"
        if not defined _KTLINT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\ktlint*" 2^>NUL') do set "_KTLINT_HOME=!__PATH!\%%f"
        )
    )
)
set "_KTLINT_PATH=;%_KTLINT_HOME%"
goto :eof

:maven
set _MAVEN_PATH=

set __MAVEN_HOME=
set __MVN_CMD=
for /f %%f in ('where /q mvn.cmd 2^>NUL') do set "__MVN_CMD=%%f"
if defined __MVN_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Maven executable found in PATH 1>&2
    @rem keep _MAVEN_PATH undefined since executable already in path
    goto :eof
) else if defined MAVEN_HOME (
    set "__MAVEN_HOME=%MAVEN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAVEN_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\apache-maven-*" 2^>NUL') do set "__MAVEN_HOME=!_PATH!\%%f"
    if defined __MAVEN_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Maven installation directory "!__MAVEN_HOME!"
    )
)
if not exist "%__MAVEN_HOME%\bin\mvn.cmd" (
    echo %_ERROR_LABEL% Maven executable not found ^(%__MAVEN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAVEN_PATH=;%__MAVEN_HOME%\bin"
goto :eof

@rem output parameter(s): _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set _GIT_HOME=!__PATH!\Git
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
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

:print_env
set __VERBOSE=%1
set "__VERSIONS_LINE1=  "
set "__VERSIONS_LINE2=  "
set "__VERSIONS_LINE3=  "
set __WHERE_ARGS=
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
where /q java.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('java.exe -version 2^<^&1 ^| findstr version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% java %%~k,"
    set __WHERE_ARGS=%__WHERE_ARGS% java.exe
)
where /q detekt-cli.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('detekt-cli.bat --version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% detekt-cli %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% detekt-cli.bat
)
where /q kotlinc.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('kotlinc.bat -version 2^>^&1 ^| findstr kotlinc') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% kotlinc %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% kotlinc.bat
)
where /q kotlinc-native.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('kotlinc-native.bat -version 2^>^&1 ^| findstr kotlinc-native') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% kotlinc-native %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% kotlinc-native.bat
)
where /q ktlint.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('ktlint.bat --version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% ktlint %%~i"
    set __WHERE_ARGS=%__WHERE_ARGS% ktlint.bat
)
where /q cfr.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('cfr.bat 2^>^&1 ^| findstr /b CFR') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% cfr %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% cfr.bat
)
where /q mvn.cmd
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('mvn.cmd -version ^| findstr Apache') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% mvn %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% mvn.cmd
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
	if defined KOTLINE_HOME echo    KOTLIN_HOME="%KOTLIN_HOME%" 1>&2
	if defined KOTLINE_NATIVE_HOME echo    KOTLIN_NATIVE_HOME="%KOTLIN_HOME%" 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if not defined GRADLE_HOME set "GRADLE_HOME=%_GRADLE_HOME%"
    if not defined JAVA_HOME set "JAVA_HOME=%_JAVA_HOME%"
    if not defined KOTLIN_HOME set "KOTLIN_HOME=%_KOTLIN_HOME%"
    if not defined KOTLIN_NATIVE_HOME set "KOTLIN_NATIVE_HOME=%_KOTLIN_NATIVE_HOME%"
    set "PATH=%_JAVA_PATH%%PATH%%_BAZEL_PATH%%_CFR_PATH%%_GRADLE_PATH%%_KOTLIN_PATH%%_KOTLIN_NATIVE_PATH%%_DETEKT_PATH%%_KTLINT_PATH%%_MAVEN_PATH%%_GIT_PATH%;%~dp0bin"
    call :print_env %_VERBOSE%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
