@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

rem ##########################################################################
rem # Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

call :env
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if %_DEBUG%==1 echo %_DEBUG_LABEL% %_JAVACMD% %_JAVA_OPTS% -jar %_KTLINT_HOME%\ktlint.jar %* 1>&2
%_JAVACMD% %_JAVA_OPTS% -jar %_KTLINT_HOME%\ktlint.jar %*
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameter(s): _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
rem                      _KTLINT_HOME, _JAVA_HOME, _JAVACMD
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

if defined KTLINT_HOME (
    set _KTLINT_HOME=%KTLINT_HOME%
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\ktlint*"') do set "_KTLINT_HOME=!__PATH!\%%f"
)
if not exist "%_KTLINT_HOME%\ktlint.jar" (
    echo %_ERROR_LABEL% KtLint archive file not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if defined JAVACMD (
    for %%f in ("%JAVACMD%") do set "__BIN_DIR=%%~dpf"
    for %%f in ("!__BIN_DIR!") do set "_JAVA_HOME=%%~dpf"
) else if defined JAVA_HOME (
    set _JAVA_HOME=%JAVA_HOME%
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jdk-1.8*"') do set "_JAVA_HOME=!__PATH!\%%f"
)
set _JAVACMD=%_JAVA_HOME%\bin\java.exe
if not exist "%_JAVACMD%" (
    echo %_ERROR_LABEL% Executable java.exe not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if defined JAVA_OPTS ( set _JAVA_OPTS=%JAVA_OPTS%
) else ( set _JAVA_OPTS=-Xmx512m
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _KTLINT_HOME=%_KTLINT_HOME% _JAVA_HOME=%_JAVA_HOME%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
