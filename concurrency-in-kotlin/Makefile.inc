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
MVN        = $(subst \,/,$(MAVEN_HOME))/bin/mvn.cmd
LOCAL_REPO = $(subst \,/,$(USERPROFILE))/.m2/repository
PSEP       = ;
## $(MSYS_HOME)\usr\bin\{cp.exe, make.exe, wget.exe}
CP         = /usr/bin/cp.exe
ECHO       = /usr/bin/echo.exe
FIND       = /usr/bin/find.exe
MKDIR      = /usr/bin/mkdir.exe
RM         = /usr/bin/rm.exe
TOUCH      = /usr/bin/touch.exe
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
MVN        = mvn
RM         = rm
TOUCH      = touch
## native
EXT_NATIVE     = 
KOTLINC_NATIVE = $(KOTLIN_NATIVE_HOME)/bin/kotlinc-native
endif

LANGUAGE_VERSION = 1.6

JUNIT_VERSION   = 4.13.2
KOTLIN_VERSION  = 1.9.22
KOTLINX_VERSION = 1.7.3

KOTLIN_STDLIB_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib" -name kotlin-stdlib-$(KOTLIN_VERSION).jar)
KOTLIN_JDK8_JAR   = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib-jdk8" -name kotlin-stdlib-jdk8-$(KOTLIN_VERSION).jar)
KOTLINX_COROUTINES_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-coroutines-core" -name kotlinx-coroutines-core-$(KOTLINX_VERSION).jar)
KOTLINX_COROUT_JVM_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-coroutines-core-jvm" -name kotlinx-coroutines-core-jvm-$(KOTLINX_VERSION).jar)
HAMCREST_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-2.2.jar)
JUNIT_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/junit/junit" -name junit-$(JUNIT_VERSION).jar)

KOTLIN_VERSION=1.8.20

DOKKA_ANALYSIS_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name dokka-analysis-$(KOTLIN_VERSION).jar)
DOKKA_BASE_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name dokka-base-$(KOTLIN_VERSION).jar)
DOKKA_COMPILER_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name kotlin-analysis-compiler-$(KOTLIN_VERSION).jar)
DOKKA_INTELLIJ_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name kotlin-analysis-intellij-$(KOTLIN_VERSION).jar)
DOKKA_PLUGIN_JAR   = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka" -name dokka-gradle-plugin-$(KOTLIN_VERSION).jar)
KOTLINX_HTML_JAR   = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx" -name kotlinx-html-jvm-0.9.1.jar)
MARKDOWN_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains" -name markdown-0.3.5.jar)

ANNOTATIONS_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains" -name annotations-23.1.0.jar)
##EXTENSIONS_JAR     = $(shell $(FIND) "$(DOKKA_HOME)/lib" -name extensions-7.0.3.jar)
##INTELLIJ_CORE_JAR  = $(shell $(FIND) "$(DOKKA_HOME)/lib" -name intellij-core-27.1.3.jar)
##OPENAPI_JAR        = $(shell $(FIND) "$(DOKKA_HOME)/lib" -name openapi-7.0.3.jar)

deps:
	$(eval MVN_OPTS := -quiet)
	$(eval REMOTE_REPO := https://repo1.maven.org/maven2)
	$(eval WGET_OPTS := --user-agent="Mozilla/5.0 (Windows NT 6.3; WOW64; rv:40.0)" --no-check-certificate --directory-prefix="$(TMP)")
	@$(ECHO) "## Check Maven dependencies on $(REMOTE_REPO)"
ifeq (,$(wildcard $(KOTLIN_STDLIB_JAR)))
	$(eval GROUP_ID := org.jetbrains.kotlin)
	$(eval ARTIFACT_ID := kotlin-stdlib)
	$(eval VERSION := $(KOTLIN_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval KOTLIN_STDLIB_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(KOTLINX_COROUTINES_JAR)))
	$(eval GROUP_ID := org.jetbrains.kotlinx)
	$(eval ARTIFACT_ID := kotlinx-coroutines-core)
	$(eval VERSION := $(KOTLIN_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval KOTLINX_COROUTINES_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(DOKKA_ANALYSIS_JAR)))
	$(eval GROUP_ID := org.jetbrains.dokka)
	$(eval ARTIFACT_ID := dokka-analysis)
	$(eval VERSION := 1.8.20)
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval DOKKA_ANALYSIS_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(DOKKA_BASE_JAR)))
	$(eval GROUP_ID := org.jetbrains.dokka)
	$(eval ARTIFACT_ID := dokka-base)
	$(eval VERSION := 1.9.10)
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval DOKKA_BASE_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
