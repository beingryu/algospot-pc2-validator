SRCS := $(wildcard src/*.java)
CLASSES := $(SRCS:src/%.java=class/%.class)

.PHONY: clean

Validator.jar: $(CLASSES)
	jar cvfe Validator.jar Starter -C class .

class:
	mkdir class

class/%.class: src/%.java class
	javac -d class $< -sourcepath src

clean:
	rm -rf class
	rm -rf Validator.jar
