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

SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -type f -name "*.kt")
TARGET  = $(TARGET_DIR)/JavaToKotlin.jar

JAVA_SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/java -type f -name "*.java")
JAVA_TARGET  = $(TARGET_DIR)/.latest-build

MAIN_CLASS = MainKt
MAIN_ARGS ?= 

all: build run

build: $(JAVA_TARGET) $(TARGET)

$(JAVA_TARGET): $(JAVA_SOURCES)
	[ -d "$(CLASSES_DIR)" ] || "$(MKDIR)" -p "$(CLASSES_DIR)"
	"$(JAVAC)" -d "$(CLASSES_DIR)" $^
	@$(TOUCH) $(JAVA_TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || $(MKDIR) -p "$(CLASSES_DIR)"
	"$(KOTLINC)" -language-version $(LANGUAGE_VERSION) -cp "$(CLASSES_DIR)" -d "$(CLASSES_DIR)" $^
	"$(JAR)" cf $(TARGET) -C $(CLASSES_DIR) .

clean:
	$(RM) -rf "$(TARGET_DIR)"

run: build
	$(KOTLIN) -cp $(TARGET) $(MAIN_CLASS) $(MAIN_ARGS)

help:
	@$(ECHO) "Usage: make all|build|clean|help|lint|run|test"
	@$(ECHO) ""
	@$(ECHO) "  Subcommands:"
	@$(ECHO) "    all    alias for build"
	@$(ECHO) "    build  compile Kotlin source files"
	@$(ECHO) "    clean  delete generated files"
	@$(ECHO) "    doc    generate HTML documentation"
	@$(ECHO) "    help   print this help message"
	@$(ECHO) "    lint   analyse Kotlin source files with KtLint"
	@$(ECHO) "    run    execute main program \"$(MAIN_CLASS)\""
	@$(ECHO) "    test   execute unit tests with JUnit"

##############################################################################
## doc rules

DOC_TARGET_DIR = $(TARGET_DIR)/docs
DOC_SOURCES    = $(shell $(FIND) "$(SOURCE_DIR)/main/kotlin" -type f -name "*.kt")
DOC_TARGET     = $(TARGET_DIR)/.latest-doc

PROJECT_NAME    ?= $(shell basename $(CURDIR))
PROJECT_URL     ?= https://github.com/$(USERNAME)/kotlin-examples
PROJECT_VERSION ?= 1.0.0

DOKKA_ARGS = -pluginsClasspath "$(DOKKA_CPATH)" -moduleName "$(PROJECT_NAME)" -moduleVersion "$(PROJECT_VERSION)" -outputDir "$(DOC_TARGET_DIR)" -sourceSet "-src $(SOURCE_DIR)/main/kotlin"

$(DOC_TARGET): $(DOC_SOURCES)
	[ -d "$(DOC_TARGET_DIR)" ] || "$(MKDIR)" -p "$(DOC_TARGET_DIR)"
	"$(KOTLIN)" "$(DOKKA_CLI_JAR)" $(DOKKA_ARGS)
	@$(TOUCH) "$(DOC_TARGET)"

doc: $(DOC_TARGET)

##############################################################################
## lint rules

LINT_SOURCES = $(shell $(FIND) "$(SOURCE_DIR)" -type f -name "*.kt")
LINT_TARGET  = $(TARGET_DIR)/.latest-lint

CHECKSTYLE_CONFIG_FILE = $(shell $(FIND) "$(HOME)/.checkstyle" -type f -name "*.xml")
CHECKSTYLE_JAR_FILE    = $(shell $(FIND) "$(HOME)/.checkstyle" -type f -name "checkstyle*.jar")

lint: $(LINT_TARGET)

$(LINT_TARGET): $(LINT_SOURCES)
	"$(JAVA)" -jar $(CHECKSTYLE_JAR_FILE) -c=$(CHECKSTYLE_CONFIG_FILE) $^

##############################################################################
## phony

.PHONY: all build clean doc help lint run

.SUFFIXES:
.SUFFIXES: .class .jar .java .kt .xml
