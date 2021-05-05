include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

##############################################################################
## main rules

KOTLIN_SOURCES = $(shell $(FIND) $(SOURCE_DIR)/main/kotlin -name *.kt)

TARGET = $(TARGET_DIR)/Reflection.jar

MAIN_CLASS = org.example.main.HelloWorldKt
MAIN_ARGS ?= 

all: build run

build: $(TARGET)

$(TARGET): $(KOTLIN_SOURCES)
	[ -d "$(CLASSES_DIR)" ] || $(MKDIR) -p "$(CLASSES_DIR)"
	$(KOTLINC) -language-version $(LANGUAGE_VERSION) -d $(CLASSES_DIR) $<
	$(JAR) cf $(TARGET) -C $(CLASSES_DIR) .

clean:
	rm -rf $(TARGET_DIR)

run: build
	$(KOTLIN) -cp $(TARGET) $(MAIN_CLASS)

##############################################################################
## phony

.PHONY: all build clean run
