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
@rem                    _KT_SOURCE_FILES, MAIN_CLASS, _EXE_FILE
:env
set _BASENAME=%~n0

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"

set _KT_SOURCE_FILES=
for /f "delims=" %%f in ('where /r "%_SOURCE_DIR%\main\kotlin" *.kt 2^>NUL') do set _KT_SOURCE_FILES=!_KT_SOURCE_FILES! "%%f"

set _JAVA_SOURCE_FILES=
for /f "delims=" %%f in ('where /r "%_SOURCE_DIR%\main\java" *.java 2^>NUL') do set _JAVA_SOURCE_FILES=!_JAVA_SOURCE_FILES! "%%f"

set _JAVA_MAIN_CLASS=KotlinInterop
set _KT_MAIN_NAME=JavaInterop
set _KT_MAIN_CLASS=%_KT_MAIN_NAME%Kt
set "_EXE_FILE=%_TARGET_DIR%\%_KT_MAIN_NAME%.exe"

set _DETEKT_CMD=detekt-cli.bat
set _DETEKT_OPTS=--language-version 1.3 --input "%_SOURCE_DIR%" --report "xml:%_TARGET_DIR%\detekt-report.xml"

set _KTLINT_CMD=ktlint.bat
set _KTLINT_OPTS=--color --reporter=checkstyle,output=%_TARGET_DIR%\ktlint-report.xml

set _KOTLINC_CMD=kotlinc.bat
set _KOTLINC_OPTS=-d "%_CLASSES_DIR%"

set _KOTLIN_CMD=kotlin.bat
set _KOTLIN_OPTS=-cp "%_CLASSES_DIR%"

if not exist "%KOTLIN_HOME%\lib\" (
    echo %_ERROR_LABEL% Kotlin installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set _KOTLIN_CPATH=%KOTLIN_HOME%\lib\kotlin-stdlib.jar

set _KOTLINC_NATIVE_CMD=kotlinc-native.bat
set _KOTLINC_NATIVE_OPTS=-o "%_EXE_FILE%"

set _JAVAC_CMD=javac.exe
set _JAVAC_OPTS=-cp "%_KOTLIN_CPATH%;%_CLASSES_DIR%" -d "%_CLASSES_DIR%"

set _JAVA_CMD=java.exe
set _JAVA_OPTS=-cp "%_KOTLIN_CPATH%;%_CLASSES_DIR%"
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
set _STDOUT_REDIRECT=1^>NUL
if %_DEBUG%==1 set _STDOUT_REDIRECT=1^>CON

if %_DEBUG%==1 echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _RUN=%_RUN% _VERBOSE=%_VERBOSE%
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug      show commands executed by this script
echo     -native     generated native executable
echo     -timer      display total elapsed time
echo     -verbose    display progress messages
echo.
echo   Subcommands:
echo     clean       delete generated files
echo     compile     generate class files
echo     detekt      analyze Kotlin source files with Detekt
echo     doc         generate documentation
echo     help        display this help message
echo     lint        analyze Java/Kotlin source files with KtLint
echo     run         execute the generated program
goto :eof

:clean
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter: %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "!__DIR!\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "!__DIR!" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "!__DIR!"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:detekt
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_DETEKT_CMD% %_DETEKT_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files with Detekt 1>&2
)
call %_DETEKT_CMD% %_DETEKT_OPTS%
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
call :lint_kotlin
if not %_EXITCODE%==0 goto :eof

call :lint_java
if not %_EXITCODE%==0 goto :eof
goto :eof

:lint_kotlin
if not defined _KT_SOURCE_FILES goto :eof

set "__TMP_FILE=%TEMP%\%_BASENAME%_ktlint.txt"

@rem prepend ! to negate the pattern in order to check only certain locations 
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KTLINT_CMD% %_KTLINT_OPTS% %_KT_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Kotlin source files with KtLint 1>&2
)
call %_KTLINT_CMD% %_KTLINT_OPTS% %_KT_SOURCE_FILES% 2>"%__TMP_FILE%"
if not %ERRORLEVEL%==0 (
   echo %_WARNING_LABEL% CheckStyle error found 1>&2
   if %_DEBUG%==1 ( type "%__TMP_FILE%"
   ) else if %_VERBOSE%==1 ( type "%__TMP_FILE%" 
   )
   if exist "%__TMP_FILE%" del "%__TMP_FILE%"
   @rem set _EXITCODE=1
   goto :eof
)
goto :eof

