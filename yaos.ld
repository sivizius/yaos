ENTRY (_init)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386:i386)
SECTIONS
{
  . = 0x00100000;
        
  .text :
  {
    *(.multiboot)
    *(.text)
    *(.rodata)
  }
  .data : 
  {
    *(.data)
  }
  .bss :
  {
    _sbss = .;
    *(COMMON)
    *(.bss)
    _ebss = .;
  }
}
