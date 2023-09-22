##
## Copyright (c) 2018-2023 Stéphane Micheloud
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
TARGET = $(TARGET_DIR)/Functions.jar

MAIN_CLASS = _03_functions.FunctionsKt
MAIN_ARGS ?= 

all: build run

build: $(TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || "$(MKDIR)" -p "$(CLASSES_DIR)"
	"$(KOTLINC)" -language-version $(LANGUAGE_VERSION) -d "$(CLASSES_DIR)" $^
	"$(JAR)" cf "$(TARGET)" -C "$(CLASSES_DIR)" .

clean:
	"$(RM)" -rf "$(TARGET_DIR)"

run: build
	"$(KOTLIN)" -cp "$(TARGET)" $(MAIN_CLASS)

help:
	@$(ECHO) "Usage: make all|build|clean|help|lint|run|test"
	@$(ECHO) ""
	@$(ECHO) "  Subcommands:"
	@$(ECHO) "    all    alias for build"
	@$(ECHO) "    build  compile Kotlin source files"
	@$(ECHO) "    clean  delete generated files"
	@$(ECHO) "    help   display this help message"
	@$(ECHO) "    lint   analyse Kotlin source files with KtLint"
	@$(ECHO) "    run    execute main program \"$(MAIN_CLASS)\""
	@$(ECHO) "    test   execute unit tests with JUnit"

##############################################################################
## lint rules

LINT_SOURCES = $(shell $(FIND) "$(SOURCE_DIR)" -type f -name "*.kt")
LINT_TARGET  = $(TARGET_DIR)/.latest-lint

lint: $(LINT_TARGET)

$(LINT_TARGET): $(LINT_SOURCES)
	"$(JAVA)" -jar "$(KTLINT_HOME)/ktlint.jar" $^

##############################################################################
## doc rules

DOC_SOURCES = $(shell $(FIND) "$(SOURCE_DIR)/main/kotlin" -type f -name "*.kt")
DOC_TARGET  = $(TARGET_DIR)/.latest-doc

DOKKA_CLI_JAR  = $(shell $(FIND) "$(DOKKA_HOME)/lib" -type f -name "dokka-cli*.jar")
DOKKA_OUT_DIR  = $(TARGET_DIR)/docs
DOKKA_CPATH    = $(KOTLINX_COROUTINES_JAR)$(PSEP)$(KOTLINX_HTML_JAR)$(PSEP)$(MARKDOWN_JAR)$(PSEP)$(DOKKA_ANALYSIS_JAR)$(PSEP)$(DOKKA_BASE_JAR)$(PSEP)$(DOKKA_COMPILER_JAR)$(PSEP)$(DOKKA_INTELLIJ_JAR)$(PSEP)$(DOKKA_PLUGIN_JAR)$(PSEP)$(INTELLIJ_CORE_JAR)$(PSEP)$(OPENAPI_JAR)
DOKKA_CLI_OPTS = -pluginsClasspath "$(DOKKA_CPATH)" -moduleName 03_functions -moduleVersion 1.0 -outputDir "$(DOKKA_OUT_DIR)" -sourceSet "-src $(SOURCE_DIR)/main/kotlin"

doc: $(DOC_TARGET)

$(DOC_TARGET): $(DOC_SOURCES)
	[ -d "$(DOKKA_OUT_DIR)" ] || "$(MKDIR)" -p "$(DOKKA_OUT_DIR)"
	"$(JAVA)" -jar "$(DOKKA_CLI_JAR)" $(DOKKA_CLI_OPTS)
	@$(TOUCH) "$(DOC_TARGET)"

##############################################################################
## phony

.PHONY: all build clean doc help lint run

.SUFFIXES:
.SUFFIXES: .class .jar .java .kt
