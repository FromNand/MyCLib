#include<std.h>
#include<extern.h>

void print_section(){
    print("\n**** info about section addr *****\n");
    print("sphdr = %x, ephdr = %x\n", _sphdr, _ephdr);
    print("stext = %x, etext = %x\n", _stext, _etext);
    print("srodata = %x, erodata = %x\n", _srodata, _erodata);
    print("sdata = %x, edata = %x\n", _sdata, _edata);
    print("sctors = %x, ectors = %x\n", _sctors, _ectors);
    print("sdtors = %x, edtors = %x\n", _sdtors, _edtors);
    print("sbss = %x, ebss = %x\n", _sbss, _ebss);
    print("\n");
}
