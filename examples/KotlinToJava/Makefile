include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

##############################################################################
## main rules

SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -name *.kt)
TARGET  = $(TARGET_DIR)/JavaToKotlin.jar

JAVA_SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/java -name *.java)
JAVA_TARGET  = $(TARGET_DIR)/.latest-build

MAIN_CLASS = JavaInteropKt
MAIN_ARGS ?= 

KOTLIN_CPATH=$(KOTLIN_STDLIB_JAR)$(PSEP)$(KOTLIN_JDK8_JAR)

all: build run

build: $(TARGET) $(JAVA_TARGET)

$(JAVA_TARGET): $(JAVA_SOURCES)
	[ -d "$(CLASSES_DIR)" ] || $(MKDIR) -p "$(CLASSES_DIR)"
	$(JAVAC) -cp $(KOTLIN_CPATH)$(PSEP)$(CLASSES_DIR) -d $(CLASSES_DIR) $^
	touch $(JAVA_TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || $(MKDIR) -p "$(CLASSES_DIR)"
	$(KOTLINC) -language-version $(LANGUAGE_VERSION) -d $(CLASSES_DIR) $^
	$(JAR) cfe $(TARGET) $(MAIN_CLASS) -C $(CLASSES_DIR) .

clean:
	rm -rf "$(TARGET_DIR)"

run: build
	$(JAVA) -cp $(KOTLIN_CPATH) -jar $(TARGET)

help:
	@$(info Usage: make all|build|clean|help|lint|run|test)
	@$(info )
	@echo   Subcommands:
	@echo     all    alias for build
	@echo     build  compile Kotlin source files
	@echo     clean  delete generated files
	@echo     help   display this help message
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

.PHONY: all build clean help run