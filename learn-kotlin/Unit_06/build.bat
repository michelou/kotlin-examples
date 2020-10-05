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
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    call :doc
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutine

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
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
set "_TEST_CLASSES_DIR=%_TARGET_DIR%\test-classes"
set "_TARGET_DOCS_DIR=%_TARGET_DIR%\docs"

set _LANGUAGE_VERSION=1.4

set _DETEKT_CMD=
if exist "%DETEKT_HOME%\bin\detekt-cli.bat" (
    set "_DETEKT_CMD=%DETEKT_HOME%\bin\detekt-cli.bat"
)
set _KTLINT_CMD=
if exist "%KTLINT_HOME%\ktlint.bat" (
    set "_KTLINT_CMD=%KTLINT_HOME%\ktlint.bat"
)
if not exist "%KOTLIN_HOME%\bin\kotlinc.bat" (
    echo %_ERROR_LABEL% Kotlin installation directory not found 1>&2
	set _EXITCODE=1
	goto :eof
)
set "_KOTLIN_CMD=%KOTLIN_HOME%\bin\kotlin.bat"
set "_KOTLINC_CMD=%KOTLIN_HOME%\bin\kotlinc.bat"

if not exist "%JAVA_HOME%\bin\java.exe" (
    echo %_ERROR_LABEL% Java SDK nstallation not found 1>&2
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

@rem input parameter: %*
@rem output parameter(s): _CLEAN, _COMPILE, _DEBUG, _RUN, _TIMER, _VERBOSE
:args
set _CLEAN=0
set _COMPILE=0
set _DETEKT=0
set _DOC=0
set _EXAMPLE=example2
set _HELP=0
set _LINT=0
set _RUN=0
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
    ) else if "%__ARG:~0,8%"=="compile:" (
        call :args_example "%__ARG:~8%"
        if not !_EXITCODE!==0 goto args_done
        set _EXAMPLE=!_ARGS_EXAMPLE!
        set _LINT=1& set _COMPILE=1
    ) else if "%__ARG%"=="detekt" ( set _DETEKT=1
    ) else if "%__ARG%"=="doc" ( set _DOC=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="lint" ( set _LINT=1
    ) else if "%__ARG:~0,5%"=="lint:" (
        call :args_example "%__ARG:~5%"
        if not !_EXITCODE!==0 goto args_done
        set _EXAMPLE=!_ARGS_EXAMPLE!
        set _LINT=1
    ) else if "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else if "%__ARG:~0,4%"=="run:" (
        call :args_example "%__ARG:~4%"
        if not !_EXITCODE!==0 goto args_done
        set _EXAMPLE=!_ARGS_EXAMPLE!
        set _COMPILE=1& set _RUN=1
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
    echo %_DEBUG_LABEL% Options    : _EXAMPLE=%_EXAMPLE% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
	echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DETEKT=%_DETEKT% _DOC=%_DOC% _LINT=%_LINT% _RUN=%_RUN% 1>&2
	echo %_DEBUG_LABEL% Variables  : JAVA_HOME="%JAVA_HOME%" KOTLIN_HOME="%KOTLIN_HOME%" 1>&2
    echo %_DEBUG_LABEL%              KTLINT_HOME="%KTLINT_HOME%" 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

@rem output parameter: _ARGS_EXAMPLE (example1, .., example4)
:args_example
set _ARGS_EXAMPLE=
set /a __SUM=%~1+0
if %__SUM% geq 1 if %__SUM% leq 5 set _ARGS_EXAMPLE=example%__SUM%
if not defined _ARGS_EXAMPLE (
    echo %_ERROR_LABEL% Example %__SUM% not found 1>&2
    set _EXITCODE=1
    goto :eof
)
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
echo     %__BEG_O%-debug%__END%         show commands executed by this script
echo     %__BEG_O%-timer%__END%         display total elapsed time
echo     %__BEG_O%-verbose%__END%       display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%          delete generated files
echo     %__BEG_O%compile[:^<n^>]%__END%  generate class files
echo     %__BEG_O%detekt%__END%         analyze Kotlin source files with %__BEG_N%Detekt%__END%
echo     %__BEG_O%doc%__END%            generate documentation
echo     %__BEG_O%help%__END%           display this help message
echo     %__BEG_O%lint[:^<n^>]%__END%     analyze Kotlin source files with %__BEG_N%KtLint%__END%
echo     %__BEG_O%run[:^<n^>]%__END%      execute the generated program
echo.
echo   Valid values: n=1..4 ^(default=%__BEG_O%2%__END%^)
goto :eof

:clean
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter(s): %1=directory path
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
set __DETEKT_OPTS=--language-version %_LANGUAGE_VERSION% --input "%_SOURCE_DIR%" --report "xml:%_TARGET_DIR%\detekt-report.xml"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_DETEKT_CMD%" %__DETEKT_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files with Detekt 1>&2
)
call "%_DETEKT_CMD%" %__DETEKT_OPTS%
if not %ERRORLEVEL%==0 (
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
set __KTLINT_OPTS="--reporter=checkstyle,output=%_TARGET_DIR%\ktlint-report.xml"

set __SOURCE_FILES=
set __N=0
for /f "delims=" %%f in ('where /r "%_SOURCE_DIR%\main\kotlin\%_EXAMPLE%" *.kt 2^>NUL') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
    set /a __N+=1
)
if not defined __SOURCE_FILES (
    echo %_WARNING_LABEL% No source file found 1>&2
    goto :eof
)
@rem prepend ! to negate the pattern in order to check only certain locations 
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KTLINT_CMD%" %__KTLINT_OPTS% %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze %__N% Kotlin source files 1>&2
)
call "%_KTLINT_CMD%" %__KTLINT_OPTS% %__SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%"

set "__SOURCES_FILE=%_TARGET_DIR%\kotlinc_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%f in ('where /r "%_SOURCE_DIR%\main\kotlin" *.kt 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No source file found 1>&2
    goto :eof
)
set "__OPTS_FILE=%_TARGET_DIR%\kotlinc_opts.txt"
echo -language-version %_LANGUAGE_VERSION% -cp "%_CLASSES_DIR:\=\\%" -d "%_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLINC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N% Kotlin source files to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_KOTLINC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of %__N% Kotlin source files failed 1>&2
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
set "_LIBS_CPATH=%_CPATH%"
goto :eof

:doc
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set __JAVA_OPTS=

@rem see https://github.com/Kotlin/dokka/releases
if not defined _DOKKA_JAR (
    echo %_ERROR_LABEL% Dokka library file not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __DOKKA_ARGS=-output "%_TARGET_DOCS_DIR%" -format html -generateIndexPages

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" %__JAVA_OPTS% -jar "%_DOKKA_JAR%" %__DOKKA_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate documentation with Dokka 1>&2
)
call "%_JAVA_CMD%" %__JAVA_OPTS% -jar "%_DOKKA_JAR%" %__DOKKA_ARGS%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:run
set __MAIN_CLASSES[example1]=PersonKt
set __MAIN_CLASSES[example2]=PersonKt
set __MAIN_CLASSES[example3]=PersonKt
set __MAIN_CLASSES[example4]=FamilyKt

set __MAIN_CLASS=com.makotogo.learn.kotlin.%_EXAMPLE%.!__MAIN_CLASSES[%_EXAMPLE%]!

set __KOTLIN_OPTS=-cp "%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLIN_CMD%" %__KOTLIN_OPTS% %__MAIN_CLASS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin main class %__MAIN_CLASS%  1>&2
)
call "%_KOTLIN_CMD%" %__KOTLIN_OPTS% %__MAIN_CLASS%
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
