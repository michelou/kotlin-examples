@echo off
setlocal enabledelayedexpansion

@rem output parameter: _CPATH, _DOKKA_JAR

if not defined _DEBUG set _DEBUG=%~1
if not defined _MVN_CMD set _MVN_CMD=mvn.cmd

if %_DEBUG%==1 ( set _MVN_OPTS=
) else ( set _MVN_OPTS=--quiet
)
set "__LOCAL_REPO=%USERPROFILE%\.m2\repository"

set "__TEMP_DIR=%TEMP%\lib"
if not exist "%__TEMP_DIR%" mkdir "%__TEMP_DIR%"

@rem library versions
set __DOKKA_VERSION=1.5.0
set __KOTLIN_VERSION=1.5.21
set __KOTLINX_VERSION=1.5.1

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/junit/junit
call :add_maven_jar "junit" "junit" "4.13.2"

@rem https://mvnrepository.com/artifact/org.hamcrest/hamcrest
call :add_maven_jar "org.hamcrest" "hamcrest" "2.2"

@rem https://mvnrepository.com/artifact/org.jetbrains.kotlin/kotlin-stdlib-jdk8
call :add_maven_jar "org.jetbrains.kotlin" "kotlin-stdlib-jdk8" "%__KOTLIN_VERSION%"

set "_LIBS_CPATH1=%_LIBS_CPATH%"

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-core
call :add_maven_jar "org.jetbrains.kotlinx" "kotlinx-coroutines-core" "%__KOTLINX_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.kotlinx/kotlinx-html-jvm
call :add_maven_jar "org.jetbrains.kotlinx" "kotlinx-html-jvm" "0.7.3"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/kotlin-analysis-compiler
call :add_maven_jar "org.jetbrains.dokka" "kotlin-analysis-compiler" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/kotlin-analysis-intellij
call :add_maven_jar "org.jetbrains.dokka" "kotlin-analysis-intellij" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-analysis
call :add_maven_jar "org.jetbrains.dokka" "dokka-analysis" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-base
call :add_maven_jar "org.jetbrains.dokka" "dokka-base" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-core
@rem call :add_maven_jar "org.jetbrains.dokka" "dokka-core" "%__DOKKA_VERSION%"

@rem https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-gradle-plugin
call :add_maven_jar "org.jetbrains.dokka" "dokka-gradle-plugin" "%__DOKKA_VERSION%"

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
for /f %%f in ('where /r "%__LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL') do (
    set __JAR_FILE=%%f
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
            echo %_ERROR_LABEL% Failed to download file %__JAR_NAME% 1>&2
            set _EXITCODE=1
            goto :eof
        )
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MVN_CMD%" install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar 1>&2
        ) else if %_VERBOSE%==1 ( echo Install Maven archive into directory "!__LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!\%__SCALA_XML_PATH%" 1>&2
        )
        call "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar
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