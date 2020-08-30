@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0\.") do set "_ROOT_DIR=%%~dpf"
@rem remove trailing backslash for virtual drives
if "%_ROOT_DIR:~-2%"==":\" set "_ROOT_DIR=%_ROOT_DIR:~0,-1%"

@rem files gradle.properties
set _KODDA_VERSION_OLD=dokkaVersion=0.10.0
set _KODDA_VERSION_NEW=dokkaVersion=0.10.1

@rem files gradle.properties
set _KOTLIN_VERSION_OLD=kotlinVersion=1.3.71
set _KOTLIN_VERSION_NEW=kotlinVersion=1.3.72

@rem files gradle.properties
set _JUNIT_VERSION_OLD=junitVersion=4.12
set _JUNIT_VERSION_NEW=junitVersion=4.13

@rem files gradle.properties
set _KTLINT_VERSION_OLD=ktLintJar=C:/opt/ktlint-0.36.0/ktlint.jar
set _KTLINT_VERSION_NEW=ktLintJar=C:/opt/ktlint-0.37.0/ktlint.jar

@rem files pom.xml
set _MVN_KOTLIN_VERSION_OLD=kotlin.version^>1.3.71
set _MVN_KOTLIN_VERSION_NEW=kotlin.version^>1.3.72

@rem files pom.xml
set _MVN_KOTLINX_VERSION_OLD=kotlinx.version^>1.3.3
set _MVN_KOTLINX_VERSION_NEW=kotlinx.version^>1.3.7

@rem files pom.xml
set _MVN_JAR_VERSION_OLD=maven.jar.version^>3.1.2
set _MVN_JAR_VERSION_NEW=maven.jar.version^>3.2.0

@rem files pom.xml
set _MVN_EXEC_VERSION_OLD=exec.maven.version^>1.6.0
set _MVN_EXEC_VERSION_NEW=exec.maven.version^>3.0.0

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
if %_UPDATE%==1 (
    for %%i in (concurrency-in-kotlin effective-kotlin examples functional-kotlin how-to-kotlin learn-kotlin) do (
       if %_DEBUG%==1 echo %_DEBUG_LABEL% call :update_project "%_ROOT_DIR%\%%i" 1>&2
        call :update_project "%_ROOT_DIR%\%%i"
    )
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
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

:args
set _HELP=0
set _UPDATE=1
set _VERBOSE=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if ""%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if ""%__ARG%"=="-help" ( set _HELP=1
    ) else if ""%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
   )
) else (
    @rem subcommand
    if ""%__ARG%"=="help" ( set _HELP=1
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
if %_DEBUG%==1 echo %_DEBUG_LABEL% _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
goto :eof

@rem input parameters: %1=file path, %2=pattern for search value, %3=pattern for new value
:replace
set "__FILE=%~1"
set "__PATTERN_FROM=%~2"
set "__PATTERN_TO=%~3"

set __PS1_SCRIPT=^
(Get-Content '%__FILE%') ^| ^
Foreach { $_ -replace '%__PATTERN_FROM:>=^>%','%__PATTERN_TO:>=^>%' } ^| ^
Set-Content '%__FILE%'

if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "%__PS1_SCRIPT%" 1>&2
powershell -C "%__PS1_SCRIPT%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Execution of ps1 cmdlet failed 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:update_project
set "__PARENT_DIR=%~1"
set __N1=0
set __N2=0
echo Parent directory: %__PARENT_DIR%
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr /v /c:"lib"') do (
	set "__GRADLE_PROPS_FILE=%__PARENT_DIR%\%%i\gradle.properties"
    if exist "!__GRADLE_PROPS_FILE!" (
        @rem koddaVersion
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__GRADLE_PROPS_FILE!" "%_KODDA_VERSION_OLD%" "%_KODDA_VERSION_NEW%" 1>&2
        call :replace "!__GRADLE_PROPS_FILE!" "%_KODDA_VERSION_OLD%" "%_KODDA_VERSION_NEW%"
        @rem kotlinVersion
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__GRADLE_PROPS_FILE!" "%_KOTLIN_VERSION_OLD%" "%_KOTLIN_VERSION_NEW%" 1>&2
        call :replace "!__GRADLE_PROPS_FILE!" "%_KOTLIN_VERSION_OLD%" "%_KOTLIN_VERSION_NEW%"
        @rem junitVersion 
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__GRADLE_PROPS_FILE!" "%_JUNIT_VERSION_OLD%" "%_JUNIT_VERSION_NEW%" 1>&2
        call :replace "!__GRADLE_PROPS_FILE!" "%_JUNIT_VERSION_OLD%" "%_JUNIT_VERSION_NEW%"
        @rem ktLintJar
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__GRADLE_PROPS_FILE!" "%_KTLINT_VERSION_OLD%" "%_KTLINT_VERSION_NEW%" 1>&2
        call :replace "!__GRADLE_PROPS_FILE!" "%_KTLINT_VERSION_OLD%" "%_KTLINT_VERSION_NEW%"
        set /a __N1+=1
    ) else (
       echo    %_WARNING_LABEL% Could not find file %%i\gradle.properties 1>&2
    )
)
@rem Configuration files common to all projects
set "__POM_XML=%__PARENT_DIR%\pom.xml"
if exist "%__POM_XML%" (
    set /a __N2+=1
    @rem kotlin.version
	if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__POM_XML%" "%_MVN_KOTLIN_VERSION_OLD%" "%_MVN_KOTLIN_VERSION_NEW%" 1>&2
	call :replace "%__POM_XML%" "%_MVN_KOTLIN_VERSION_OLD%" "%_MVN_KOTLIN_VERSION_NEW%"
    @rem kotlinx.version
	if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__POM_XML%" "%_MVN_KOTLINX_VERSION_OLD%" "%_MVN_KOTLINX_VERSION_NEW%" 1>&2
	call :replace "%__POM_XML%" "%_MVN_KOTLINX_VERSION_OLD%" "%_MVN_KOTLINX_VERSION_NEW%"
    @rem maven.jar.version
	if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__POM_XML%" "%_MVN_JAR_VERSION_OLD%" "%_MVN_JAR_VERSION_NEW%" 1>&2
	call :replace "%__POM_XML%" "%_MVN_JAR_VERSION_OLD%" "%_MVN_JAR_VERSION_NEW%"
    @rem exec.maven.version
	if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__POM_XML%" "%_MVN_EXEC_VERSION_OLD%" "%_MVN_EXEC_VERSION_NEW%" 1>&2
	call :replace "%__POM_XML%" "%_MVN_EXEC_VERSION_OLD%" "%_MVN_EXEC_VERSION_NEW%"
) else (
   echo    %_WARNING_LABEL% Could not find file %__POM_XML% 1>&2
)
if %__N1% gtr 1 ( set __FILES1=files ) else ( set __FILES1=file )
if %__N2% gtr 1 ( set __FILES2=files ) else ( set __FILES2=file )
echo    Updated %__N1% gradle.properties %__FILES1%
echo    Updated %__N2% pom.xml %__FILES2%
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
