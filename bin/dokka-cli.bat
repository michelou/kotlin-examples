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

set "_BOOT_CPATH=%_LOCAL_REPO%\org\jetbrains\kotlin\kotlin-stdlib\%_DOKKA_VERSION%\kotlin-stdlib-%_DOKKA_VERSION%.jar;%_LOCAL_REPO%\org\jetbrains\kotlin\kotlin-reflect\%_DOKKA_VERSION%\kotlin-reflect-%_DOKKA_VERSION%.jar;%_LOCAL_REPO%\org\jetbrains\dokka\dokka-base\%_DOKKA_VERSION%\dokka-base-%_DOKKA_VERSION%.jar;%_LOCAL_REPO%\org\jetbrains\dokka\dokka-core\%_DOKKA_VERSION%\dokka-core-%_DOKKA_VERSION%.jar;%_LOCAL_REPO%\com\intellij\openapi\7.0.3\openapi-7.0.3.jar;"

@rem set "_PLUGINS_CPATH=%_LOCAL_REPO%\org\jetbrains\dokka\dokka-gradle-plugin\%_DOKKA_VERSION%\dokka-gradle-plugin-%_DOKKA_VERSION%.jar"
set "_PLUGINS_CPATH=."

set "_MAIN_JAR_FILE=%_LOCAL_REPO%\org\jetbrains\dokka\dokka-cli\%_DOKKA_VERSION%\dokka-cli-%_DOKKA_VERSION%.jar"
set _MAIN_ARGS=-pluginsClasspath "%_PLUGINS_CPATH%" %*
if %_DEBUG%==1 set _MAIN_ARGS=-loggingLevel DEBUG %_MAIN_ARGS%

@rem #########################################################################
@rem ## Main

if %_DEBUG%==1 echo "%_JAVA_CMD%" -Xbootclasspath/a:"%_BOOT_CPATH%" -jar "%_MAIN_JAR_FILE%" %_MAIN_ARGS%
call "%_JAVA_CMD%" -Xbootclasspath/a:"%_BOOT_CPATH%" -jar "%_MAIN_JAR_FILE%" %_MAIN_ARGS%
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
