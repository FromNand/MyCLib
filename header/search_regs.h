// ./lib/search_regs.c & ./lib/search_regs.s

#ifndef _SEARCH_REGS_H
#define _SEARCH_REGS_H

// 順番が逆なのはアセンブラでpushalをした際に適切な順番に格納されるように
typedef struct REGS {
    unsigned int eip, edi, esi, ebp, esp, ebx, edx, ecx, eax;
} REGS;

unsigned int search_eax(void);
unsigned int search_ecx(void);
unsigned int search_edx(void);
unsigned int search_ebx(void);
unsigned int search_esp(void);
unsigned int search_ebp(void);
unsigned int search_esi(void);
unsigned int search_edi(void);
unsigned int search_eip(void);
REGS* search_regs(REGS*);
void print_regs(REGS*);

#endif
