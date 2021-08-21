@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :props
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_DETEKT%==1 (
    call :detekt
    if not !_EXITCODE!==0 goto end
)
if %_LINT%==1 (
    call :lint
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile_%_TARGET%
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    call :doc
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run_%_TARGET%
    if not !_EXITCODE!==0 goto end
)
if %_TEST%==1 (
    call :test_%_TARGET%
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutine

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
@rem                    _LANGUAGE_VERSION, _MAIN_CLASS, _EXE_FILE
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_KOTLIN_SOURCE_DIR=%_SOURCE_DIR%\main\kotlin"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"
set "_TEST_CLASSES_DIR=%_TARGET_DIR%\test-classes"
set "_TARGET_DOCS_DIR=%_TARGET_DIR%\docs"

set _LANGUAGE_VERSION=1.4

@rem derives package name from project directory name
set _PKG_NAME=
for %%d in ("%~dp0") do (
   set "__DIR=%%~d"
   if "!__DIR:~-1!"=="\" set __DIR=!__DIR:~0,-1!
   for %%f in ("!__DIR!") do set _PKG_NAME=_%%~nf.
)
set _MAIN_NAME=Conventions
set _MAIN_CLASS=%_PKG_NAME%%_MAIN_NAME%Kt
set "_EXE_FILE=%_TARGET_DIR%\%_MAIN_NAME%.exe"

set _DETEKT_CMD=
if exist "%DETEKT_HOME%\bin\detekt-cli.bat" (
    set "_DETEKT_CMD=%DETEKT_HOME%\bin\detekt-cli.bat"
)
set _KTLINT_CMD=
if exist "%KTLINT_HOME%\ktlint.bat" (
    set "_KTLINT_CMD=%KTLINT_HOME%\ktlint.bat"
)
if not exist "%KOTLIN_HOME%\bin\kotlinc.bat" (
    echo %_ERROR_LABEL% Kotlin installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_KOTLIN_CMD=%KOTLIN_HOME%\bin\kotlin.bat"
set "_KOTLINC_CMD=%KOTLIN_HOME%\bin\kotlinc.bat"

if not exist "%KOTLIN_NATIVE_HOME%\bin\kotlinc-native.bat" (
    echo %_ERROR_LABEL% Kotlin Native installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_KOTLINC_NATIVE_CMD=%KOTLIN_NATIVE_HOME%\bin\kotlinc-native.bat"

if not exist "%JAVA_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% Java SDK installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_JAVA_CMD=%JAVA_HOME%\bin\java.exe"
set "_JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"
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

@rem _PROJECT_NAME, _PROJECT_URL, _PROJECT_VERSION
:props
for %%i in ("%~dp0\.") do set "_PROJECT_NAME=%%~ni"
set _PROJECT_URL=github.com/%USERNAME%/kotlin-examples
set _PROJECT_VERSION=0.1-SNAPSHOT

set "__PROPS_FILE=%_ROOT_DIR%build.properties"
if exist "%__PROPS_FILE%" (
    for /f "tokens=1,* delims==" %%i in (%__PROPS_FILE%) do (
        set __NAME=
        set __VALUE=
        for /f "delims= " %%n in ("%%i") do set __NAME=%%n
        @rem line comments start with "#"
        if defined __NAME if not "!__NAME:~0,1!"=="#" (
            @rem trim value
            for /f "tokens=*" %%v in ("%%~j") do set __VALUE=%%v
            set "_!__NAME:.=_!=!__VALUE!"
        )
    )
    if defined _project_name set _PROJECT_NAME=!_project_name!
    if defined _project_url set _PROJECT_URL=!_project_url!
    if defined _project_version set _PROJECT_VERSION=!_project_version!
)
goto :eof

@rem input parameter: %*
@rem output parameter(s): _CLEAN, _COMPILE, _DEBUG, _RUN, _TIMER, _VERBOSE
:args
set _CLEAN=0
set _COMPILE=0
set _DETEKT=0
set _DOC=0
set _HELP=0
set _LINT=0
set _RUN=0
set _TARGET=jvm
set _TEST=0
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-native" ( set _TARGET=native
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
   )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="detekt" ( set _DETEKT=1
    ) else if "%__ARG%"=="doc" ( set _DOC=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="lint" ( set _LINT=1
    ) else if "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else if "%__ARG%"=="test" ( set _COMPILE=1& set _TEST=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
set _STDERR_REDIRECT=2^>NUL
if %_DEBUG%==1 set _STDERR_REDIRECT=

if %_DETEKT%==1 if not defined _DETEKT_CMD (
    echo %_WARNING_LABEL% Detekt tool not found ^(disable subcommand 'detekt'^) 1>&2
    set _DETEKT=0
)
if %_LINT%==1 if not defined _KTLINT_CMD (
    echo %_WARNING_LABEL% KtLint tool not found ^(disable subcommand 'lint'^) 1>&2
    set _LINT=0
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Properties : _PROJECT_NAME=%_PROJECT_NAME% _PROJECT_VERSION=%_PROJECT_VERSION% 1>&2
    echo %_DEBUG_LABEL% Options    : _TARGET=%_TARGET% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DETEKT=%_DETEKT% _DOC=%_DOC% _LINT=%_LINT% _RUN=%_RUN% _TEST=%_TEST% 1>&2
    echo %_DEBUG_LABEL% Variables  : "JAVA_HOME=%JAVA_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "KOTLIN_HOME=%KOTLIN_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "KOTLIN_NATIVE_HOME=%KOTLIN_NATIVE_HOME%" 1>&2
    if defined _KTLINT_CMD echo %_DEBUG_LABEL% Variables  : "KTLINT_HOME=%KTLINT_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : _LANGUAGE_VERSION=%_LANGUAGE_VERSION% _MAIN_CLASS=%_MAIN_CLASS% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-debug%__END%      show commands executed by this script
echo     %__BEG_O%-native%__END%     generate native executable
echo     %__BEG_O%-timer%__END%      display total elapsed time
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%       delete generated files
echo     %__BEG_O%compile%__END%     generate class files
echo     %__BEG_O%detekt%__END%      analyze Kotlin source files with %__BEG_N%Detekt%__END%
echo     %__BEG_O%doc%__END%         generate HTML documentation with %__BEG_N%Dokka%__END%
echo     %__BEG_O%help%__END%        display this help message
echo     %__BEG_O%lint%__END%        analyze Kotlin source files with %__BEG_N%KtLint%__END%
echo     %__BEG_O%run%__END%         execute the generated program
echo     %__BEG_O%test%__END%        execute unit tests
if %_VERBOSE%==0 goto :eof
echo.
echo   %__BEG_P%Build tools:%__END%
echo     %__BEG_O%^> build clean run%__END%
echo     %__BEG_O%^> gradle -q clean run%__END%
echo     %__BEG_O%^> mvn -q clean compile exec:java%__END%
goto :eof

:clean
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter: %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:detekt
for %%f in ("%~dp0\.") do set "__CONFIG_FILE=%%~dpfdetekt-config.yml"

set __DETEKT_OPTS=--language-version %_LANGUAGE_VERSION% --config "%__CONFIG_FILE%" --input "%_SOURCE_DIR%" --report "xml:%_TARGET_DIR%\detekt-report.xml"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_DETEKT_CMD%" %__DETEKT_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files with Detekt 1>&2
)
call "%_DETEKT_CMD%" %__DETEKT_OPTS% %_STDERR_REDIRECT%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 if exist "%_TARGET_DIR%\detekt-report.xml" (
        set __SIZE=0
        for %%f in (%_TARGET_DIR%\detekt-report.xml) do set __SIZE=%%~zf
        if !__SIZE! gtr 79 type "%_TARGET_DIR%\detekt-report.xml" 1>&2
    )
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 if exist "%_TARGET_DIR%\detekt-report.xml" (
    set __SIZE=0
    for %%f in (%_TARGET_DIR%\detekt-report.xml) do set __SIZE=%%~zf
    if !__SIZE! gtr 79 type "%_TARGET_DIR%\detekt-report.xml"
)
goto :eof

:lint
set __KTLINT_OPTS=--color "--reporter=checkstyle,output=%_TARGET_DIR%\ktlint-report.xml"

if %_DEBUG%==1 ( set __KTLINT_OPTS=--reporter=plain %__KTLINT_OPTS%
) else if %_VERBOSE%==1 ( set __KTLINT_OPTS=--reporter=plain %__KTLINT_OPTS%
)
set "__TMP_FILE=%_TARGET_DIR%\ktlint_output.txt"

@rem KtLint does not support absolute path in globs.
@rem prepend ! to negate the pattern in order to check only certain locations 
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KTLINT_CMD%" %__KTLINT_OPTS% "src/**/*.kt" 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files with KtLint 1>&2
)
call "%_KTLINT_CMD%" %__KTLINT_OPTS% "src/**/*.kt" 2>"%__TMP_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_WARNING_LABEL% Ktlint error found 1>&2
    if %_DEBUG%==1 ( type "%__TMP_FILE%"
    ) else if %_VERBOSE%==1 ( type "%__TMP_FILE%" 
    )
    if exist "%__TMP_FILE%" del "%__TMP_FILE%"
    @rem set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_jvm
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%"

set "__TIMESTAMP_FILE=%_CLASSES_DIR%\.latest-build"

call :action_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\kotlin\*.kt"
if %_ACTION_REQUIRED%==0 goto :eof

set "__SOURCES_FILE=%_TARGET_DIR%\kotlinc_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%f in ('where /r "%_KOTLIN_SOURCE_DIR%" *.kt 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Kotlin source file found 1>&2
    goto :eof
)
set /a __WARN_ENABLED=_VERBOSE+_DEBUG
if %__WARN_ENABLED%==0 ( set __NOWARN_OPT=-nowarn
) else ( set __NOWARN_OPT=
)
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\kotlinc_opts.txt"
set "__CPATH=%_LIBS_CPATH%%_CLASSES_DIR%"
echo -language-version %_LANGUAGE_VERSION% %__NOWARN_OPT% -cp "%__CPATH:\=\\%" -d "%_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLINC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N% Kotlin source files ^(JVM^) to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_KOTLINC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of %__N% Kotlin source files failed ^(JVM^) 1>&2
    set _EXITCODE=1
    goto :eof
)
echo. > "%__TIMESTAMP_FILE%"
goto :eof

