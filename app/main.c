#include<std.h>
//#include<string.h>
#include<search_regs.h>
#include<extern.h>

unsigned int popcnt(unsigned int x){
    x = (x & 0x55555555) + (x >> 1 & 0x55555555);
    x = (x & 0x33333333) + (x >> 2 & 0x33333333);
    x = (x & 0x0f0f0f0f) + (x >> 4 & 0x0f0f0f0f);
    x = (x & 0x00ff00ff) + (x >> 8 & 0x00ff00ff);
    x = (x & 0x0000ffff) + (x >> 16 & 0x0000ffff);
    return x;
}

// argcは実行形式のファイル名を含めた引数の数
// argv・envpはそれぞれ文字列の先頭へ向けたポインタの配列で、最後の要素の次の要素にはNULLが格納されている
// argvは特にargv[argc-1]が最後の要素を指す
int main(int argc, char *argv[], char *envp[]){
// デバッグ情報を表示するかどうかを_SHOW_DEBUG_INFOマクロが定義されているかどうかで判断する
#define _SHOW_DEBUG_INFO
#ifdef _SHOW_DEBUG_INFO
    // REGS構造体の使い方
    print("\n\n***** DISPLAY REGISTERS *****\n");
    REGS regs;
    search_regs(&regs);
    print_regs(&regs);
    print("\n\n");

    // argcの表示
    print("***** DISPLAY ARGC *****\n");
    print("argc = %d\n\n", argc);
    print("\n\n");

    // argvの表示
    print("***** DISPLAY ARGV *****\n");
    for(int i = 0; argv[i]; i++){
        print("argv[%d] = %s\n", i, argv[i]);
    }
    print("\n\n");

    // envpの表示
    print("***** DISPLAY ENVP *****\n");
    for(int i = 0; envp[i]; i++){
        print("envp[%d] = %s\n", i, envp[i]);
    }
    print("\n\n");
#endif

    // while実験用の変数
    unsigned int i, j, k;

    // まず、HelloWorld
    while(print("HelloWorld\n"), 0);

    // ピザってi回言ってみて
    i = 4;
    while(print(i >= 1 ? "pizza " : "\n"), i--);

    // iの階乗を計算する
    i = 10, j = 1;
    while(i >= 1 && (j *= i--));
    print("%d\n", j);

    // iの階乗を表示する
    i = 10, j = 1;
    while(i >= 1 ? j *= i-- : (print("%d\n", j), 0));

    // fizzbuzzの表示 (i~jまで)
    i = 1, j = 50;
    while(i <= j ? (i % 15 == 0 ? print("fizzbuzz "), i++ : (i % 5 == 0 ? print("buzz "), i++ : (i % 3 == 0 ? print("fizz "), i++ : (print("%d ", i), i++)))) : (print("\n"), 0));
   
    // iを2進数にして表示する
    i = 0x12345678, j = 32;
    while(--j < 32 ? (print("%d%s", i >> j & 0b1, j % 8 == 0 ? " " : ""), 1) : (print("\n"), 0));

    print("%d\n", popcnt(17));

    return 0;
}
