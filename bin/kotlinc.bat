@echo off
rem based on scalac.bat from the Scala distribution
rem ##########################################################################
rem # Copyright 2002-2011, LAMP/EPFL
rem # Copyright 2011-2015, JetBrains
rem #
rem # This is free software; see the distribution for copying conditions.
rem # There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
rem # PARTICULAR PURPOSE.
rem ##########################################################################

rem We adopt the following conventions:
rem - System/user environment variables start with a letter
rem - Local batch variables start with an underscore ('_')

setlocal enabledelayedexpansion
call :set_home

if "%_KOTLIN_COMPILER%"=="" set _KOTLIN_COMPILER=org.jetbrains.kotlin.cli.jvm.K2JVMCompiler 

if not "%JAVA_HOME%"=="" (
  if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem We use the value of the JAVA_OPTS environment variable if defined
if "%JAVA_OPTS%"=="" set JAVA_OPTS=-Xmx256M -Xms32M

set _ARGS=%*
set _JAVA_ARGS=
set _KOTLIN_ARGS=
for %%i in (%_ARGS:;=[0m%) do (
  set "__ARG=%%i"
  set "__ARG=!__ARG:[0m%=;!"
  if "!__ARG:~0,2!"=="-D" (
    set _JAVA_ARGS=!_JAVA_ARGS! "!__ARG!"
  ) else if "!__ARG:~0,2!"=="-J" (
    set _JAVA_ARGS=!_JAVA_ARGS! "!__ARG:~2!"
  ) else if "!__ARG!"=="-script" (
    set _SCRIPT_CPATH=;%_KOTLIN_HOME%\lib\kotlin-stdlib.jar;%_KOTLIN_HOME%\lib\kotlin-script-runtime.jar
    set _KOTLIN_ARGS=!_KOTLIN_ARGS! !__ARG!
  ) else (
    set _KOTLIN_ARGS=!_KOTLIN_ARGS! "!__ARG!"
  )
)
if not "%_KOTLIN_RUNNER%"=="" (
  set _JAVA_ARGS=%_JAVA_ARGS% "-Dkotlin.home=%_KOTLIN_HOME%"
  "%_JAVACMD%" %JAVA_OPTS% !_JAVA_ARGS! -cp "%_KOTLIN_HOME%\lib\kotlin-runner.jar" ^
    org.jetbrains.kotlin.runner.Main %_KOTLIN_ARGS%
) else (
  set _JAVA_ARGS=%_JAVA_ARGS% -noverify
  set _ADDITIONAL_CLASSPATH=""

  if not "%_KOTLIN_TOOL%"=="" (
    set _ADDITIONAL_CLASSPATH=;%_KOTLIN_HOME%\lib\%_KOTLIN_TOOL%
  )
  "%_JAVACMD%" %JAVA_OPTS% !_JAVA_ARGS! -cp "%_KOTLIN_HOME%\lib\kotlin-preloader.jar%_SCRIPT_CPATH%" ^
    org.jetbrains.kotlin.preloading.Preloader -cp "%_KOTLIN_HOME%\lib\kotlin-compiler.jar%_ADDITIONAL_CLASSPATH%" ^
    %_KOTLIN_COMPILER% %_KOTLIN_ARGS%
)

exit /b %ERRORLEVEL%
goto end

rem ##########################################################################
rem # subroutines

:set_home
  set _BIN_DIR=
  for %%i in (%~sf0) do set _BIN_DIR=%_BIN_DIR%%%~dpsi
  set _KOTLIN_HOME=%_BIN_DIR%..
goto :eof

:end
endlocal