:lint_java
if not defined _JAVA_SOURCE_FILES goto :eof

call :checkstyle
if not %_EXITCODE%==0 goto :eof
goto :eof

:compile
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%"

call :compile_%_TARGET%
if not %_EXITCODE%==0 goto :eof

if %_TARGET%==native goto :eof

call :compile_java
if not %_EXITCODE%==0 goto :eof
goto :eof

:compile_jvm
if not defined _KT_SOURCE_FILES goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KOTLINC_CMD% %_KOTLINC_OPTS% %_KT_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files ^(JVM^) 1>&2
)
call %_KOTLINC_CMD% %_KOTLINC_OPTS% %_KT_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_native
if not defined _KT_SOURCE_FILES goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KOTLINC_NATIVE_CMD% %_KOTLINC_NATIVE_OPTS% %_KT_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Kotlin source files ^(native^) 1>&2
)
call %_KOTLINC_NATIVE_CMD% %_KOTLINC_NATIVE_OPTS% %_KT_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_java
if not defined _JAVA_SOURCE_FILES goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_JAVAC_CMD% %_JAVAC_OPTS% %_JAVA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Java source files 1>&2
)
call "%_JAVAC_CMD%" %_JAVAC_OPTS% %_JAVA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:doc
@rem see https://github.com/Kotlin/dokka/releases
echo %_WARNING_LABEL% Not yet implemented ^(waiting for Dokka 0.11.0^) 1>&2
goto :eof

:run
call :run_%_TARGET%
if not %_EXITCODE%==0 goto :eof

if %_TARGET%==native goto :eof

call :run_java
if not %_EXITCODE%==0 goto :eof
goto :eof

:run_jvm
set "__MAIN_CLASS_FILE=%_CLASSES_DIR%\%_KT_MAIN_CLASS:.=\%.class"
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Kotlin main class file not found ^(!__MAIN_CLASS_FILE:%_ROOT_DIR%=!^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_KOTLIN_CMD% %_KOTLIN_OPTS% %_KT_MAIN_CLASS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin main class %_KT_MAIN_CLASS%  1>&2
)
call %_KOTLIN_CMD% %_KOTLIN_OPTS% %_KT_MAIN_CLASS%
if not %ERRORLEVEL%==0 (
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
) else if %_VERBOSE%==1 ( echo Execute Kotlin native application !_EXE_FILE:%_ROOT_DIR%\=! 1>&2
)
call "%_EXE_FILE%"
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:run_java
set __MAIN_CLASS_FILE=%_CLASSES_DIR%\%_JAVA_MAIN_CLASS:.=\%.class
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Java main class file not found ^(!__MAIN_CLASS_FILE:%_ROOT_DIR%=!^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_JAVA_CMD% %_JAVA_OPTS% %_JAVA_MAIN_CLASS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Kotlin main class %_JAVA_MAIN_CLASS%  1>&2
) else ( echo.
)
call %_JAVA_CMD% %_JAVA_OPTS% %_JAVA_MAIN_CLASS%
if not %ERRORLEVEL%==0 (
   set _EXITCODE=1
   goto :eof
)
goto :eof

:checkstyle
set "__USER_KOTLIN_DIR=%USERPROFILE%\.kotlin"
if not exist "%__USER_KOTLIN_DIR%" mkdir "%__USER_KOTLIN_DIR%"

set "__XML_FILE=%__USER_KOTLIN_DIR%\java_checks.xml"
if not exist "%__XML_FILE%" call :checkstyle_xml "%__XML_FILE%"
)
set __JAR_VERSION=8.32
set __JAR_NAME=checkstyle-%__JAR_VERSION%-all.jar
set __JAR_URL=https://github.com/checkstyle/checkstyle/releases/download/checkstyle-%__JAR_VERSION%/%__JAR_NAME%
set "__JAR_FILE=%__USER_KOTLIN_DIR%\%__JAR_NAME%"
if exist "%__JAR_FILE%" goto checkstyle_analyze

set "__PS1_FILE=%__USER_KOTLIN_DIR%\webrequest.ps1"
if not exist "%__PS1_FILE%" call :checkstyle_ps1 "%__PS1_FILE%"

