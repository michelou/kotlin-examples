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
    exit /b %_EXITCODE%
)
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_DIST%==1 (
    call :dist
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameter(s): _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

where /q gradlew.bat
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Executable gradlew.bat not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set _GRADLEW_CMD=gradlew.bat
set _GRADELW_OPTS=
goto :eof

@rem input parameter: %*
@rem output paramter(s): _CLEAN, _DIST, _HELP, _VERBOSE, _UPDATE
:args
set _CLEAN=0
set _DIST=0
set _HELP=0
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
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="dist" ( set _DIST=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _DIST=%_DIST% _HELP=%_HELP% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug      print commands executed by this script
echo     -timer      print total execution time
echo     -verbose    print progress messages
echo.
echo   Subcommands:
echo     clean       delete generated files
echo     dist        generate component archive
echo     help        print this help message
goto :eof

:clean
echo CLEAN
goto :eof

@rem For local development, if you're not working on bytecode generation or the
@rem standard library, it's OK to have only JDK 1.8 and JDK 9 installed, and to
@rem point JDK_16 and JDK_17 environment variables to your JDK 1.8 installation.
@rem (see https://github.com/JetBrains/kotlin#build-environment-requirements)
:dist
setlocal
set JDK_16=%JAVA_HOME%
set JDK_17=%JAVA_HOME%
set JDK_18=%JAVA_HOME%
set JDK_9=%JAVA11_HOME%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_GRADLEW_CMD% clean 1>&2
) else if %_VERBOSE%==1 ( echo Remove generated files 1>&2
)
call "%_GRADLEW_CMD%"
if not %ERRORLEVEL%==0 (
    endlocal
    set _EXITCODE=1
    goto :eof
)
endlocal
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval=New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
