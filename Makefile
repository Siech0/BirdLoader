
# Cleaned and fixed by StackOverflow user Michael Petch
C_SOURCES = $(wildcard *.c)
C_HEADERS = $(wildcard *.h)
ASM_SOURCES = $(wildcard *.s)
 
# Nice syntax for file extension replacement
OBJ = ${C_SOURCES:.c=.o} ${ASM_SOURCES:.s=.o}
 
# Change this if your cross-compiler is somewhere else
CC = ${HOME}/opt/cross/bin/i686-elf-gcc
LD = ${HOME}/opt/cross/bin/i686-elf-ld
AS = nasm

# Misc program setup
BINARY_NAME = boot.bin

# Compiler setup
CSTANDARD = -std=gnu11
CFLAGS = -O2 -ffreestanding -Wpedantic -Wall -Wextra #-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -Wall -Wextra

# First rule is run by default
all: build_release

# Full release build
build_release: CLFAGS +=  
build_release: CXXFLAGS += 
build_release: ${BINARY_NAME}

# Debug build
debug: CFLAGS += -DDEBUG -g -fno-omit-frame-pointer
debug: CXXFLAGS += -DDEBUG -g -fno-omit-frame-pointer
debug: ${BINARY_NAME}

# Generic rules for wildcards
# To make an object, always compile from its .c $< $@
%.o: %.c ${CHEADERS}
	${CC} ${CFLAGS} -Iinclude -MD -c $< -o $@ ${CSTANDARD}
 
%.o: %.cpp ${CXX_HEADERS}
	${CXX} ${CXXFLAGS} -Iinclude -MD -c $< -o $@ ${CXXSTANDARD}

%.o: %.s
	${AS} -f bin $< -o $@
 
#%.o: %.asm
#	${AS} -g -f elf32 -F dwarf -o $@ $<

${BINARY_NAME}: ${OBJ}


.PHONY: run
run: ${BINARY_NAME}
	qemu-system-x86_64 -drive format=raw,file=boot.bin

 
.PHONY: clean
clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf *.iso

