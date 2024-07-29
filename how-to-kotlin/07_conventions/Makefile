##
## Copyright (c) 2018-2024 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

##############################################################################
## main rules

SOURCES = $(shell $(FIND) "$(SOURCE_DIR)/main/kotlin" -type f -name "*.kt")
TARGET  = $(TARGET_DIR)/Conventions.jar

MAIN_CLASS = _07_conventions.ConventionsKt
MAIN_ARGS ?= 

all: build run

build: $(TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || "$(MKDIR)" -p "$(CLASSES_DIR)"
	"$(KOTLINC)" -language-version $(LANGUAGE_VERSION) -d "$(CLASSES_DIR)" $^
	"$(JAR)" cf $(TARGET) -C $(CLASSES_DIR) .

clean:
	"$(RM)" -rf "$(TARGET_DIR)"

run: build
	"$(KOTLIN)" -cp $(TARGET) $(MAIN_CLASS)

help:
	@$(ECHO) "Usage: make all|build|clean|help|lint|run|test"
	@$(ECHO) ""
	@$(ECHO) "  Subcommands:"
	@$(ECHO) "   all    alias for build"
	@$(ECHO) "   build  compile Kotlin source files"
	@$(ECHO) "   clean  delete generated files"
	@$(ECHO) "   help   print this help message"
	@$(ECHO) "   lint   analyse Kotlin source files with KtLint"
	@$(ECHO) "   run    execute main program \"$(MAIN_CLASS)\""
	@$(ECHO) "   test   execute unit tests with JUnit"

##############################################################################
## lint rules

LINT_SOURCES = $(shell $(FIND) "$(SOURCE_DIR)" -type f -name "*.kt")
LINT_TARGET  = $(TARGET_DIR)/.latest-lint

lint: $(LINT_TARGET)

$(LINT_TARGET): $(LINT_SOURCES)
	"$(JAVA)" -jar "$(KTLINT_HOME)/ktlint.jar" $^
	@$(TOUCH) "$(LINT_TARGET)"

##############################################################################
## doc rules

DOC_SOURCES = $(shell $(FIND) "$(SOURCE_DIR)/main/kotlin" -type f -name "*.kt")
DOC_TARGET  = $(TARGET_DIR)/.latest-doc

DOKKA_CLI_JAR  = $(shell $(FIND) "$(DOKKA_HOME)/lib" -type f -name "dokka-cli*.jar")
DOKKA_OUT_DIR  = $(TARGET_DIR)/docs
DOKKA_CPATH    = $(KOTLINX_COROUTINES_JAR)$(PSEP)$(KOTLINX_HTML_JAR)$(PSEP)$(MARKDOWN_JAR)$(PSEP)$(DOKKA_ANALYSIS_JAR)$(PSEP)$(DOKKA_BASE_JAR)$(PSEP)$(DOKKA_COMPILER_JAR)$(PSEP)$(DOKKA_INTELLIJ_JAR)$(PSEP)$(DOKKA_PLUGIN_JAR)$(PSEP)$(INTELLIJ_CORE_JAR)$(PSEP)$(OPENAPI_JAR)
DOKKA_CLI_OPTS = -pluginsClasspath "$(DOKKA_CPATH)" -moduleName 01_bean -moduleVersion 1.0 -outputDir "$(DOKKA_OUT_DIR)" -sourceSet "-src $(SOURCE_DIR)/main/kotlin"

doc: $(DOC_TARGET)

$(DOC_TARGET): $(DOC_SOURCES)
	[ -d "$(DOKKA_OUT_DIR)" ] || "$(MKDIR)" -p "$(DOKKA_OUT_DIR)"
	"$(JAVA)" -jar "$(DOKKA_CLI_JAR)" $(DOKKA_CLI_OPTS)
	@$(TOUCH) "$(DOC_TARGET)"

##############################################################################
## test rules

TEST_SOURCES     = $(shell $(FIND) "$(SOURCE_DIR)/test" -type f -name "*.kt")
TEST_CLASSES_DIR = $(TARGET_DIR)/test-classes
TEST_TARGET      = $(TARGET_DIR)/.latest-test-build

TEST_OPTS_FILE    = $(TARGET_DIR)/kotlinc_test_opts.txt
TEST_SOURCES_FILE = $(TARGET_DIR)/kotlinc_test_sources.txt

TEST_MAIN_CLASS = _07_conventions.ConventionsJUnitTestKt
TEST_CPATH      = $(HAMCREST_JAR)$(PSEP)$(JUNIT_JAR)$(PSEP)$(JUNIT_INTF_JAR)$(PSEP)$(SCALATEST_JAR)$(PSEP)$(SCALACTIC_JAR)$(PSEP)$(SPECS2_CORE_JAR)$(PSEP)$(SPECS2_JUNIT_JAR)$(PSEP)$(SPECS2_MATCHER_JAR)$(PSEP)$(CLASSES_DIR)$(PSEP)$(TEST_CLASSES_DIR)

$(TEST_TARGET): $(TEST_SOURCES)
	[ -d "$(TEST_CLASSES_DIR)" ] || "$(MKDIR)" -p "$(TEST_CLASSES_DIR)"
	@$(ECHO) $(SCALAC_FLAGS) -classpath "$(TEST_CPATH)" -d "$(TEST_CLASSES_DIR)" > "$(TEST_OPTS_FILE)"
	@$(ECHO) $(TEST_SOURCES) > "$(TEST_SOURCES_FILE)"
	"$(KOTLINC)" "@$(TEST_OPTS_FILE)" "@$(TEST_SOURCES_FILE)"
	@$(TOUCH) "$(TEST_TARGET)"

test: $(TARGET) $(TEST_TARGET)
	"$(JAVA)" -classpath "$(TEST_CPATH)" org.junit.runner.JUnitCore $(TEST_MAIN_CLASS)

##############################################################################
## phony

.PHONY: all build clean doc help lint run test

.SUFFIXES:
.SUFFIXES: .class .jar .java .kt
