/* ELFヘッダや他の先頭の付属情報といったメタデータのサイズを多めに取ってある(PHDRはELFプログラムヘッダーの略??) */
/* _elf_header_sizeがreadelf -aのプログラムヘッダの部分のPHDRのファイルサイズとオフセットを足した値より大きければよさそう */

_elf_header_size = 0x1000;

MEMORY{
    PHDR   (r)  : ORIGIN = 0x8048000                       , LENGTH = _elf_header_size
    TEXT   (rx) : ORIGIN = ORIGIN(PHDR)   + LENGTH(PHDR)   , LENGTH = 0x4000 - _elf_header_size
    RODATA (r)  : ORIGIN = ORIGIN(TEXT)   + LENGTH(TEXT)   , LENGTH = 0x2000
    DATA   (rw) : ORIGIN = ORIGIN(RODATA) + LENGTH(RODATA) , LENGTH = 0x2000
    STORS  (r)  : ORIGIN = ORIGIN(DATA)   + LENGTH(DATA)   , LENGTH = 0x1000
    BSS    (rw) : ORIGIN = ORIGIN(STORS)  + LENGTH(STORS)  , LENGTH = 0x2000
}

SECTIONS{
    PROVIDE(_sphdr = ORIGIN(PHDR)); PROVIDE(_ephdr = ORIGIN(PHDR) + LENGTH(PHDR));
    .text   : { PROVIDE(_stext = .);   *(.text)   PROVIDE(_etext = .); }   > TEXT
    .rodata : { PROVIDE(_srodata = .); *(.rodata) PROVIDE(_erodata = .); } > RODATA
    .data   : { PROVIDE(_sdata = .);   *(.data)   PROVIDE(_edata = .); }   > DATA
    .stors  : { PROVIDE(_sctors = .);  *(.ctors*) PROVIDE(_ectors = .); 
                PROVIDE(_sdtors = .);  *(.dtors*) PROVIDE(_edtors = .); }  > STORS
    .bss    : { PROVIDE(_sbss = .);    *(.bss)    PROVIDE(_ebss = .); }    > BSS
}
