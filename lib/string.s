.code32

.globl strlen
.globl strncpy
.globl reverse_str

.text

strlen:
    pushl %ebp
    movl %esp, %ebp
strlen_start:
    movl 0x8(%ebp), %eax
    xorl %ecx, %ecx
strlen_loop:
    cmpb $0, (%eax)
    je strlen_end
    incl %eax
    incl %ecx
    jmp strlen_loop
strlen_end:
    movl %ecx, %eax
    leave
    ret

strncpy:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
strncpy_start:
    movl 0x10(%ebp), %ecx
    movl 0xc(%ebp), %esi
    movl 0x8(%ebp), %edi
strncpy_cpy:
    rep movsb
strncpy_end:
    movl 0x8(%ebp), %eax
    popl %edi
    popl %esi
    leave
    ret

reverse_str:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushf
reverse_str_start:
    cld
    pushl 0x8(%ebp)
    call strlen
    addl $4, %esp
    movl %eax, %ecx
    pushl %eax
    movl 0x8(%ebp), %esi
    movl $reverse_str_temp, %edi
reverse_str_copy_str:
    cmpl $0, %ecx
    je reverse_str_2
    movsb
    decl %ecx
    jmp reverse_str_copy_str
reverse_str_2:
    movl $reverse_str_temp, %esi
    popl %ecx
    addl %ecx, %esi
    decl %esi
    movl 0x8(%ebp), %edi
reverse_str_loop:
    cmpl $0, %ecx
    je reverse_str_end
    movb (%esi), %al
    movb %al, (%edi)
    decl %esi
    incl %edi
    decl %ecx
    jmp reverse_str_loop
reverse_str_end:
    movl 0x8(%ebp), %eax
    popf
    popl %edi
    popl %esi
    leave
    ret

.bss

reverse_str_temp:
    .space 1024, 0x00
