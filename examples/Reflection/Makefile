SOURCE_DIR = src
TARGET_DIR = target
CLASSES_DIR = $(TARGET_DIR)/classes

TARGET = $(TARGET_DIR)/Reflection.jar

ifeq ($(OS),Windows_NT)
KOTLINC=kotlinc.bat
KOTLIN=kotlin.bat
JAR=jar.exe
else
KOTLINC=kotlinc
KOTLIN=kotlin
JAR=jar
endif

all: build run

build: $(TARGET)

$(TARGET): $(SOURCE_DIR)/main/kotlin/*.kt
	test -d $(CLASSES_DIR) || mkdir -p $(CLASSES_DIR)
	$(KOTLINC) -language-version 1.3 -d $(CLASSES_DIR) $<
	jar cf $(TARGET) -C $(CLASSES_DIR) .

clean:
	rm -rf $(TARGET_DIR)

run: build
	$(KOTLIN) -cp $(TARGET) ReflectionKt

.PHONY: all build clean run
