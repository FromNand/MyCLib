#ifndef _STD_H
#define _STD_H

// NULL
#define NULL (void*)0
#define null (void*)0

// ./lib/print.s
void print(const char*, ...);

// ./lib/debug.c
void print_section();

// ./lib/exit.s
void exit(int);

#endif
