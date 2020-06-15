@echo off
setlocal enabledelayedexpansion

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
@rem                    _SOURCE_FILES, MAIN_CLASS, _EXE_FILE
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"

set _SOURCE_FILES=
for /f "delims=" %%f in ('where /r "%_SOURCE_DIR%\main\kotlin" *.kt 2^>NUL') do set _SOURCE_FILES=!_SOURCE_FILES! "%%f"

set _JAVA_SOURCE_FILES=
for /f "delims=" %%f in ('where /r "%_SOURCE_DIR%\main\java" *.java 2^>NUL') do set _JAVA_SOURCE_FILES=!_JAVA_SOURCE_FILES! "%%f"

set _MAIN_NAME=Main
set _MAIN_CLASS=%_MAIN_NAME%Kt
set "_EXE_FILE=%_TARGET_DIR%\%_MAIN_NAME%.exe"

set _DETEKT_CMD=detekt-cli.bat
set _DETEKT_OPTS=--language-version 1.3 --input "%_SOURCE_DIR%" --report "xml:%_TARGET_DIR%\detekt-report.xml"

@rem full path required (limitation of ktlint.bat)
for /f %%f in ('where ktlint.bat') do set "_KTLINT_CMD=%%f"
set _KTLINT_OPTS="--reporter=checkstyle,output=%_TARGET_DIR%\ktlint-report.xml"

set _KOTLINC_CMD=kotlinc.bat
set _KOTLINC_OPTS=-language-version 1.3 -cp "%_CLASSES_DIR%" -d "%_CLASSES_DIR%"

set _KOTLIN_CMD=kotlin.bat
set _KOTLIN_OPTS=-cp "%_CLASSES_DIR%"

set _KOTLINC_NATIVE_CMD=kotlinc-native.bat
@rem see https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinnative-compiler-options
set _KOTLINC_NATIVE_OPTS=-language-version 1.3 -o "%_EXE_FILE%"

set _JAVAC_CMD=javac.exe
set _JAVAC_OPTS=-d %_CLASSES_DIR%
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
if %_DEBUG%==1 echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DETEKT=%_DETEKT% _DOC=%_DOC% _LINT=%_LINT% _RUN=%_RUN% _TARGET=%_TARGET% _VERBOSE=%_VERBOSE% 1>&2
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug      show commands executed by this script
echo     -native     generate native executable
echo     -timer      display total elapsed time
echo     -verbose    display progress messages
echo.
echo   Subcommands:
echo     clean       delete generated files
echo     compile     generate class files
echo     detekt      analyze Kotlin source files with Detekt
echo     doc         generate documentation
echo     help        display this help message
echo     lint        analyze Kotlin source files with KtLint
echo     run         execute the generated program
goto :eof

:clean
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter(s): %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory !__DIR:%_ROOT_DIR%=! 1>&2
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
@rem prepend ! to negate the pattern in order to check only certain locations 
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KTLINT_CMD%" %_KTLINT_OPTS% %_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files with KtLint 1>&2
)
call "%_KTLINT_CMD%" %_KTLINT_OPTS% %_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_jvm
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%"

call :compile_java
if not %_EXITCODE%==0 goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLINC_CMD%" %_KOTLINC_OPTS% %_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files ^(JVM^) 1>&2
)
call "%_KOTLINC_CMD%" %_KOTLINC_OPTS% %_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_java
if not defined _JAVA_SOURCE_FILES goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVAC_CMD%" %_JAVAC_OPTS% %_JAVA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Java source files 1>&2
)
call "%_JAVAC_CMD%" %_JAVAC_OPTS% %_JAVA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_native
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_KOTLINC_NATIVE_CMD%" %_KOTLINC_NATIVE_OPTS% %_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files ^(native^) 1>&2
)
call "%_KOTLINC_NATIVE_CMD%" %_KOTLINC_NATIVE_OPTS% %_SOURCE_FILES% 
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

@rem output parameter: _LIBS_CPATH
:libs_cpath
for %%f in ("%~dp0..") do set "__BATCH_FILE=%%~sf\cpath.bat"
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
set __JAVA_OPTS=-classpath "%_LIBS_CPATH%"

@rem see https://github.com/Kotlin/dokka/releases
set __DOKKA_MAIN=org.jetbrains.dokka.MainKt
set __DOKKA_ARGS=-output "%_TARGET_DOCS_DIR%" -format html -generateIndexPages

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%__JAVA_CMD%" %__JAVA_OPTS% %__DOKKA_MAIN% %__DOKKA_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate documentation with Dokka 1>&2
)
call "%__JAVA_CMD%" %__JAVA_OPTS% %__DOKKA_MAIN% %__DOKKA_ARGS%
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
