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

LANGUAGE_VERSION = 1.8
JVM_TARGET=11

## https://mvnrepository.com/artifact/org.jetbrains.dokka/dokka-cli
DOKKA_VERSION=1.9.20
## https://mvnrepository.com/artifact/org.jetbrains.dokka/kotlin-analysis-compiler
DOKKA_ANALYSIS_VERSION=1.8.20
## https://mvnrepository.com/artifact/junit/junit
JUNIT_VERSION   = 4.13.2
## https://mvnrepository.com/artifact/org.jetbrains.kotlin/kotlin-compiler
KOTLIN_VERSION  = 2.0.0
## https://mvnrepository.com/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-core
KOTLINX_VERSION = 1.9.0-RC

DOKKA_ANALYSIS_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-analysis" -type f -name dokka-analysis-$(DOKKA_ANALYSIS_VERSION).jar)
DOKKA_BASE_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-base" -name dokka-base-$(DOKKA_VERSION).jar)
DOKKA_CLI_JAR          = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-cli" -name dokka-cli-$(DOKKA_VERSION).jar)
DOKKA_PLUGIN_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/dokka-gradle-plugin" -name dokka-gradle-plugin-$(DOKKA_VERSION).jar)
KOTLIN_ANALYSIS_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/kotlin-analysis-compiler" -name kotlin-analysis-compiler-$(DOKKA_ANALYSIS_VERSION).jar)
KOTLIN_INTELLIJ_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/dokka/kotlin-analysis-intellij" -name kotlin-analysis-intellij-$(DOKKA_ANALYSIS_VERSION).jar)

KOTLIN_COMPILER_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-compiler" -name kotlin-compiler-$(KOTLIN_VERSION).jar)
KOTLIN_STDLIB_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib" -name kotlin-stdlib-$(KOTLIN_VERSION).jar)
KOTLIN_JDK8_JAR        = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlin/kotlin-stdlib-jdk8" -name kotlin-stdlib-jdk8-$(KOTLIN_VERSION).jar)
KOTLINX_COROUTINES_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-coroutines-core" -name kotlinx-coroutines-core-$(KOTLINX_VERSION).jar)
KOTLINX_HTML_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/jetbrains/kotlinx/kotlinx-html-jvm" -name kotlinx-html-0.9.1.jar)
HAMCREST_JAR           = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-2.2.jar)
JUNIT_JAR              = $(shell $(FIND) "$(LOCAL_REPO)/junit/junit" -name junit-$(JUNIT_VERSION).jar)

DOKKA_CPATH = $(KOTLIN_COMPILER_JAR)$(PSEP)$(KOTLINX_COROUTINES_JAR)$(PSEP)$(KOTLINX_HTML_JAR)$(PSEP)$(KOTLIN_INTELLIJ_JAR)$(PSEP)$(DOKKA_ANALYSIS_JAR)$(PSEP)$(DOKKA_BASE_JAR)$(PSEP)$(DOKKA_PLUGIN_JAR)


deps:
	$(eval MVN_OPTS := -quiet)
	$(eval REMOTE_REPO := https://repo1.maven.org/maven2)
	$(eval WGET_OPTS := --user-agent="Mozilla/5.0 (Windows NT 6.3; WOW64; rv:40.0)" --no-check-certificate --directory-prefix="$(TMP)")
	@$(ECHO) "## Check Maven dependencies on $(REMOTE_REPO)"
ifeq (,$(wildcard $(DOKKA_ANALYSIS_JAR)))
	$(eval GROUP_ID := org.jetbrains.dokka)
	$(eval ARTIFACT_ID := dokka-analysis)
	$(eval VERSION := $(DOKKA_ANALYSIS_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval DOKKA_ANALYSIS_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(DOKKA_BASE_JAR)))
	$(eval GROUP_ID := org.jetbrains.dokka)
	$(eval ARTIFACT_ID := dokka-base)
	$(eval VERSION := $(DOKKA_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval DOKKA_BASE_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(DOKKA_CLI_JAR)))
	$(eval GROUP_ID := org.jetbrains.dokka)
	$(eval ARTIFACT_ID := dokka-cli)
	$(eval VERSION := $(DOKKA_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval DOKKA_CLI_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(DOKKA_PLUGIN_JAR)))
	$(eval GROUP_ID := org.jetbrains.dokka)
	$(eval ARTIFACT_ID := dokka-gradle-plugin)
	$(eval VERSION := $(DOKKA_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval DOKKA_PLUGIN_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(KOTLIN_ANALYSIS_JAR)))
	$(eval GROUP_ID := org.jetbrains.dokka)
	$(eval ARTIFACT_ID := kotlin-analysis-compiler)
	$(eval VERSION := $(DOKKA_ANALYSIS_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval KOTLIN_ANALYSIS_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(HAMCREST_JAR)))
	$(eval GROUP_ID := org.hamcrest)
	$(eval ARTIFACT_ID := hamcrest)
	$(eval VERSION := 2.2)
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval HAMCREST_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(JUNIT_JAR)))
	$(eval GROUP_ID := junit)
	$(eval ARTIFACT_ID := junit)
	$(eval VERSION := $(JUNIT_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval JUNIT_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
