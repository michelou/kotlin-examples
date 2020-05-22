@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0
set "_ROOT_DIR=%~dp0"

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

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_KOTLIN_SOURCE_DIR=%_SOURCE_DIR%\main\kotlin"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"

set _KTLINT_CMD=ktlint.bat
set _KTLINT_OPTS=--reporter=plain --reporter=checkstyle,output=%_TARGET_DIR%\ktlint-report.xml

set _KOTLINC_CMD=kotlinc.bat
set _KOTLINC_OPTS=-jvm-target 1.8 -Werror -d "%_CLASSES_DIR%"

set _KOTLIN_CMD=kotlin.bat
set _KOTLIN_OPTS=-cp "%_CLASSES_DIR%"
goto :eof

@rem input parameter: %*
@rem output parameter(s): _CLEAN, _COMPILE, _DEBUG, _RUN, _TIMER, _VERBOSE
:args
set _CLEAN=0
set _COMPILE=0
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
    rem option
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-help" ( set _HELP=1
    ) else if /i "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
   )
) else (
    rem subcommand
    set /a __N+=1
    if /i "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if /i "%__ARG%"=="compile" ( set _LINT=1& set _COMPILE=1
    ) else if /i "%__ARG:~0,8%"=="compile:" (
        call :args_example "%__ARG:~8%"
        if not !_EXITCODE!==0 goto args_done
        set _EXAMPLE=!_ARGS_EXAMPLE!
        set _LINT=1& set _COMPILE=1
    ) else if /i "%__ARG%"=="doc" ( set _DOC=1
    ) else if /i "%__ARG%"=="help" ( set _HELP=1
    ) else if /i "%__ARG%"=="lint" ( set _LINT=1
    ) else if /i "%__ARG:~0,5%"=="lint:" (
        call :args_example "%__ARG:~5%"
        if not !_EXITCODE!==0 goto args_done
        set _EXAMPLE=!_ARGS_EXAMPLE!
        set _LINT=1
    ) else if /i "%__ARG%"=="run" ( set _LINT=1& set _COMPILE=1& set _RUN=1
    ) else if /i "%__ARG:~0,4%"=="run:" (
        call :args_example "%__ARG:~4%"
        if not !_EXITCODE!==0 goto args_done
        set _EXAMPLE=!_ARGS_EXAMPLE!
        set _LINT=1& set _COMPILE=1& set _RUN=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DOC=%_DOC% _EXAMPLE=%_EXAMPLE% _RUN=%_RUN% _VERBOSE=%_VERBOSE%
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
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug         show commands executed by this script
echo     -timer         display total elapsed time
echo     -verbose       display progress messages
echo.
echo   Subcommands:
echo     clean          delete generated files
echo     compile[:^<n^>]  generate class files
echo     doc            generate documentation
echo     help           display this help message
echo     lint[:^<n^>]     analyze Kotlin source files and flag programming/stylistic errors
echo     run[:^<n^>]      execute the generated program
echo   Valid values: n=1..4 ^(default=2^)
goto :eof

:clean
if not exist "%_TARGET_DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%_TARGET_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Remove directory %_TARGET_DIR% 1>&2
)
rmdir /s /q "%_TARGET_DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:lint
set __SOURCE_FILES=
for /f "delims=" %%f in ('where /r "%_KOTLIN_SOURCE_DIR%\%_EXAMPLE%" *.kt 2^>NUL') do set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
if not defined __SOURCE_FILES (
    echo %_WARNING_LABEL% No source file found 1>&2
    goto :eof
)
rem prepend ! to negate the pattern in order to check only certain locations 
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KTLINT_CMD% %_KTLINT_OPTS% %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files 1>&2
)
call %_KTLINT_CMD% %_KTLINT_OPTS% %__SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%"

set __ARG_FILE=%_TARGET_DIR%\kt_files.txt
if exist "%__ARG_FILE%" del "%__ARG_FILE%" 1>NUL
set __N=0
for /f "delims=" %%f in ('where /r "%_KOTLIN_SOURCE_DIR%" *.kt 2^>NUL') do (
    echo %%f >> "%__ARG_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No source file found 1>&2
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KOTLINC_CMD% %_KOTLINC_OPTS% "@%__ARG_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files 1>&2
)
call %_KOTLINC_CMD% %_KOTLINC_OPTS% "@%__ARG_FILE%"
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

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KOTLIN_CMD% %_KOTLIN_OPTS% %__MAIN_CLASS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin main class %__MAIN_CLASS%  1>&2
)
call %_KOTLIN_CMD% %_KOTLIN_OPTS% %__MAIN_CLASS%
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
