@echo off

set _DEBUG=1

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

set "_JAVA_CMD=%JAVA_HOME%\bin\java.exe"

set _DOKKA_VERSION=1.7.20

set "_LOCAL_REPO=%USERPROFILE%\.m2\repository"

@rem %_LOCAL_REPO%\org\jetbrains\kotlin\kotlin-stdlib\%_DOKKA_VERSION%\kotlin-stdlib-%_DOKKA_VERSION%.jar
@rem %_LOCAL_REPO%\org\jetbrains\kotlin\kotlin-stdlib-jdk8\%_DOKKA_VERSION%\kotlin-stdlib-jdk8-%_DOKKA_VERSION%.jar
@rem %_LOCAL_REPO%\org\jetbrains\kotlin\kotlin-reflect\%_DOKKA_VERSION%\kotlin-reflect-%_DOKKA_VERSION%.jar
@rem %_LOCAL_REPO%\org\jetbrains\dokka\dokka-base\%_DOKKA_VERSION%\dokka-base-%_DOKKA_VERSION%.jar
@rem %_LOCAL_REPO%\org\jetbrains\dokka\dokka-core\%_DOKKA_VERSION%\dokka-core-%_DOKKA_VERSION%.jar
@rem %_LOCAL_REPO%\org\jetbrains\dokka\dokka-analysis\%_DOKKA_VERSION%\dokka-analysis-%_DOKKA_VERSION%.jar
@rem %_LOCAL_REPO%\com\intellij\openapi\7.0.3\openapi-7.0.3.jar

@rem set "_BOOT_CPATH=%_LOCAL_REPO%\org\jetbrains\kotlin\kotlin-stdlib\%_DOKKA_VERSION%\kotlin-stdlib-%_DOKKA_VERSION%.jar;%_LOCAL_REPO%\org\jetbrains\kotlin\kotlin-reflect\%_DOKKA_VERSION%\kotlin-reflect-%_DOKKA_VERSION%.jar;%_LOCAL_REPO%\org\jetbrains\dokka\dokka-base\%_DOKKA_VERSION%\dokka-base-%_DOKKA_VERSION%.jar;%_LOCAL_REPO%\org\jetbrains\dokka\dokka-core\%_DOKKA_VERSION%\dokka-core-%_DOKKA_VERSION%.jar;%_LOCAL_REPO%\com\intellij\openapi\7.0.3\openapi-7.0.3.jar;C:\Users\michelou\.m2\repository\org\jetbrains\kotlinx\kotlinx-coroutines-core-jvm\1.6.4\kotlinx-coroutines-core-jvm-1.6.4.jar"

set "_MAIN_JAR_FILE=%_LOCAL_REPO%\org\jetbrains\dokka\dokka-cli\%_DOKKA_VERSION%\dokka-cli-%_DOKKA_VERSION%.jar"

@rem set "_PLUGINS_CPATH=%_LOCAL_REPO%\org\jetbrains\dokka\dokka-gradle-plugin\%_DOKKA_VERSION%\dokka-gradle-plugin-%_DOKKA_VERSION%.jar"
set "_PLUGINS_CPATH=%TEMP%\lib\kotlinx-coroutines-core-1.6.4.jar;%_LOCAL_REPO%\org\jetbrains\kotlinx\kotlinx-cli-jvm\0.3.5\kotlinx-cli-jvm-0.3.5.jar;%TEMP%\lib\kotlinx-html-jvm-0.8.0.jar;%TEMP%\lib\kotlin-analysis-compiler-%_DOKKA_VERSION%.jar;C:\Users\michelou\AppData\Local\Temp\lib\dokka-analysis-%_DOKKA_VERSION%.jar;%TEMP%\lib\dokka-base-%_DOKKA_VERSION%.jar;C:\Users\michelou\.m2\repository\org\jetbrains\dokka\dokka-core\%_DOKKA_VERSION%\dokka-core-%_DOKKA_VERSION%.jar"

@rem https://discuss.kotlinlang.org/t/problems-running-dokka-cli-1-4-0-rc-jar-from-the-command-line/18855/24?page=2
@rem kotlinx-coroutines-core-1.3.9.jar
@rem kotlinx-cli-jvm-0.3.jar
@rem kotlinx-html-jvm-0.7.2.jar
@rem kotlin-analysis-compiler-1.4.10.jar
@rem dokka-analysis-1.4.10.jar
@rem dokka-base-1.4.10.jar
@rem dokka-core-1.4.10.jar

@rem #########################################################################
@rem ## Main

set __JAVA_OPTS=-jar "%_MAIN_JAR_FILE%" -pluginsClasspath "%_PLUGINS_CPATH%"
set __DOKKA_ARGS=%*
if %_DEBUG%==1 set __DOKKA_ARGS=-loggingLevel DEBUG %__DOKKA_ARGS%

if %_DEBUG%==1 echo "%_JAVA_CMD%" %__JAVA_OPTS% %__DOKKA_ARGS%
call "%_JAVA_CMD%" %__JAVA_OPTS% %__DOKKA_ARGS%
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
)

@rem #########################################################################
@rem ## Cleanups

exit /b %_EXITCODE%

@rem #########################################################################
@rem ## Notes

@rem where /r "%USERPROFILE%\.m2\repository\org\jetbrains" *core*.jar

@rem Exception in thread "main" java.lang.NullPointerException: Unit::class.java.classLoader must not be null
