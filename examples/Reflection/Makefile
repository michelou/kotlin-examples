include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

##############################################################################
## main rules

SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main -name *.kt)

TARGET = $(TARGET_DIR)/Reflection.jar

MAIN_CLASS = ReflectionKt
MAIN_ARGS ?= 

all: build run

build: $(TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || $(MKDIR) -p "$(CLASSES_DIR)"
	$(KOTLINC) -language-version $(LANGUAGE_VERSION) -d $(CLASSES_DIR) $<
	$(JAR) cf $(TARGET) -C $(CLASSES_DIR) .

clean:
	rm -rf "$(TARGET_DIR)"

run: build
	$(KOTLIN) -cp $(TARGET) $(MAIN_CLASS)

help:
	@$(info Usage: make all|build|clean|help|lint|run|test)
	@$(info )
	@echo   Subcommands:
	@echo     all    alias for build
	@echo     build  compile Kotlin source files
	@echo     clean  delete generated files
	@echo     help   display this help message
	@echo     lint   analyse Kotlin source files with KtLint
	@echo     run    execute main program $(MAIN_CLASS)
	@echo     test   execute unit tests with JUnit

##############################################################################
## lint rules

LINT_SOURCES = $(shell $(FIND) $(SOURCE_DIR) -name *.java)
LINT_TARGET  = $(TARGET_DIR)/.latest-lint

CHECKSTYLE_CONFIG_FILE = $(shell $(FIND) $(HOME)/.checkstyle -name *.xml)
CHECKSTYLE_JAR_FILE    = $(shell $(FIND) $(HOME)/.checkstyle -name checkstyle*.jar)

lint: $(LINT_TARGET)

$(LINT_TARGET): $(LINT_SOURCES)
	$(JAVA) -jar $(CHECKSTYLE_JAR_FILE) -c=$(CHECKSTYLE_CONFIG_FILE) $^

##############################################################################
## phony

.PHONY: all build clean help lint run
