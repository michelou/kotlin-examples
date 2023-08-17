ifndef GIT_HOME
$(error Variable GIT_HOME is not set)
endif
ifndef JAVA_HOME
$(error Variable JAVA_HOME is not set)
endif
ifndef KOTLIN_HOME
$(error Variable KOTLIN_HOME is not set)
endif
ifndef KOTLIN_NATIVE_HOME
$(error Variable KOTLIN_NATIVE_HOME is not set)
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
## native
EXT_NATIVE     = .exe
KOTLINC_NATIVE = $(subst \,/,$(KOTLIN_NATIVE_HOME))/bin/kotlinc-native.bat
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
## native
EXT_NATIVE     = 
KOTLINC_NATIVE = $(KOTLIN_NATIVE_HOME)/bin/kotlinc-native
endif

LANGUAGE_VERSION = 1.5

JUNIT_VERSION   = 4.13.2
KOTLIN_VERSION  = 1.8.20
KOTLINX_VERSION = 1.6.4

KOTLIN_STDLIB_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib" -name kotlin-stdlib-$(KOTLIN_VERSION).jar)
KOTLIN_JDK8_JAR   = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib-jdk8" -name kotlin-stdlib-jdk8-$(KOTLIN_VERSION).jar)
KOTLINX_COROUTINES_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-coroutines-core" -name kotlinx-coroutines-core-$(KOTLINX_VERSION).jar)
HAMCREST_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-2.2.jar)
JUNIT_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/junit/junit" -name junit-$(JUNIT_VERSION).jar)

KOTLIN_DOKKA_VERSION=1.7.20

DOKKA_ANALYSIS_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name dokka-analysis-$(KOTLIN_DOKKA_VERSION).jar)
DOKKA_BASE_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name dokka-base-$(KOTLIN_DOKKA_VERSION).jar)
DOKKA_COMPILER_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name kotlin-analysis-compiler-$(KOTLIN_DOKKA_VERSION).jar)
DOKKA_INTELLIJ_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name kotlin-analysis-intellij-$(KOTLIN_DOKKA_VERSION).jar)
DOKKA_PLUGIN_JAR   = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name dokka-gradle-plugin-$(KOTLIN_DOKKA_VERSION).jar)
KOTLINX_HTML_JAR   = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx" -name kotlinx-html-jvm-0.9.1.jar)
MARKDOWN_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains" -name markdown-0.3.5.jar)

ANNOTATIONS_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains" -name annotations-23.1.0.jar)
##EXTENSIONS_JAR     = $(shell $(FIND) "$(DOKKA_HOME)/lib" -name extensions-7.0.3.jar)
##INTELLIJ_CORE_JAR  = $(shell $(FIND) "$(DOKKA_HOME)/lib" -name intellij-core-27.1.3.jar)
##OPENAPI_JAR        = $(shell $(FIND) "$(DOKKA_HOME)/lib" -name openapi-7.0.3.jar)
