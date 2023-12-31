# outputs
COPIED_FILES_U=module.modulemap Arduino.h SimpleDebugPrinter.h DebugPrinter.h Print.h Stream.h shims.h AdapterSerial.h\
Wire.h binary.h WString.h SoftwareSerial.h

# these seem to crash programs
# IPAddress.h Printable.h
# IPAddress.h Printable.h
#  Udp.h Client.h Server.h
COPIED_FILES_S=Arduino.swift
MODULE_NAME=Arduino

# try different versions of AVR GCC
AVR_GCC_BIN_DIR := /usr/local/bin
AVR_BINUTILS_DIR := /usr/local/bin

ifeq ($(wildcard $(AVR_GCC_BIN_DIR)/avr-gcc),)
AVR_GCC_BIN_DIR := /opt/homebrew/bin
AVR_BINUTILS_DIR := /opt/homebrew/bin
ifeq ($(wildcard $(AVR_GCC_BIN_DIR)/avr-gcc),)
$(error avr-gcc not found. AVR GCC is required to build this package.)
endif
endif

# this relies on the current S4A Community folder
# structure so it could very easily break in future
UNSAFE_MODULES_INSTALL_DIR=../../contributed\ libraries/unsafe_modules
SAFE_FILES_INSTALL_DIR=../../contributed\ libraries
CATALOG_FILE=../../contributed\ libraries/catalogNew.txt
LEGACY_CATALOG_FILE=../../contributed\ libraries/catalog.txt


# source files and settings
CPP_FILES=Stream.cpp Print.cpp abi.cpp SimpleDebugPrinter.cpp AdapterSerial.cpp \
Wire.cpp WString.cpp WMath.cpp SoftwareSerial.cpp new.cpp

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
GCC_PLUS_OPTS=-mmcu=$(MCU) $(CPP_OPTS) -iquote .
AR="$(AVR_BINUTILS_DIR)/avr-ar" $(AR_OPTS)
GCC_PLUS_BIN=$(AVR_GCC_BIN_DIR)/avr-gcc
GCC_PLUS="$(GCC_PLUS_BIN)" $(GCC_PLUS_OPTS)
BUILT_PRODUCT=$(BIN_DIR)/lib$(MODULE_NAME).a
MODULE_NAME_DIR=$(UNSAFE_MODULES_INSTALL_DIR)/$(MODULE_NAME)

BUILT_PRODUCT_INSTALL=$(BUILT_PRODUCT:=-install)
COPIED_FILES_U_INSTALL=$(COPIED_FILES_U:=-install)
COPIED_FILES_S_INSTALL=$(COPIED_FILES_S:=-install)

#targets

.PHONY: all clean install $(BUILT_PRODUCT_INSTALL) $(COPIED_FILES_U_INSTALL) $(COPIED_FILES_S_INSTALL)

all: $(BUILT_PRODUCT)

$(BIN_DIR):
	mkdir -p $@

$(BUILT_PRODUCT): $(BIN_DIR) $(CPP_OBJS)
	$(AR) -o $@ $(CPP_OBJS)

$(BIN_DIR)/%.o: %.cpp
	$(GCC_PLUS) -I . -DF_CPU=16000000UL -c -o $@ $<

clean:
	rm -rf *.o *.a $(BIN_DIR)
