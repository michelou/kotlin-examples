##
## Copyright (c) 2018-2024 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

TOOLSET ?= jvm

include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

##############################################################################
## main rules

SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -type f -name "*.kt")

PKG_NAME = org.example

MAIN_NAME = LanguageFeatures
MAIN_CLASS = $(PKG_NAME).$(MAIN_NAME)Kt
MAIN_ARGS ?= 

TARGET = $(TARGET_DIR)/$(MAIN_NAME).jar
TARGET_NATIVE = $(TARGET_DIR)/$(MAIN_NAME)$(TARGET_EXT)

all: build run

build: $(TARGET)

$(TARGET): $(SOURCES)
ifeq ($(TOOLSET),jvm)
	[ -d "$(CLASSES_DIR)" ] || "$(MKDIR)" -p "$(CLASSES_DIR)"
	"$(KOTLINC)" -language-version $(LANGUAGE_VERSION) -d $(CLASSES_DIR) $^
	"$(JAR)" cf $(TARGET) -C $(CLASSES_DIR) .
else ifeq ($(TOOLSET),native)
	[ -d "$(TARGET_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DIR)"
	"$(KOTLINC_NATIVE)" -language-version $(LANGUAGE_VERSION) -o $(TARGET_NATIVE) -e "$(PKG_NAME).main" $^
else
	@$(ECHO) "Unknown toolset $(TOOLSET)"
endif

clean:
	rm -rf "$(TARGET_DIR)"

run: build
ifeq ($(TOOLSET),jvm)
	"$(KOTLIN)" -cp $(TARGET) $(MAIN_CLASS) $(MAIN_ARGS)
else ifeq ($(TOOLSET),native)
	exec "$(TARGET_NATIVE)"
else
	@$(ECHO) "Unknown toolset $(TOOLSET)"
endif

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
	@$(ECHO) ""
	@$(ECHO) "  Variables:"
	@$(ECHO) "    TOOLSET=jvm (default), native"

##############################################################################
## doc rules

DOC_TARGET_DIR = $(TARGET_DIR)/docs
DOC_SOURCES    = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -type f -name "*.kt")
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
.SUFFIXES: .class .exe .jar .java .kt .xml
