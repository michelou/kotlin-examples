include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

##############################################################################
## main rules

SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -type f -name *.kt)
TARGET = $(TARGET_DIR)/HelloWorld.jar

MAIN_CLASS = org.example.main.HelloWorldKt
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
	$(KOTLIN) -cp $(TARGET) $(MAIN_CLASS) $(MAIN_ARGS)

help:
	@$(ECHO) "Usage: make all|build|clean|help|lint|run|test"
	@$(ECHO) ""
	@$(ECHO) "  Subcommands:"
	@$(ECHO) "    all    alias for build"
	@$(ECHO) "    build  compile Kotlin source files"
	@$(ECHO) "    clean  delete generated files"
	@$(ECHO) "    doc    generate HTML documentation"
	@$(ECHO) "    help   display this help message"
	@$(ECHO) "    lint   analyse Kotlin source files with KtLint"
	@$(ECHO) "    run    execute main program $(MAIN_CLASS)"
	@$(ECHO) "    test   execute unit tests with JUnit"

##############################################################################
## doc rules

DOC_TARGET_DIR = $(TARGET_DIR)/docs
DOC_SOURCES    = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -type f -name *.kt)
DOC_TARGET     = $(TARGET_DIR)/.latest-doc

PROJECT_NAME    ?= $(shell basename $(CURDIR))
PROJECT_URL     ?= https://github.com/$(USERNAME)/kotlin-examples
PROJECT_VERSION ?= 1.0.0

DOKKA_ARGS = -pluginsClasspath "$(DOKKA_CPATH)" -moduleName "$(PROJECT_NAME)" -moduleVersion "$(PROJECT_VERSION)" -outputDir "$(DOC_TARGET_DIR)" -sourceSet "-src $(SOURCE_DIR)/main/kotlin"

$(DOC_TARGET): $(DOC_SOURCES)
	[ -d "$(DOC_TARGET_DIR)" ] || $(MKDIR) -p "$(DOC_TARGET_DIR)"
	$(KOTLIN) "$(DOKKA_CLI_JAR)" $(DOKKA_ARGS)
	@$(TOUCH) "$(DOC_TARGET)"

doc: $(DOC_TARGET)

##############################################################################
## lint rules

LINT_SOURCES = $(shell $(FIND) $(SOURCE_DIR) -type f -name *.kt)
LINT_TARGET  = $(TARGET_DIR)/.latest-lint

lint: $(LINT_TARGET)

$(LINT_TARGET): $(LINT_SOURCES)
	$(JAVA) -jar $(KTLINT_HOME)/ktlint.jar $^
	@$(TOUCH) $(LINT_TARGET)

##############################################################################
## test rules

TEST_SOURCES = $(shell $(FIND) $(SOURCE_DIR)/test/kotlin -name *.kt)
TEST_TARGET = $(TARGET_DIR)/HelloWorldTest.jar

TEST_CLASSES_DIR = $(TARGET_DIR)/test-classes
TEST_CPATH       = $(HAMCREST_JAR)$(PSEP)$(JUNIT_JAR)$(PSEP)$(TARGET)
TEST_MAIN_CLASS  = org.example.test.HelloWorldTestKt

test: $(TARGET) $(TEST_TARGET)
	$(JAVA) -classpath "$(TEST_CPATH)$(PSEP)$(TEST_TARGET)" org.junit.runner.JUnitCore $(TEST_MAIN_CLASS)

$(TEST_TARGET): $(TEST_SOURCES)
	[ -d "$(TEST_CLASSES_DIR)" ] || $(MKDIR) -p "$(TEST_CLASSES_DIR)"
	$(KOTLINC) -cp "$(TEST_CPATH)" -d "$(TEST_CLASSES_DIR)" $^
	$(JAR) cf $(TEST_TARGET) -C $(TEST_CLASSES_DIR) .

##############################################################################
## phony

.PHONY: all build clean doc help lint run test