set __PS1_VERBOSE[0]=
set __PS1_VERBOSE[1]=-Verbose
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -c "& '%__PS1_FILE%' -Uri '%__JAR_URL%' -Outfile '%__JAR_FILE%'" 1>&2
) else if %_VERBOSE%==1 ( echo Download file %__JAR_NAME% 1>&2
) else ( echo Download file %__JAR_NAME%
)
powershell -c "& '%__PS1_FILE%' -Uri '%__JAR_URL%' -OutFile '%__JAR_FILE%' !__PS1_VERBOSE[%_VERBOSE%]!"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to download file %__JAR_NAME% 1>&2
    set _EXITCODE=1
    goto :eof
)
:checkstyle_analyze
set __SOURCE_FILES=
for /f "delims=" %%f in ('where /r "%_SOURCE_DIR%" *.java') do set __SOURCE_FILES=!__SOURCE_FILES! %%f

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_JAVA_CMD% -jar "%__JAR_FILE%" -c="%__XML_FILE%" %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Java source files with CheckStyle configuration !__XML_FILE:%USERPROFILE%\=! 1>&2
)
%_JAVA_CMD% -jar "%__JAR_FILE%" -c="%__XML_FILE%" %__SOURCE_FILES% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    @rem set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=XML file path
@rem NB. Archive checkstyle-*-all.jar contains 2 configuration files:
@rem     google_checks.xml, sun_checks.xml.
:checkstyle_xml
set "__XML_FILE=%~1"
(
    echo ^<?xml version="1.0"?^>
    echo ^<^^!DOCTYPE module PUBLIC
    echo           "-//Checkstyle//DTD Checkstyle Configuration 1.3//EN"
    echo           "https://checkstyle.org/dtds/configuration_1_3.dtd"^>
    echo.
    echo ^<module name="Checker"^>
    echo     ^<property name="localeCountry" value="US"/^>
    echo     ^<property name="localeLanguage" value="en"/^>
    echo     ^<property name="severity" value="error"/^>
    echo     ^<property name="fileExtensions" value="java, properties, xml"/^>
    echo     ^<^^!-- See https://checkstyle.org/config_whitespace.html --^>
    echo     ^<module name="FileTabCharacter"/^>
    echo     ^<module name="TreeWalker"^>
    echo         ^<^^!-- See https://checkstyle.org/config_import.html --^>
    echo         ^<module name="AvoidStarImport"/^>
    echo         ^<module name="IllegalImport"/^> ^<^^!-- defaults to sun.* packages --^>
    echo         ^<module name="RedundantImport"/^>
    echo         ^<module name="UnusedImports"^>
    echo             ^<property name="processJavadoc" value="false"/^>
    echo         ^</module^>
    echo         ^<^^!-- See https://checkstyle.org/config_whitespace.html --^>
    echo         ^<module name="EmptyForIteratorPad"/^>
    echo         ^<module name="GenericWhitespace"/^>
    echo         ^<module name="MethodParamPad"/^>
    echo         ^<module name="NoWhitespaceAfter"/^>
    echo         ^<module name="NoWhitespaceBefore"/^>
    echo         ^<module name="OperatorWrap"/^>
    echo         ^<module name="ParenPad"/^>
    echo         ^<module name="TypecastParenPad"/^>
    echo         ^<module name="WhitespaceAfter"/^>
    echo         ^<module name="WhitespaceAround"/^>
    echo     ^</module^>
    echo ^</module^>
) > "%__XML_FILE%"
goto :eof

@rem input parameter: %1=PS1 file path
:checkstyle_ps1
set "__PS1_FILE=%~1"
@rem see https://stackoverflow.com/questions/11696944/powershell-v3-invoke-webrequest-https-error
@rem NB. cURL is a standard tool only from Windows 10 build 17063 and later.
(
    echo Param^(
    echo    [Parameter^(Mandatory=$True,Position=1^)]
    echo    [string]$Uri,
    echo    [Parameter(Mandatory=$True^)]
    echo    [string]$OutFile
    echo ^)
    echo Add-Type ^@^"
    echo using System.Net;
    echo using System.Security.Cryptography.X509Certificates;
    echo public class TrustAllCertsPolicy : ICertificatePolicy {
    echo     public bool CheckValidationResult^(
    echo         ServicePoint srvPoint, X509Certificate certificate,
    echo         WebRequest request, int certificateProblem^) {
    echo         return true;
    echo     }
    echo }
    echo ^"^@
    echo $Verbose=$PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent
    echo $AllProtocols=[System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
    echo [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
    echo [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    echo $progressPreference='silentlyContinue'
    echo Invoke-WebRequest -TimeoutSec 60 -Uri $Uri -Outfile $OutFile
) > "%__PS1_FILE%"
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
