# glibcのスタートアップ関数を真似して、自分でスタートアップ関数を作成した
# 実際のglibcの実装では、OSから情報をレジスタ渡しで受け取っており、そのデータをうまく__libc_start_mainに伝えるのが_startの役割に見える
# 実際の初期化処理などは主に__libc_start_mainで行われているようだ
# しかし今回は_startだけでスタートアップの処理をすべて行ってしまっているため、glibcの実際の実装とは異なる部分が多々ある
# 例えば、envpの初期化処理もそうだし、mainを呼び出すこともそうだし、exitで処理を終了することもそうだし、コンストラクタやデストラクタの処理についてもそうである

.code32

.extern main
.extern _sctors, _ectors, _sdtors, _edtors

.text

_start:                             # この関数は常にファイルの最初に書かなければならない (正確には.textのオフセット0に置かねばならない)
    xorl %ebp, %ebp                 # ebpをクリアしておく (x86のABIはこの処理を書くように勧めている。ebpを0に初期化することで、もっとも外側のスタックフレームだとわかるように (gdbなどが利用する？))
    call _constructors              # コンストラクタたちを呼び出す処理 (ただ、引数がvoidの関数しか呼べない...)
    popl %eax                       # スタックの頭にはargcが入っている
    movl %esp, %ecx                 # その次にはargv[0], argv[1]...が入っている (*argvは文字列の先頭を指すポインタの配列)
    leal 4(%ecx, %eax, 4), %edx     # argv + argc * (4 + 1)番地から環境変数のリストが入っている
    andl $0xfffffff0, %esp          # スタックに引数を積む前にアライメントを16byteの境界に揃える (SSE命令は16byteのアライメントに沿っていないデータにアクセスするとペナルティを受けるため)
    pushl %edx                      # &envp[0]を積む
    pushl %ecx                      # &argv[0]を積む
    pushl %eax                      # argcを積む
    call main                       # mainを呼び出す
    pushl %eax                      # mainからの戻り値をセーブする (eax, ecx, edxは関数呼び出しで書き換えられる可能性があるため)
    call _destructors               # デストラクタたちを呼び出す処理 (コンストラクタ同様に引数がvoidの関数しか呼べないが...)
    popl %eax                       # mainからの戻り値をポップする
    movl %eax, %ebx                 # mainの戻り値をexitの引数に取る (こいつがシステムへの返り値になり、'echo $?'で表示できる)
    movl $1, %eax                   # exitのシステムコール番号
    int $0x80                       # exitの呼び出し (これがないとプログラムが適切に終了しない)
    hlt                             # ここは訪れない。exitからなぜか帰ってきてしまった場合にプログラムをクラッシュするように置かれている。

_constructors:
    movl $_sctors, %eax
    movl $_ectors, %ecx
_constructors_loop:
    cmpl %eax, %ecx
    jbe _constructors_end
    pushl %eax
    pushl %ecx
    call *(%eax)
    popl %ecx
    popl %eax
    addl $4, %eax
    jmp _constructors_loop
_constructors_end:
    ret

_destructors:
    movl $_sdtors, %eax
    movl $_edtors, %ecx
_destructors_loop:
    cmpl %eax, %ecx
    jbe _destructors_end
    pushl %eax
    pushl %ecx
    call *(%eax)
    popl %ecx
    popl %eax
    addl $4, %eax
    jmp _destructors_loop
_destructors_end:
    ret
