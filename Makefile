# outputs
COPIED_FILES_U=module.modulemap Arduino.h SimpleDebugPrinter.h DebugPrinter.h Print.h Stream.h shims.h AdapterSerial.h\
Wire.h binary.h WString.h

# these seem to crash programs
# IPAddress.h Printable.h
# IPAddress.h Printable.h
#  Udp.h Client.h Server.h
COPIED_FILES_S=Arduino.swift
MODULE_NAME=Arduino

# program location and settings
# reasonable defaults, change to suit your build
AVR_BINUTILS_DIR=/usr/local/bin
AVR_GCC_BIN_DIR=/usr/local/bin
# this relies on the current S4A Community folder
# structure so it could very easily break in future
UNSAFE_MODULES_INSTALL_DIR=../../contributed\ libraries/unsafe_modules
SAFE_FILES_INSTALL_DIR=../../contributed\ libraries
CATALOG_FILE=../../contributed\ libraries/catalogNew.txt
LEGACY_CATALOG_FILE=../../contributed\ libraries/catalog.txt


# source files and settings
CPP_FILES=Stream.cpp Print.cpp abi.cpp SimpleDebugPrinter.cpp AdapterSerial.cpp\
Wire.cpp WString.cpp

#  IPAddress.cpp

MCU=atmega328p
# note, for this bluetooth library, it is too bulky, probably partly because it
# uses an unnecessarily large amount of underlying Arduino furniture like Stream
# and Print, as a result we have to compile with -Os or it won't fit
CPP_OPTS=-std=c++11 -ffunction-sections -Os
AR_OPTS=rcs


# derived variables
BIN_DIR = bin
CPP_OBJS=$(CPP_FILES:%.cpp=$(BIN_DIR)/%.o)
GCC_PLUS_OPTS=-mmcu=$(MCU) $(CPP_OPTS) -B"$(AVR_BINUTILS_DIR)" -iquote .
AR="$(AVR_BINUTILS_DIR)/avr-ar" $(AR_OPTS)
GCC_PLUS_BIN=$(AVR_GCC_BIN_DIR)/avr-gcc
GCC_PLUS="$(GCC_PLUS_BIN)" $(GCC_PLUS_OPTS)
BUILT_PRODUCT=$(BIN_DIR)/lib$(MODULE_NAME).a
MODULE_NAME_DIR=$(UNSAFE_MODULES_INSTALL_DIR)/$(MODULE_NAME)
IS_BIN_DIR_READONLY = $(shell test -d $(BIN_DIR) && (test -w $(BIN_DIR) || echo "READONLY"))

BUILT_PRODUCT_INSTALL=$(BUILT_PRODUCT:=-install)
COPIED_FILES_U_INSTALL=$(COPIED_FILES_U:=-install)
COPIED_FILES_S_INSTALL=$(COPIED_FILES_S:=-install)

# subroutine

define includeFileReference
		if ! grep -s $(1) $(2); then \
		  echo "\n$(1)\c" >> $(2); \
		fi
endef


#targets

.PHONY: all clean install $(BUILT_PRODUCT_INSTALL) $(COPIED_FILES_U_INSTALL) $(COPIED_FILES_S_INSTALL)

ifneq ($(wildcard $(GCC_PLUS_BIN)),)
all: $(BUILT_PRODUCT)
else
$(info avr-gcc not found at $(GCC_PLUS_BIN), relying on pre-build binaries only)
all:
	echo "DONE"
endif

$(BIN_DIR):
	mkdir -p $@

ifeq ($(IS_BIN_DIR_READONLY),READONLY)
$(info Cannot write to directory $(BIN_DIR), read only. Probably a binary distribution, skipping build.)
$(BUILT_PRODUCT):
	echo "DONE"
else
$(BUILT_PRODUCT): $(BIN_DIR) $(CPP_OBJS)
	$(AR) -o $@ $(CPP_OBJS)
endif

$(BIN_DIR)/%.o: %.cpp
	$(GCC_PLUS) -I . -DF_CPU=16000000UL -c -o $@ $<

clean:
	rm -rf *.o *.a $(BIN_DIR)

# install section

$(CATALOG_FILE):
	if [ ! -e "$@" ]; then cp $(LEGACY_CATALOG_FILE) "$@";fi

$(MODULE_NAME_DIR):
	if [ ! -d "$@" ]; then mkdir -p "$@";fi

$(BUILT_PRODUCT_INSTALL): $(BUILT_PRODUCT) $(MODULE_NAME_DIR) $(CATALOG_FILE)
	cp -a $(@:-install=) $(UNSAFE_MODULES_INSTALL_DIR)/$(MODULE_NAME)/
	$(call includeFileReference,unsafe_modules/$(MODULE_NAME)/$(@:-install=),$(CATALOG_FILE))

$(COPIED_FILES_U_INSTALL): $(COPIED_FILES_U) $(MODULE_NAME_DIR) $(CATALOG_FILE)
	cp -a $(@:-install=) $(UNSAFE_MODULES_INSTALL_DIR)/$(MODULE_NAME)/
	$(call includeFileReference,unsafe_modules/$(MODULE_NAME)/$(@:-install=),$(CATALOG_FILE))

$(COPIED_FILES_S_INSTALL): $(COPIED_FILES_S) $(CATALOG_FILE)
	cp -a $(@:-install=) $(SAFE_FILES_INSTALL_DIR)/
	$(call includeFileReference,$(@:-install=),$(CATALOG_FILE))

install: $(BUILT_PRODUCT_INSTALL) $(COPIED_FILES_U_INSTALL) $(COPIED_FILES_S_INSTALL)
