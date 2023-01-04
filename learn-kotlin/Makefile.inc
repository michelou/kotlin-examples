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
RM         = $(subst \,/,$(GIT_HOME))/usr/bin/rm.exe
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
RM         = rm
TOUCH      = touch
endif

LANGUAGE_VERSION = 1.6

DOKKA_VERSION=1.7.20
JUNIT_VERSION   = 4.13.2
KOTLIN_VERSION  = 1.8.0
KOTLINX_VERSION = 1.6.4

DOKKA_ANALYSIS_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-analysis" -name dokka-analysis-$(DOKKA_VERSION).jar)
DOKKA_BASE_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-base" -name dokka-base-$(DOKKA_VERSION).jar)
DOKKA_CLI_JAR          = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-cli" -name dokka-cli-$(DOKKA_VERSION).jar)
DOKKA_PLUGIN_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-gradle-plugin" -name dokka-gradle-plugin-$(DOKKA_VERSION).jar)
KOTLIN_ANALYSIS_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/kotlin-analysis-compiler" -name kotlin-analysis-compiler-$(DOKKA_VERSION).jar)
KOTLIN_INTELLIJ_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/kotlin-analysis-intellij" -name kotlin-analysis-intellij-$(DOKKA_VERSION).jar)

KOTLIN_COMPILER_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-compiler" -name kotlin-compiler-$(KOTLIN_VERSION).jar)
KOTLIN_STDLIB_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib" -name kotlin-stdlib-$(KOTLIN_VERSION).jar)
KOTLIN_JDK8_JAR        = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib-jdk8" -name kotlin-stdlib-jdk8-$(KOTLIN_VERSION).jar)
KOTLINX_COROUTINES_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-coroutines-core" -name kotlinx-coroutines-core-$(KOTLINX_VERSION).jar)
KOTLINX_HTML_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-html-jvm" -name kotlinx-html-jvm-0.8.1.jar)
HAMCREST_JAR           = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-2.2.jar)
JUNIT_JAR              = $(shell $(FIND) "$(LOCAL_REPO)/junit/junit" -name junit-$(JUNIT_VERSION).jar)

DOKKA_CPATH = $(KOTLIN_COMPILER_JAR)$(PSEP)$(KOTLINX_COROUTINES_JAR)$(PSEP)$(KOTLINX_HTML_JAR)$(PSEP)$(KOTLIN_INTELLIJ_JAR)$(PSEP)$(DOKKA_ANALYSIS_JAR)$(PSEP)$(DOKKA_BASE_JAR)$(PSEP)$(DOKKA_PLUGIN_JAR)
