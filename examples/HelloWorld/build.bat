@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
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
goto end

@rem #########################################################################
@rem ## Subroutine

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
@rem                    _MAIN_CLASS, _EXE_FILE
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"
set "_TARGET_DOCS_DIR=%_TARGET_DIR%\docs"

set __PKG_NAME=org.example.main

set _MAIN_NAME=HelloWorld
set _MAIN_CLASS=%__PKG_NAME%.%_MAIN_NAME%Kt
set "_EXE_FILE=%_TARGET_DIR%\%_MAIN_NAME%.exe"

set _DETEKT_CMD=detekt-cli.bat
set _DETEKT_OPTS=--language-version 1.3 --input "%_SOURCE_DIR%" --report "xml:%_TARGET_DIR%\detekt-report.xml"

@rem full path required (limitation of ktlint.bat)
for /f %%f in ('where ktlint.bat') do set "_KTLINT_CMD=%%f"
set _KTLINT_OPTS=--color "--reporter=checkstyle,output=%_TARGET_DIR%\ktlint-report.xml"

set _KOTLINC_CMD=kotlinc.bat
set _KOTLINC_OPTS=-language-version 1.3 -d "%_CLASSES_DIR%"

set _KOTLIN_CMD=kotlin.bat
set _KOTLIN_OPTS=-cp "%_CLASSES_DIR%"

set _KOTLINC_NATIVE_CMD=kotlinc-native.bat
set _KOTLINC_NATIVE_OPTS=-language-version 1.3 -o "%_EXE_FILE%" -e "%__PKG_NAME%.main"
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
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-help" ( set _HELP=1
    ) else if /i "%__ARG%"=="-native" ( set _TARGET=native
    ) else if /i "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
   )
) else (
    @rem subcommand
    if /i "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if /i "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if /i "%__ARG%"=="detekt" ( set _DETEKT=1
    ) else if /i "%__ARG%"=="doc" ( set _DOC=1
    ) else if /i "%__ARG%"=="help" ( set _HELP=1
    ) else if /i "%__ARG%"=="lint" ( set _LINT=1
    ) else if /i "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
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
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DETEKT=%_DETEKT% _DOC=%_DOC% _LINT=%_LINT% _RUN=%_RUN% _TARGET=%_TARGET% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% _MAIN_CLASS=%_MAIN_CLASS% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-debug%__END%      show commands executed by this script
echo     %__BEG_O%-native%__END%     generate native executable
echo     %__BEG_O%-timer%__END%      display total elapsed time
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%       delete generated files
echo     %__BEG_O%compile%__END%     generate class files
echo     %__BEG_O%detekt%__END%      analyze Kotlin source files with %__BEG_N%Detekt%__END%
echo     %__BEG_O%doc%__END%         generate documentation
echo     %__BEG_O%help%__END%        display this help message
echo     %__BEG_O%lint%__END%        analyze Kotlin source files with %__BEG_N%KtLint%__END%
echo     %__BEG_O%run%__END%         execute the generated program
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
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_DETEKT_CMD%" %_DETEKT_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files with Detekt 1>&2
)
call "%_DETEKT_CMD%" %_DETEKT_OPTS%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 if exist "%_TARGET_DIR%\detekt-report.xml" (
        set __SIZE=0
        for %%f in (%_TARGET_DIR%\detekt-report.xml) do set __SIZE=%%~zf
        if !__SIZE! gtr 79 type "%_TARGET_DIR%\detekt-report.xml"
    )
    set _EXITCODE=1
    goto :eof
)
goto :eof

:lint
set /a _PLAIN=_VERBOSE+_DEBUG
if %_PLAIN%==0 ( set __KTLINT_OPTS=%_KTLINT_OPTS%
) else ( set __KTLINT_OPTS=--reporter=plain %_KTLINT_OPTS%
)
set __SOURCE_FILES=
for /f "delims=" %%f in ('where /r "%_SOURCE_DIR%\main\kotlin" *.kt 2^>NUL') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
)
@rem prepend ! to negate the pattern in order to check only certain locations 
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KTLINT_CMD%" %__KTLINT_OPTS% %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files with KtLint 1>&2
)
call "%_KTLINT_CMD%" %__KTLINT_OPTS% %__SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_jvm
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%"

set "__SOURCES_FILE=%_TARGET_DIR%\kotlinc_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\main\kotlin\*.kt" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
)
set "__OPTS_FILE=%_TARGET_DIR%\kotlinc_opts.txt"
echo %_KOTLINC_OPTS:\=\\% > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLINC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files ^(JVM^) 1>&2
)
call "%_KOTLINC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_native
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

set "__SOURCES_FILE=%_TARGET_DIR%\kotlinc-native_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\main\kotlin\*.kt" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
)
set "__OPTS_FILE=%_TARGET_DIR%\kotlinc-native_opts.txt"
echo %_KOTLINC_NATIVE_OPTS:\=\\% > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLINC_NATIVE_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files ^(native^) 1>&2
)
call "%_KOTLINC_NATIVE_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
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
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set __JAVA_CMD=java.exe
set __JAVA_OPTS=

@rem see https://github.com/Kotlin/dokka/releases
set __DOKKA_JAR=
for /f "delims=;" %%i in ("%_CPATH%") do (
    set "__PATH=%%i"
    if not "!__PATH:dokka=!"=="!__PATH!" set "__DOKKA_JAR=!__PATH!"
)
if not defined __DOKKA_JAR (
    echo %_ERROR_LABEL% Dokka library file not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __DOKKA_ARGS=-output "%_TARGET_DOCS_DIR%" -format html -generateIndexPages

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%__JAVA_CMD%" %__JAVA_OPTS% -jar "%__DOKKA_JAR%" %__DOKKA_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate documentation with Dokka 1>&2
)
call "%__JAVA_CMD%" %__JAVA_OPTS% -jar "%__DOKKA_JAR%" %__DOKKA_ARGS%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:run_jvm
set "__MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class"
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Kotlin main class file not found ^(!__MAIN_CLASS_FILE:%_ROOT_DIR%=!^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLIN_CMD%" %_KOTLIN_OPTS% %_MAIN_CLASS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin main class %_MAIN_CLASS%  1>&2
)
call "%_KOTLIN_CMD%" %_KOTLIN_OPTS% %_MAIN_CLASS%
if not %ERRORLEVEL%==0 (
   echo %_ERROR_LABEL% Execution failure ^(%_MAIN_CLASS%^) 1>&2
   set _EXITCODE=1
   goto :eof
)
goto :eof

:run_native
if not exist "%_EXE_FILE%" (
    echo %_ERROR_LABEL% Kotlin executable file not found ^("!_EXE_FILE:%_ROOT_DIR%=!"^) 1>&2
    set _EXITCODE=1
	goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_EXE_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin native "!_EXE_FILE:%_ROOT_DIR%\=!" 1>&2
)
call "%_EXE_FILE%"
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
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
