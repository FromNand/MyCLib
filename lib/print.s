#.dataの部分をみるとわかるが、temp(一時記憶領域)は1KBしかとっていない
#それより大きな配列を扱う場合には、.space 0x10000 などとすること
#%c, %d(正の数のみ), %x, %sが使用できる

.code32

.globl print

.text

putc:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    xorl %ecx, %ecx
    movl $4, %eax
    movl $1, %ebx
    leal 0x8(%ebp), %ecx
    movl $2, %edx
    int $0x80
    popl %ebx
    leave
    ret

print_str:
    pushl %ebp
    movl %esp, %ebp
    pushal
    pushl 0x8(%ebp)
    call strlen
    addl $4, %esp
    movl %eax, %edx
    movl $4, %eax
    movl $1, %ebx
    movl 0x8(%ebp), %ecx
    int $0x80
    popal
    leave
    ret

print_num10:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    movl 0x8(%ebp), %eax
    movl $10, %ebx
    movl $print_num_temp, %ecx
    xorl %edx, %edx
print_num10_loop:
    divl %ebx
    addl $0x30, %edx
    movb %dl, (%ecx)
    xorl %edx, %edx
    incl %ecx
    cmpl $0, %eax
    je print_num10_end
    jmp print_num10_loop
print_num10_end:
    movl $0, (%ecx)
    pushl $print_num_temp
    call reverse_str
    pushl $print_num_temp
    call print_str
    addl $4, %esp
    popl %ebx
    leave
    ret

print_num16:
    pushl %ebp
    movl %esp, %ebp
    movl 0x8(%ebp), %eax
    movl $print_num_temp, %ecx
    xorl %edx, %edx
print_num16_loop:
    movl %eax, %edx
    andl $0xf, %edx
    shrl $4, %eax
    cmpl $0xa, %edx
    jae print_num16_alpha
print_num16_number:
    addl $0x30, %edx
    movb %dl, (%ecx)
    xorl %edx, %edx
    incl %ecx
    cmpl $0, %eax
    je print_num16_end
    jmp print_num16_loop
print_num16_alpha:
    addl $0x37, %edx
    movb %dl, (%ecx)
    xorl %edx, %edx
    incl %ecx
    cmpl $0, %eax
    je print_num16_end
    jmp print_num16_loop
print_num16_end:
    movl $0, (%ecx)
    pushl $print_num_temp
    call reverse_str
    pushl $print_num_temp
    call print_str
    addl $4, %esp
    leave
    ret

print:
    pushl %ebp
    movl %esp, %ebp
print_start:
    movl 0x8(%ebp), %eax
    movl $0x3, %edx
print_loop:
    cmpb $0, (%eax)
    je print_end
    cmpb $'%, (%eax)
    je print_param
    jmp print_default
print_param:
    incl %eax
    cmpb $'c, (%eax)
    je print_char
    cmpb $'d, (%eax)
    je print_dec32
    cmpb $'x, (%eax)
    je print_hex32
    cmpb $'s, (%eax)
    je print_string
    jmp print_default
print_char:
    pushal
    pushl (%ebp, %edx, 4)
    call putc
    addl $4, %esp
    popal
    incl %eax
    incl %edx
    jmp print_loop
print_dec32:
    pushal
    pushl (%ebp, %edx, 4)
    call print_num10
    addl $4, %esp
    popal
    incl %eax
    incl %edx
    jmp print_loop
print_hex32:
    pushal
    pushl (%ebp, %edx, 4)
    call print_num16
    addl $4, %esp
    popal
    incl %eax
    incl %edx
    jmp print_loop
print_string:
    pushal
    pushl (%ebp, %edx, 4)
    call print_str
    addl $4, %esp
    popal
    incl %eax
    incl %edx
    jmp print_loop
print_default:
    pushal
    xorl %ecx, %ecx
    movzbl (%eax), %ecx
    pushl %ecx
    call putc
    addl $4, %esp
    popal
    incl %eax
    jmp print_loop
print_end:
    leave
    ret

.bss

#なぜわざわざ領域を複数用意しているかというと、複数の関数で同じtempを使うと自身を上書きしてしまうことがあるから
#絶対に同時に呼び出されない関数(例 print_num10 print_num16)などでは領域を使いまわしているが...

print_num_temp:
    .space 1024, 0x00
