# espの場合は関数を呼び出した後の値を返す(引数、戻り地などがespを変化させて、厳密にやるのがめんどい)
# eipの場合は関数を呼び出す命令のアドレスを返す

.code32

.globl search_eax, search_ecx, search_edx, search_ebx, search_esp, search_ebp, search_esi, search_edi, search_eip
.globl search_regs

.text

# こいつらは単発でレジスタを調べたいときに使うといい
# 呼び出して戻り値を参照するだけ

search_eax:
    ret

search_ecx:
    movl %ecx, %eax
    ret

search_edx:
    movl %edx, %eax
    ret

search_ebx:
    movl %ebx, %eax
    ret

search_esp:
    leal -0x4(%esp), %eax
    ret

search_ebp:
    movl %ebp, %eax
    ret

search_esi:
    movl %esi, %eax
    ret

search_edi:
    movl %edi, %eax
    ret

search_eip:
    movl (%esp), %eax
    subl $5, %eax
    ret

# アセンブラから呼び出す場合は36byteの領域を確保して、その領域への先頭ポインタをpushしてから呼び出す。(C言語ではREGS構造体のポインタ)
# search_regsによってその領域に値が詰められて、領域へのポインタがeaxに入って帰ってくるので、push eaxしてからprint_regsを呼び出す。

# test:
#     pushl %ebp
#     movl %esp, %ebp
#     subl $36, %esp
#     pushl %esp
#     call search_regs
#     addl $4, %esp
#     pushl %eax
#     call print_regs
#     addl $4, %esp
#     addl $36, %esp
#     leave
#     ret

search_regs:
    pushl %eax
    movl 0x8(%esp), %eax
search_regs_eip:
    movl 0x4(%esp), %ecx
    subl $5, %ecx
    movl %ecx, (%eax)
    addl $4, %eax
search_regs_edi:
    movl %edi, (%eax)
    addl $4, %eax
search_regs_esi:
    movl %esi, (%eax)
    addl $4, %eax
search_regs_ebp:
    movl %ebp, (%eax)
    addl $4, %eax
search_regs_esp:
    movl %esp, (%eax)
    addl $4, %eax
search_regs_ebx:
    movl %ebx, (%eax)
    addl $4, %eax
search_regs_edx:
    movl %edx, (%eax)
    addl $4, %eax
search_regs_ecx:
    movl %ecx, (%eax)
    addl $4, %eax
saerch_regs_eax:
    popl (%eax)
search_regs_end:
    movl 0x4(%esp), %eax
    ret
