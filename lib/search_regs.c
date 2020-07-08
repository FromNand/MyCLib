#include<std.h>
#include<search_regs.h>

void print_regs(REGS *regs){
    print("eax = %x, ecx = %x, edx = %x, ebx = %x, esp = %x, ebp = %x, esi = %x, edi = %x, eip = %x\n", \
          regs->eax, regs->ecx, regs->edx, regs->ebx, regs->esp, regs->ebp, regs->esi, regs->edi, regs->eip);
}