:compile_native
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

set "__TIMESTAMP_FILE=%_TARGET_DIR%\.latest-native-build"

call :action_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\kotlin\*.kt"
if %_ACTION_REQUIRED%==0 goto :eof

set "__SOURCES_FILE=%_TARGET_DIR%\kotlinc-native_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%f in ('dir /s /b "%_KOTLIN_SOURCE_DIR%\*.kt" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
set /a __WARN_ENABLED=_VERBOSE+_DEBUG
if %__WARN_ENABLED%==0 ( set __NOWARN_OPT=-nowarn
) else ( set __NOWARN_OPT=
)
set "__OPTS_FILE=%_TARGET_DIR%\kotlinc-native_opts.txt"
echo -language-version %_LANGUAGE_VERSION% %__NOWARN_OPT% -o "%_EXE_FILE:\=\\%" -e "%_PKG_NAME%main" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLINC_NATIVE_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N% Kotlin source files ^(native^) 1>&2
)
call "%_KOTLINC_NATIVE_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of %__N% Kotlin source files failed ^(native^) 1>&2
    set _EXITCODE=1
    goto :eof
)
echo. > "%__TIMESTAMP_FILE%"
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:action_path
shift
set __PATH=%~1
if not defined __PATH goto action_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto action_path

:action_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : '%__TARGET_FILE%' 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^(%__PATH_ARRAY1:~1%^) 1>&2
)
goto :eof

@rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __DATE1=%__TIMESTAMP1:~0,8%
set __TIME1=%__TIMESTAMP1:~-6%

set __DATE2=%__TIMESTAMP2:~0,8%
set __TIME2=%__TIMESTAMP2:~-6%

if %__DATE1% gtr %__DATE2% ( set _NEWER=1
) else if %__DATE1% lss %__DATE2% ( set _NEWER=0
) else if %__TIME1% gtr %__TIME2% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

@rem output parameter: _LIBS_CPATH
:libs_cpath
for %%f in ("%~dp0\.") do set "__BATCH_FILE=%%~dpfcpath.bat"
if not exist "%__BATCH_FILE%" (
    echo %_ERROR_LABEL% Batch file "%__BATCH_FILE%" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%__BATCH_FILE%" %_DEBUG% 1>&2
call "%__BATCH_FILE%" %_DEBUG%
set _LIBS_CPATH=%_CPATH%
goto :eof

:doc
if not exist "%_TARGET_DOCS_DIR%" mkdir "%_TARGET_DOCS_DIR%"

call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set __JAVA_OPTS=

@rem see https://github.com/Kotlin/dokka/releases
set __ARGS=-src %_SOURCE_DIR%\main\kotlin
set __DOKKA_ARGS=-pluginsClasspath "%_DOKKA_CPATH%" -moduleName %_PROJECT_NAME% -moduleVersion %_PROJECT_VERSION% -outputDir "%_TARGET_DOCS_DIR%" -sourceSet "%__ARGS%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" %__JAVA_OPTS% -jar "%_DOKKA_JAR%" %__DOKKA_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate HTML documentation with Dokka 1>&2
)
call "%_JAVA_CMD%" %__JAVA_OPTS% -jar "%_DOKKA_JAR%" %__DOKKA_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Generation of HTML documentation failed 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:run_jvm
set "__MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class"
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Kotlin main class file not found ^("!__MAIN_CLASS_FILE:%_ROOT_DIR%=!"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem call :libs_cpath
@rem if not %_EXITCODE%==0 goto :eof

set __KOTLIN_OPTS=-cp "%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLIN_CMD%" %__KOTLIN_OPTS% %_MAIN_CLASS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin main class %_MAIN_CLASS%  1>&2
)
call "%_KOTLIN_CMD%" %__KOTLIN_OPTS% %_MAIN_CLASS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Execution failure ^(%_MAIN_CLASS%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:run_native
if not exist "%_EXE_FILE%" (
    echo %_ERROR_LABEL% Kotlin executable not found ^("!_EXE_FILE:%_ROOT_DIR%=!"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_EXE_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin native application "!_EXE_FILE:%_ROOT_DIR%\=!" 1>&2
)
call "%_EXE_FILE%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_test_jvm
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

if not exist "%_TEST_CLASSES_DIR%" mkdir "%_TEST_CLASSES_DIR%" 1>NUL

set "__SOURCES_FILE=%_TARGET_DIR%\test_kotlinc_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\test\kotlin\*.kt" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Kotlin test source files found 1>&2
    goto :eof
)
set "__OPTS_FILE=%_TARGET_DIR%\test_kotlinc_opts.txt"
set "__CPATH=%_CPATH%%_CLASSES_DIR%"
echo -cp "%__CPATH:\=\\%" -d "%_TEST_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLINC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N% Kotlin test source files ^(JVM^) 1>&2
)
call "%_KOTLINC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of %__N% Kotlin test source files failed ^(JVM^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test_jvm
call :compile_test_jvm
if not %_EXITCODE%==0 goto :eof

