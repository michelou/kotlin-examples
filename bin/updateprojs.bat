@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=1

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf
rem remove trailing backslash for virtual drives
if "%_ROOT_DIR:~-2%"==":\" set "_ROOT_DIR=%_ROOT_DIR:~0,-1%"

rem files gradle.properties
set _KOTLIN_VERSION_OLD=kotlinVersion=1.3.61
set _KOTLIN_VERSION_NEW=kotlinVersion=1.3.71

rem files gradle.properties
set _JUNIT_VERSION_OLD=junitVersion=4.12
set _JUNIT_VERSION_NEW=junitVersion=4.13

rem files pom.xml
set _MVN_KOTLIN_VERSION_OLD=kotlin.version^>1.3.61
set _MVN_KOTLIN_VERSION_NEW=kotlin.version^>1.3.71

call :env
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

for %%i in (examples how-to-kotlin learn-kotlin) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :update_project "%_ROOT_DIR%\%%i" 1>&2
    call :update_project "%_ROOT_DIR%\%%i"
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:
goto :eof

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
set __PARENT_DIR=%~1
set __N1=0
set __N2=0
echo Parent directory: %__PARENT_DIR%
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr /v /c:"lib"') do (
	set "__GRADLE_PROPS_FILE=%__PARENT_DIR%\%%i\gradle.properties"
    if exist "!__GRADLE_PROPS_FILE!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__GRADLE_PROPS_FILE!" "%_KOTLIN_VERSION_OLD%" "%_KOTLIN_VERSION_NEW%" 1>&2
        call :replace "!__GRADLE_PROPS_FILE!" "%_KOTLIN_VERSION_OLD%" "%_KOTLIN_VERSION_NEW%"
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__GRADLE_PROPS_FILE!" "%_JUNIT_VERSION_OLD%" "%_JUNIT_VERSION_NEW%" 1>&2
        call :replace "!__GRADLE_PROPS_FILE!" "%_JUNIT_VERSION_OLD%" "%_JUNIT_VERSION_NEW%"
        set /a __N1+=1
    ) else (
       echo    Warning: Could not find file %%i\gradle.properties 1>&2
    )
)
rem Configuration files common to all projects
set "__POM_XML=%__PARENT_DIR%\pom.xml"
if exist "%__POM_XML%" (
    set /a __N2+=1
	if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__POM_XML%" "%_MVN_KOTLIN_VERSION_OLD%" "%_MVN_KOTLIN_VERSION_NEW%" 1>&2
	call :replace "%__POM_XML%" "%_MVN_KOTLIN_VERSION_OLD%" "%_MVN_KOTLIN_VERSION_NEW%"
) else (
   echo    Warning: Could not find file %__POM_XML% 1>&2
)

echo    Updated %__N1% gradle.properties files
echo    Updated %__N2% pom.xml files
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
