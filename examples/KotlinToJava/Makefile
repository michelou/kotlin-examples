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

##############################################################################
## phony

.PHONY: all build clean run
