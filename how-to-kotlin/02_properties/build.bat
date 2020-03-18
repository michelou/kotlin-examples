@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
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
if %_CLEAN%==1 (
    call :clean
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
if %_RUN%==1 (
    call :run_%_TARGET%
    if not !_EXITCODE!==0 goto end
)
goto end

rem ##########################################################################
rem ## Subroutine

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
rem                    _SOURCE_FILES, _PKG_NAME
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

set _SOURCE_DIR=%_ROOT_DIR%src
set _KOTLIN_SOURCE_DIR=%_SOURCE_DIR%\main\kotlin
set _TARGET_DIR=%_ROOT_DIR%target
set _CLASSES_DIR=%_TARGET_DIR%\classes

rem derives package name from project directory name
set _PKG_NAME=
for %%d in ("%~dp0") do (
   set __DIR=%%~d
   if "!__DIR:~-1!"=="\" set __DIR=!__DIR:~0,-1!
   for %%f in ("!__DIR!") do set _PKG_NAME=_%%~nf.
)

set _KTLINT_CMD=ktlint.bat
set _KTLINT_OPTS=--reporter=checkstyle,output=%_TARGET_DIR%\ktlint-report.xml

set _KOTLINC_CMD=kotlinc.bat
set _KOTLINC_OPTS=-d %_CLASSES_DIR%

set _KOTLIN_CMD=kotlin.bat
set _KOTLIN_OPTS=-cp %_CLASSES_DIR%

set _KOTLINC_NATIVE_CMD=kotlinc-native.bat
rem option -o defined later in subroutine :args
set _KOTLINC_NATIVE_OPTS=-e "%_PKG_NAME%main"
goto :eof

rem input parameter: %*
rem output parameter(s): _CLEAN, _COMPILE, _DEBUG, _RUN, _TIMER, _VERBOSE
:args
set _CLEAN=0
set _COMPILE=0
set _HELP=0
set _LINT=0
set _RUN=0
set _TARGET=jvm
set _TIMER=0
set _VERBOSE=0
set __MAIN_NAME=Properties
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
    ) else if /i "%__ARG%"=="-native" ( set _TARGET=native
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
    ) else if /i "%__ARG%"=="help" ( set _HELP=1
    ) else if /i "%__ARG%"=="lint" ( set _LINT=1
    ) else if /i "%__ARG%"=="run" ( set _LINT=1& set _COMPILE=1& set _RUN=1
    ) else if /i "%__ARG:~0,4%"=="run:" (
        set "__MAIN_NAME=%__ARG:~4%"
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
set _MAIN_CLASS=%_PKG_NAME%%__MAIN_NAME%Kt
set _EXE_FILE=%_TARGET_DIR%\%__MAIN_NAME%.exe
set _KOTLINC_NATIVE_OPTS=-o "%_EXE_FILE%" %_KOTLINC_NATIVE_OPTS%

if %_DEBUG%==1 echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _MAIN_CLASS=%_MAIN_CLASS% _RUN=%_RUN% _VERBOSE=%_VERBOSE%
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug        show commands executed by this script
echo     -native       generated native executable
echo     -timer        display total elapsed time
echo     -verbose      display progress messages
echo.
echo   Subcommands:
echo     clean         delete generated files
echo     compile       generate class files
echo     help          display this help message
echo     lint          analyze Kotlin source files with KtLint
echo     run[:^<name^>]   execute the generated program ^(default: Properties^)
goto :eof

:clean
if not exist "%_TARGET_DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%_TARGET_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Remove directory !_TARGET_DIR:%_ROOT_DIR%=! 1>&2
)
rmdir /s /q "%_TARGET_DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:lint
set /a _PLAIN=_VERBOSE+_DEBUG
if %_PLAIN%==0 ( set __KTLINT_OPTS=%_KTLINT_OPTS%
) else ( set __KTLINT_OPTS=--reporter=plain %_KTLINT_OPTS%
)
rem prepend ! to negate the pattern in order to check only certain locations 
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KTLINT_CMD% %__KTLINT_OPTS% %_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files 1>&2
)
call %_KTLINT_CMD% %__KTLINT_OPTS% %_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_jvm
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
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files ^(JVM^) 1>&2
)
call %_KOTLINC_CMD% %_KOTLINC_OPTS% "@%__ARG_FILE%"
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_native
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KOTLINC_NATIVE_CMD% %_KOTLINC_NATIVE_OPTS% %_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files ^(native^) 1>&2
)
call %_KOTLINC_NATIVE_CMD% %_KOTLINC_NATIVE_OPTS% %_SOURCE_FILES% 
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:run_jvm
set __MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Main class file not found ^(!__MAIN_CLASS_FILE:%_ROOT_DIR%=!^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KOTLIN_CMD% %_KOTLIN_OPTS% %_MAIN_CLASS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin main class %_MAIN_CLASS%  1>&2
)
call %_KOTLIN_CMD% %_KOTLIN_OPTS% %_MAIN_CLASS%
if not %ERRORLEVEL%==0 (
   echo %_ERROR_LABEL% Execution failure ^(%_MAIN_CLASS%^) 1>&2
   set _EXITCODE=1
   goto :eof
)
goto :eof

:run_native
if not exist "%_EXE_FILE%" (
    set _EXITCODE=1
	goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_EXE_FILE% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin native !_EXE_FILE:%_ROOT_DIR%\=! 1>&2
)
%_EXE_FILE%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Elapsed time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
