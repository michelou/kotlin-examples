include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

##############################################################################
## main rules

SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -name *.kt)
TARGET  = $(TARGET_DIR)/HelloWorld.jar

MAIN_CLASS = _01_bean.BeanKt
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
	@$(TOUCH) "$(LINT_TARGET)"

##############################################################################
## doc rules

DOC_SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -type f -name *.kt)
DOC_TARGET  = $(TARGET_DIR)/.latest-doc

DOKKA_CLI_JAR  = $(shell $(FIND) $(DOKKA_HOME)/lib -type f -name dokka-cli*.jar)
DOKKA_OUT_DIR  = $(TARGET_DIR)/docs
DOKKA_CPATH    = $(KOTLINX_COROUTINES_JAR)$(PSEP)$(KOTLINX_HTML_JAR)$(PSEP)$(MARKDOWN_JAR)$(PSEP)$(DOKKA_ANALYSIS_JAR)$(PSEP)$(DOKKA_BASE_JAR)$(PSEP)$(DOKKA_COMPILER_JAR)$(PSEP)$(DOKKA_INTELLIJ_JAR)$(PSEP)$(DOKKA_PLUGIN_JAR)$(PSEP)$(INTELLIJ_CORE_JAR)$(PSEP)$(OPENAPI_JAR)
DOKKA_CLI_OPTS = -pluginsClasspath "$(DOKKA_CPATH)" -moduleName 01_bean -moduleVersion 1.0 -outputDir "$(DOKKA_OUT_DIR)" -sourceSet "-src $(SOURCE_DIR)/main/kotlin"

doc: $(DOC_TARGET)

$(DOC_TARGET): $(DOC_SOURCES)
	[ -d "$(DOKKA_OUT_DIR)" ] || $(MKDIR) -p "$(DOKKA_OUT_DIR)"
	$(JAVA) -jar "$(DOKKA_CLI_JAR)" $(DOKKA_CLI_OPTS)
	@$(TOUCH) "$(DOC_TARGET)"

##############################################################################
## test rules

TEST_SOURCES     = $(shell $(FIND) $(SOURCE_DIR)/test -type f -name *.scala)
TEST_CLASSES_DIR = $(TARGET_DIR)/test-classes
TEST_TARGET      = $(TARGET_DIR)/.latest-test-build

TEST_OPTS_FILE    = $(TARGET_DIR)/scalac_test_opts.txt
TEST_SOURCES_FILE = $(TARGET_DIR)/scalac_test_sources.txt

TEST_MAIN_CLASS = _01_bean.BeanJUnitTestKt
TEST_CPATH      = $(SCALA_LIB_JAR)$(PSEP)$(SCALA3_LIB_JAR)$(PSEP)$(HAMCREST_JAR)$(PSEP)$(JUNIT_JAR)$(PSEP)$(JUNIT_INTF_JAR)$(PSEP)$(SCALATEST_JAR)$(PSEP)$(SCALACTIC_JAR)$(PSEP)$(SPECS2_CORE_JAR)$(PSEP)$(SPECS2_JUNIT_JAR)$(PSEP)$(SPECS2_MATCHER_JAR)$(PSEP)$(CLASSES_DIR)$(PSEP)$(TEST_CLASSES_DIR)

$(TEST_TARGET): $(TEST_SOURCES)
	[ -d "$(TEST_CLASSES_DIR)" ] || $(MKDIR) -p "$(TEST_CLASSES_DIR)"
	@echo $(SCALAC_FLAGS) -classpath "$(TEST_CPATH)" -d "$(TEST_CLASSES_DIR)" > "$(TEST_OPTS_FILE)"
	@echo $(TEST_SOURCES) > "$(TEST_SOURCES_FILE)"
	$(SCALAC) "@$(TEST_OPTS_FILE)" "@$(TEST_SOURCES_FILE)"
	@$(TOUCH) "$(TEST_TARGET)"

test: $(TARGET) $(TEST_TARGET)
	$(JAVA) -classpath "$(TEST_CPATH)" org.junit.runner.JUnitCore $(TEST_MAIN_CLASS)

##############################################################################
## phony

.PHONY: all build clean doc help lint run test
