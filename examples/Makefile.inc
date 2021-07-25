ifndef GIT_HOME
$(error Variable GIT_HOME is not set)
endif
ifndef JAVA_HOME
$(error Variable JAVA_HOME is not set)
endif
ifndef KOTLIN_HOME
$(error Variable KOTLIN_HOME is not set)
endif

ifeq ($(OS),Windows_NT)
JAR        = $(subst \,/,$(JAVA_HOME))/bin/jar.exe
JAVA       = $(subst \,/,$(JAVA_HOME))/bin/java.exe
JAVAC      = $(subst \,/,$(JAVA_HOME))/bin/javac.exe
KOTLIN     = $(subst \,/,$(KOTLIN_HOME))/bin/kotlin.bat
KOTLINC    = $(subst \,/,$(KOTLIN_HOME))/bin/kotlinc.bat
LOCAL_REPO = $(subst \,/,$(USERPROFILE))/.m2/repository
PSEP       = ;
ECHO       = $(subst \,/,$(GIT_HOME))/usr/bin/echo.exe
FIND       = $(subst \,/,$(GIT_HOME))/usr/bin/find.exe
MKDIR      = $(subst \,/,$(GIT_HOME))/usr/bin/mkdir.exe
TOUCH      = $(subst \,/,$(GIT_HOME))/usr/bin/touch.exe
else
JAR        = $(JAVA_HOME)/bin/jar
JAVA       = $(JAVA_HOME)/bin/java
JAVAC      = $(JAVA_HOME)/bin/javac
KOTLIN     = $(KOTLIN_HOME)/bin/kotlin
KOTLINC    = $(KOTLIN_HOME)/bin/kotlinc
LOCAL_REPO = $(HOME)/.m2/repository
PSEP       = :
ECHO       = echo
FIND       = find
MKDIR      = mkdir
TOUCH      = touch
endif

LANGUAGE_VERSION = 1.5

DOKKA_ANALYSIS_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-analysis" -name dokka-analysis-1.5.0.jar)
DOKKA_BASE_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-base" -name dokka-base-1.5.0.jar)
DOKKA_CLI_JAR          = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-cli" -name dokka-cli-1.5.0.jar)
DOKKA_PLUGIN_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-gradle-plugin" -name dokka-gradle-plugin-1.5.0.jar)
KOTLIN_ANALYSIS_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/kotlin-analysis-compiler" -name kotlin-analysis-compiler-1.5.0.jar)
KOTLIN_COMPILER_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-compiler" -name kotlin-compiler-1.5.21.jar)
KOTLIN_INTELLIJ_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/kotlin-analysis-intellij" -name kotlin-analysis-intellij-1.5.0.jar)
KOTLIN_STDLIB_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib" -name kotlin-stdlib-1.5.21.jar)
KOTLIN_JDK8_JAR        = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib-jdk8" -name kotlin-stdlib-jdk8-1.5.21.jar)
KOTLINX_COROUTINES_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-coroutines-core" -name kotlinx-coroutines-core-1.5.1.jar)
KOTLINX_HTML_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-html-jvm" -name kotlinx-html-jvm-0.7.3.jar)
HAMCREST_JAR           = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-2.2.jar)
JUNIT_JAR              = $(shell $(FIND) "$(LOCAL_REPO)/junit/junit" -name junit-4.13.2.jar)

DOKKA_CPATH = $(KOTLIN_COMPILER_JAR)$(PSEP)$(KOTLINX_COROUTINES_JAR)$(PSEP)$(KOTLINX_HTML_JAR)$(PSEP)$(KOTLIN_INTELLIJ_JAR)$(PSEP)$(DOKKA_ANALYSIS_JAR)$(PSEP)$(DOKKA_BASE_JAR)$(PSEP)$(DOKKA_PLUGIN_JAR)
