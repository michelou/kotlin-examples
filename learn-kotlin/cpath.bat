@echo off
setlocal enabledelayedexpansion

@rem output parameter: _CPATH, _DOKKA_JAR

if not defined _DEBUG set _DEBUG=%~1
if not defined _DEBUG set _DEBUG=0
set _VERBOSE=0

if not defined _MVN_CMD set "_MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"
if %_DEBUG%==1 echo [%~n0] "_MVN_CMD=%_MVN_CMD%" 1>&2

if %_DEBUG%==1 ( set _MVN_OPTS=
) else ( set _MVN_OPTS=--quiet
)
@rem use newer PowerShell version if available
where /q pwsh.exe
if %ERRORLEVEL%==0 ( set _PWSH_CMD=pwsh.exe
) else ( set _PWSH_CMD=powershell.exe
)
set "_LOCAL_REPO=%USERPROFILE%\.m2\repository"

set "_TEMP_DIR=%TEMP%\lib"
if not exist "%_TEMP_DIR%" mkdir "%_TEMP_DIR%"
if %_DEBUG%==1 echo [%~n0] "_TEMP_DIR=%_TEMP_DIR%" 1>&2

@rem library versions
set __KOTLIN_VERSION=2.1.0
set __KOTLINX_VERSION=1.9.0

@rem #########################################################################
@rem ## Libraries to be added to _LIBS_CPATH1

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/junit/junit
call :add_maven_jar "junit" "junit" "4.13.2"

@rem https://mvnrepository.com/artifact/org.hamcrest/hamcrest
call :add_maven_jar "org.hamcrest" "hamcrest" "2.2"

set "_LIBS_CPATH1=%_LIBS_CPATH%"

@rem #########################################################################
@rem ## Libraries to be added to _LIBS_CPATH2

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-core
call :add_maven_jar "org.jetbrains.kotlinx" "kotlinx-coroutines-core" "%__KOTLINX_VERSION%"

@rem https://dl.bintray.com/kotlin/kotlinx/org/jetbrains/kotlinx/kotlinx-cli-jvm/
@rem call :add_bintray_jar "org.jetbrains.kotlinx" "kotlinx-cli-jvm" "0.3.2"

@rem https://mvnrepository.com/artifact/org.jetbrains.kotlinx/kotlinx-html-jvm
call :add_maven_jar "org.jetbrains.kotlinx" "kotlinx-html-jvm" "0.11.0"

set __DOKKA_VERSION=1.9.20
set __DOKKA_ANALYSIS_VERSION=1.8.20

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/kotlin-analysis-compiler
call :add_maven_jar "org.jetbrains.dokka" "kotlin-analysis-compiler" "%__DOKKA_ANALYSIS_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/kotlin-analysis-intellij
call :add_maven_jar "org.jetbrains.dokka" "kotlin-analysis-intellij" "%__DOKKA_ANALYSIS_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-analysis
call :add_maven_jar "org.jetbrains.dokka" "dokka-analysis" "%__DOKKA_ANALYSIS_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-base
call :add_maven_jar "org.jetbrains.dokka" "dokka-base" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-cli
call :add_maven_jar "org.jetbrains.dokka" "dokka-cli" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-core
@rem call :add_maven_jar "org.jetbrains.dokka" "dokka-core" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-gradle-plugin
call :add_maven_jar "org.jetbrains.dokka" "dokka-gradle-plugin" "%__DOKKA_VERSION%"

set "_LIBS_CPATH2=%_LIBS_CPATH%"

@rem #########################################################################
@rem ## Libraries to be added to _LIBS_CPATH3

set _LIBS_CPATH=

@rem https://dl.bintray.com/kotlin/dokka/org/jetbrains/dokka/dokka-cli/
call :add_maven_jar "org.jetbrains.dokka" "dokka-cli" "%__DOKKA_VERSION%"

set "_LIBS_CPATH3=%_LIBS_CPATH%"

goto end

@rem #########################################################################
@rem ## Subroutines

@rem input parameters: %1=group ID, %2=artifact ID, %3=version
@rem global variable: _LIBS_CPATH
:add_maven_jar
call :add_jar "https://repo1.maven.org/maven2" %1 %2 %3
goto :eof

@rem global variable: _LIBS_CPATH
:add_jar
set __REPOSITORY=%~1
set __GROUP_ID=%~2
set __ARTIFACT_ID=%~3
set __VERSION=%~4

set __JAR_NAME=%__ARTIFACT_ID%-%__VERSION%.jar
set __JAR_PATH=%__GROUP_ID:.=\%\%__ARTIFACT_ID:/=\%
set __JAR_FILE=
for /f "usebackq delims=" %%f in (`where /r "%_LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
    set "__JAR_FILE=%%f"
)
if not exist "%__JAR_FILE%" (
    set __JAR_URL=%__REPOSITORY%/%__GROUP_ID:.=/%/%__ARTIFACT_ID%/%__VERSION%/%__JAR_NAME%
    set "__JAR_FILE=%_TEMP_DIR%\%__JAR_NAME%"
    if not exist "!__JAR_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_PWSH_CMD%" -c "Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download file "%__JAR_NAME%" to directory "!_TEMP_DIR:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
        )
        call "%_PWSH_CMD%" -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'"
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to download file "%__JAR_NAME%" 1>&2
            set _EXITCODE=1
            goto :eof
        )
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar 1>&2
        ) else if %_VERBOSE%==1 ( echo Install Maven artifact into directory "!_LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!\%__SCALA_XML_PATH%" 1>&2
        )
        @rem see https://stackoverflow.com/questions/16727941/how-do-i-execute-cmd-commands-through-a-batch-file
        call "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to install Maven artifact into directory "!_LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!" ^(error:!ERRORLEVEL!^) 1>&2
        )
        for /f "usebackq delims=" %%f in (`where /r "%_LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
            set "__JAR_FILE=%%f"
        )
    )
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__JAR_FILE%;"
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    set "_CPATH=%_LIBS_CPATH1%"
    set "_DOKKA_CPATH=%_LIBS_CPATH2%"
    set "_DOKKA_JAR=%_LIBS_CPATH3:~0,-1%"
)
