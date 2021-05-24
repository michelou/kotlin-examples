include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

##############################################################################
## main rules

SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -type f -name *.kt)
TARGET = $(TARGET_DIR)/HelloWorld.jar

MAIN_CLASS = _02_properties.PropertiesKt
MAIN_ARGS ?= 

all: build run

build: $(TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || $(MKDIR) -p "$(CLASSES_DIR)"
	$(KOTLINC) -language-version $(LANGUAGE_VERSION) -d $(CLASSES_DIR) $^
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

LINT_SOURCES = $(shell $(FIND) $(SOURCE_DIR) -name *.kt)
LINT_TARGET  = $(TARGET_DIR)/.latest-lint

lint: $(LINT_TARGET)

$(LINT_TARGET): $(LINT_SOURCES)
	$(JAVA) -jar $(KTLINT_HOME)/ktlint.jar $^

##############################################################################
## phony

.PHONY: all build clean help lint run
