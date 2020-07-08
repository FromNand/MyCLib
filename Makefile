#file name of executable file.
EXE=exe

#we use this macro when we want to specify arguments to executable file.
#for example, make ARG='h1 h2 h3 h4 h5 h6 h7' is make a executable file and execute it with 7 arguments h1~7.
#default arguments are arg1~3.
ARG=arg1 arg2 arg3

#macro of file pass.
CSU=./csu
LIB=./lib
APP=./app
OBJ=./obj
SRC=./src
LS=./ls
HEADER=./header

#options to gcc.
GCC_OP=-m32 -nostdlib -fno-builtin -fno-pie -I $(HEADER)

#arguments to gcc.
ALL_CSU=$(CSU)/*
ALL_LIB=$(LIB)/*
ALL_APP=$(APP)/*

#linker scripts.
SAMPLE_LS=-T$(LS)/sample.lds
DEFAULT_LS=-T$(LS)/elf_i386.x

#don't display on screen.
.SILENT:
.PHONY: all file debug debug_arg clean

#make a executable file automatically and execute it with argument $(ARG).
all:
	rm -f $(EXE)
	gcc $(GCC_OP) $(SAMPLE_LS) $(ALL_CSU) $(ALL_APP) $(ALL_LIB) -o $(EXE)
	./$(EXE) $(ARG)

#make a executable file automatically.
file:
	rm -f $(EXE)
	gcc $(GCC_OP) $(SAMPLE_LS) $(ALL_CSU) $(ALL_APP) $(ALL_LIB) -o $(EXE)

#debug from startup function with no arguments.
debug: file
	gdb -q $(EXE) \
	-ex 'break *0x8049000' \
	-ex 'run' \
	-ex 'layout asm' \
	-ex 'i b' \
	-ex 'i r'

#debug from main function with three arguments.
debug_arg: file
	gdb -q $(EXE) \
	-ex 'start hikisuu1 hikisuu2 hikisuu3' \
	-ex 'layout asm' \
	-ex 'i r'

#delete all binary files.
clean:
	rm -f $(EXE)
