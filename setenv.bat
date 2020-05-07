@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
set _GRADLE_PATH=
set _JAVA_PATH=
set _KOTLIN_PATH=
set _KOTLINE_NATIVE_PATH=
set _DETEKT_PATH=
set _KTLINT_PATH=
set _MAVEN_PATH=
set _GIT_PATH=

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

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

rem for %%f in ("%ProgramFiles%") do set _PROGRAM_FILES=%%~sf
goto :eof

rem input parameter: %*
:args
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    rem option
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    rem subcommand
    set /a __N+=1
    if /i "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug      display commands executed by this script
echo     -verbose    display environment settings
echo.
echo   Subcommands:
echo     help        display this help message
goto :eof

rem output parameter(s): _GRADLE_HOME, _GRADLE_PATH
:gradle
set _GRADLE_HOME=
set _GRADLE_PATH=

set __GRADLE_CMD=
for /f %%f in ('where gradle.bat 2^>NUL') do set "__GRADLE_CMD=%%f"
if defined __GRADLE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Gradle executable found in PATH 1>&2
    for %%i in ("%__GRADLE_CMD%") do set __GRADLE_BIN_DIR=%%~dpsi
    for %%f in ("!__GRADLE_BIN_DIR!..") do set _GRADLE_HOME=%%~sf
    rem keep _GRADLE_PATH undefined since executable already in path
    goto :eof
) else if defined GRADLE_HOME (
    set _GRADLE_HOME=%GRADLE_HOME%
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

rem output parameter(s): _JAVA_HOME, _JAVA_PATH
:javac
set _JAVA_HOME=
set _JAVA_PATH=

set __JAVAC_CMD=
for /f %%f in ('where javac.exe 2^>NUL') do set "__JAVAC_CMD=%%f"
if defined __JAVAC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of javac executable found in PATH 1>&2
    for %%i in ("%__JAVAC_CMD%") do set __JAVA_BIN_DIR=%%~dpsi
    for %%f in ("!__JAVA_BIN_DIR!..") do set _JAVA_HOME=%%~sf
    rem keep _JAVA_PATH undefined since executable already in path
    goto :eof
) else if defined JAVA_HOME (
    set _JAVA_HOME=%JAVA_HOME%
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
rem Here we use trailing separator because it will be prepended to PATH
set "_JAVA_PATH=%_JAVA_HOME%\bin;"
goto :eof

rem output parameter(s): _KOTLIN_HOME, _KOTLIN_PATH
:kotlinc-jvm
set _KOTLIN_HOME=
set _KOTLIN_PATH=

set __KOTLINC_CMD=
for /f %%f in ('where kotlinc.bat 2^>NUL') do set "__KOTLINC_CMD=%%f"
rem We need to differentiate kotlinc-jvm from kotlinc-native
if defined __KOTLINC_CMD (
    for /f "tokens=1,2,*" %%i in ('%__KOTLINC_CMD% -version 2^>^&1') do (
        if not "%%j"=="kotlinc-jvm" set __KOTLINC_CMD=
    )
)
if defined __KOTLINC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Kotlin executable found in PATH 1>&2
    rem keep _KOTLIN_PATH undefined since executable already in path
    goto :eof
) else if defined KOTLIN_HOME (
    set "_KOTLIN_HOME=%KOTLIN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KOTLIN_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\kotlinc*" 2^>NUL') do set _KOTLIN_HOME=!__PATH!\%%f
    if not defined _KOTLIN_HOME (
        set __PATH=C:\progra~1
        for /f %%f in ('dir /ad /b "!__PATH!\kotlinc*" 2^>NUL') do set _KOTLIN_HOME=!__PATH!\%%f
    )
    if defined _KOTLIN_HOME (
        rem path name of installation directory may contain spaces
        for /f "delims=" %%f in ("!_KOTLIN_HOME!") do set _KOTLIN_HOME=%%~sf
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Kotlin installation directory !_KOTLIN_HOME! 1>&2
    )
)
if not exist "%_KOTLIN_HOME%\bin\kotlinc.bat" (
    echo kotlinc not found in Kotlin installation directory ^(%_KOTLIN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_KOTLIN_PATH=;%_KOTLIN_HOME%\bin"
goto :eof

rem output parameter(s): _KOTLIN_NATIVE_HOME, _KOTLIN_NATIVE_PATH
:kotlinc-native
set _KOTLIN_NATIVE_HOME=
set _KOTLIN_NATIVE_PATH=

set __KOTLINC_NATIVE_CMD=
for /f %%f in ('where kotlinc-native.bat 2^>NUL') do set "__KOTLINC_NATIVE_CMD=%%f"
if defined __KOTLINC_NATIVE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Kotlin executable found in PATH 1>&2
    rem keep _KOTLIN_NATIVE_PATH undefined since executable already in path
    goto :eof
) else if defined KOTLIN_NATIVE_HOME (
    set "_KOTLIN_NATIVE_HOME=%KOTLIN_NATIVE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KOTLIN_NATIVE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\kotlin-native*" 2^>NUL') do set _KOTLIN_NATIVE_HOME=!__PATH!\%%f
    if not defined _KOTLIN_HOME (
        set __PATH=C:\progra~1
        for /f %%f in ('dir /ad /b "!__PATH!\kotlin-native*" 2^>NUL') do set _KOTLIN_NATIVE_HOME=!__PATH!\%%f
    )
    if defined _KOTLIN_NATIVE_HOME (
        rem path name of installation directory may contain spaces
        for /f "delims=" %%f in ("!_KOTLIN_NATIVE_HOME!") do set _KOTLIN_NATIVE_HOME=%%~sf
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Kotlin installation directory !_KOTLIN_NATIVE_HOME! 1>&2
    )
)
if not exist "%_KOTLIN_NATIVE_HOME%\bin\kotlinc-native.bat" (
    echo kotlinc-native not found in Kotlin/Native installation directory ^(%_KOTLIN_NATIVE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_KOTLIN_NATIVE_PATH=;%_KOTLIN_NATIVE_HOME%\bin"
goto :eof

rem output parameter(s): _DETEKT_HOME, _DETEKT_PATH
:detekt
set _DETEKT_HOME=
set _DETEKT_PATH=

set __DETEKT_CMD=
for /f %%f in ('where detekt-cli.bat 2^>NUL') do set "__DETEKT_CMD=%%f"
if defined __DETEKT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Detekt executable found in PATH 1>&2
    for %%i in ("%__JAVAC_CMD%") do set __JAVA_BIN_DIR=%%~dpsi
    for %%f in ("!__JAVA_BIN_DIR!..") do set _JAVA_HOME=%%~sf
    rem keep _DETEKT_PATH undefined since executable already in path
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

rem output parameter(s): _KTLINT_HOME, _KTLINT_PATH
:ktlint
set _KTLINT_PATH=

set __KTLINT_CMD=
for /f %%f in ('where ktlint.bat 2^>NUL') do set "__KTLINT_CMD=%%f"
if defined __KTLINT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of KtLint executable found in PATH 1>&2
    rem keep _KTLINT_PATH undefined since executable already in path
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
    rem keep _MAVEN_PATH undefined since executable already in path
    goto :eof
) else if defined MAVEN_HOME (
    set "__MAVEN_HOME=%MAVEN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAVEN_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\apache-maven-*" 2^>NUL') do set "__MAVEN_HOME=!_PATH!\%%f"
    if defined __MAVEN_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Maven installation directory !__MAVEN_HOME!
    )
)
if not exist "%__MAVEN_HOME%\bin\mvn.cmd" (
    echo %_ERROR_LABEL% Maven executable not found ^(%__MAVEN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAVEN_PATH=;%__MAVEN_HOME%\bin"
goto :eof

rem output parameter(s): _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    rem keep _GIT_PATH undefined since executable already in path
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
rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%_GIT_HOME%") do set _GIT_HOME=%%~sf
if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory %_GIT_HOME% 1>&2

set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\mingw64\bin;%_GIT_HOME%\usr\bin"
goto :eof

:print_env
set __VERBOSE=%1
set "__VERSIONS_LINE1=  "
set "__VERSIONS_LINE2=  "
set "__VERSIONS_LINE3=  "
set __WHERE_ARGS=
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
    rem if %_DEBUG%==1 echo %_DEBUG_LABEL% where %__WHERE_ARGS%
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p 1>&2
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
endlocal & (
    if not defined GRADLE_HOME set GRADLE_HOME=%_GRADLE_HOME%
    if not defined JAVA_HOME set JAVA_HOME=%_JAVA_HOME%
    if not defined KOTLIN_HOME set KOTLIN_HOME=%_KOTLIN_HOME%
    if not defined KOTLIN_NATIVE_HOME set KOTLIN_NATIVE_HOME=%_KOTLIN_NATIVE_HOME%
    set "PATH=%_JAVA_PATH%%PATH%%_GRADLE_PATH%%_KOTLIN_PATH%%_KOTLIN_NATIVE_PATH%%_DETEKT_PATH%%_KTLINT_PATH%%_MAVEN_PATH%%_GIT_PATH%"
    call :print_env %_VERBOSE%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