set __TEST_KOTLIN_OPTS=-classpath "%_CPATH%%_CLASSES_DIR%;%_TEST_CLASSES_DIR%"

@rem see https://github.com/junit-team/junit4/wiki/Getting-started
for /f "usebackq" %%f in (`dir /s /b "%_TEST_CLASSES_DIR%\*JUnitTest.class" 2^>NUL`) do (
    call :test_main_class "%%f"
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLIN_CMD%" %__TEST_KOTLIN_OPTS% org.junit.runner.JUnitCore !_TEST_MAIN_CLASS! 1>&2
    ) else if %_VERBOSE%==1 ( echo Execute test !_TEST_MAIN_CLASS! 1>&2
    )
    call "%_KOTLIN_CMD%" %__TEST_KOTLIN_OPTS% org.junit.runner.JUnitCore !_TEST_MAIN_CLASS!
    if not !ERRORLEVEL!==0 (
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

@rem input parameter: %1=class file path
@rem output parameter: _TEST_MAIN_CLASS
:test_main_class
for %%i in (%~dp1) do set __PKG_NAME=%%i
for %%i in (%~n1) do set __CLS_NAME=%%i
set __PKG_NAME=!__PKG_NAME:%_TEST_CLASSES_DIR%\=!
if defined __PKG_NAME ( set "_TEST_MAIN_CLASS=!__PKG_NAME:\=.!%__CLS_NAME%"
) else ( set "_TEST_MAIN_CLASS=%__CLS_NAME%"
)
goto :eof

:test_native
echo Not yet implemented
set _EXITCODE=1
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total elapsed time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
