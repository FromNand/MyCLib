#include<std.h>

// ctors

void init1(void){
    print("init1\n");
}

void init2(void){
    print("init2\n");
}

void (*fp1)(void) __attribute__((section(".ctors"))) = init1;
void (*fp2)(void) __attribute__((section(".ctors"))) = init2;

// dtors

void fini1(void){
    print("fini1\n");
}

void fini2(void){
    print("fini2\n");
}

void (*fp3)(void) __attribute__((section(".dtors"))) = fini1;
void (*fp4)(void) __attribute__((section(".dtors"))) = fini2;
