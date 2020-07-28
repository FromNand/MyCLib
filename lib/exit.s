.code32

.globl exit, print

.text

# デストラクタの関数(.dtors)を呼ばずにプログラムを終了する (たとえネストしてあっても)
exit:
    pushl %ebp
    movl %esp, %ebp
    movl $1, %eax
    movl 0x8(%ebp), %ebx
    int $0x80
    pushl $error
    call print
    addl $4, %esp
    leave
    ret
    
.data

error:
    .string "**** In ./lib/exit.s : not implemented.\n"
