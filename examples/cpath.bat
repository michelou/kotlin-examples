@echo off
setlocal enabledelayedexpansion

@rem output parameter: _CPATH, _DOKKA_CLI_JAR

if not defined _DEBUG set _DEBUG=%~1
if not defined _DEBUG set _DEBUG=0
set _VERBOSE=0

if not defined _MVN_CMD set "_MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"
if %_DEBUG%==1 echo [%~n0] "_MVN_CMD=%_MVN_CMD%"

if %_DEBUG%==1 ( set _MVN_OPTS=
) else ( set _MVN_OPTS=--quiet
)
set _CENTRAL_REPO=https://repo1.maven.org/maven2
set __DATANUCLEUS_REPO=http://www.datanucleus.org/downloads/maven2
set "__LOCAL_REPO=%USERPROFILE%\.m2\repository"

set "__TEMP_DIR=%TEMP%\lib"
if not exist "%__TEMP_DIR%" mkdir "%__TEMP_DIR%"
if %_DEBUG%==1 echo [%~n0] "__TEMP_DIR=%__TEMP_DIR%"

@rem library versions
set __DOKKA_VERSION=1.8.10
set __KOTLIN_VERSION=1.8.20

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/junit/junit
call :add_maven_jar "junit" "junit" "4.13.2"

@rem https://mvnrepository.com/artifact/org.hamcrest/hamcrest
call :add_maven_jar "org.hamcrest" "hamcrest" "2.2"

@rem https://mvnrepository.com/artifact/org.jetbrains.kotlin/kotlin-stdlib-jdk8
call :add_maven_jar "org.jetbrains.kotlin" "kotlin-stdlib-jdk8" "%__KOTLIN_VERSION%"

set "_LIBS_CPATH1=%_LIBS_CPATH%"

set _LIBS_CPATH=

@rem https://kotlin.github.io/dokka/1.7.0/user_guide/cli/usage/
@rem https://discuss.kotlinlang.org/t/problems-running-dokka-cli-1-7-10-jar-from-the-command-line/25439

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-base
call :add_maven_jar "org.jetbrains.dokka" "dokka-base" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-analysis
call :add_maven_jar "org.jetbrains.dokka" "dokka-analysis" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/kotlin-analysis-intellij
call :add_maven_jar "org.jetbrains.dokka" "kotlin-analysis-intellij" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/kotlin-analysis-compiler
call :add_maven_jar "org.jetbrains.dokka" "kotlin-analysis-compiler" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.kotlinx/kotlinx-html-jvm
call :add_maven_jar "org.jetbrains.kotlinx" "kotlinx-html-jvm" "0.8.0"

@rem https://mvnrepository.com/artifact/org.freemarker/freemarker
call :add_maven_jar "org.freemarker" "freemarker" "2.3.32"

set "_LIBS_CPATH2=%_LIBS_CPATH%"

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-cli
call :add_maven_jar "org.jetbrains.dokka" "dokka-cli" "%__DOKKA_VERSION%"

set "_LIBS_CPATH3=%_LIBS_CPATH%"

goto end

@rem #########################################################################
@rem ## Subroutines

@rem input parameters: %1=group ID, %2=artifact ID, %3=version
@rem global variable: _LIBS_CPATH
:add_maven_jar
if %_DEBUG%==1 echo [%~n0] call :add_jar "%_CENTRAL_REPO%" %1 %2 %3 1>&2
call :add_jar "%_CENTRAL_REPO%" %1 %2 %3
goto :eof

@rem e.g. http://www.datanucleus.org/downloads/maven2/com/intellij/util/IC-103.255/util-IC-103.255.jar
:add_datanucleaus_jar
if %_DEBUG%==1 echo [%~n0] call :add_jar "%__DATANUCLEUS_REPO%" %1 %2 %3 1>&2
call :add_jar "%__DATANUCLEUS_REPO%" %1 %2 %3
goto :eof

@rem input parameters: %1=group ID, %2=artifact ID, %3=version
@rem global variable: _LIBS_CPATH
:add_jar
set __REPOSITORY=%~1
set __GROUP_ID=%~2
set __ARTIFACT_ID=%~3
set __VERSION=%~4

set __JAR_NAME=%__ARTIFACT_ID%-%__VERSION%.jar
set __JAR_PATH=%__GROUP_ID:.=\%\%__ARTIFACT_ID:/=\%
set __JAR_FILE=
for /f "usebackq delims=" %%f in (`where /r "%__LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
    set "__JAR_FILE=%%f"
)
if not exist "%__JAR_FILE%" (
    set __JAR_URL=%__REPOSITORY%/%__GROUP_ID:.=/%/%__ARTIFACT_ID%/%__VERSION%/%__JAR_NAME%
    set "__JAR_FILE=%__TEMP_DIR%\%__JAR_NAME%"
    if not exist "!__JAR_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -c "Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download file %__JAR_NAME% to directory "!__TEMP_DIR:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
        )
        powershell -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'"
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to download file "%__JAR_NAME%" 1>&2
            set _EXITCODE=1
            goto :eof
        )
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar 1>&2
        ) else if %_VERBOSE%==1 ( echo Install Maven artifact into directory "!__LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!\%__SCALA_XML_PATH%" 1>&2
        )
        @rem see https://stackoverflow.com/questions/16727941/how-do-i-execute-cmd-commands-through-a-batch-file
        call "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to install Maven artifact into directory "!__LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!" ^(error:!ERRORLEVEL!^) 1>&2
        )
        for /f "usebackq delims=" %%f in (`where /r "%__LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
            set "__JAR_FILE=%%f"
        )
    )
    if %_DEBUG%==1 echo [%~n0] __JAR_FILE=!__JAR_FILE!
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__JAR_FILE%;"
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    set "_CPATH=%_LIBS_CPATH1%"
    set "_DOKKA_CPATH=%_LIBS_CPATH2%"
    set "_DOKKA_CLI_JAR=%_LIBS_CPATH3:~0,-1%"
)