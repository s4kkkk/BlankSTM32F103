OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

MEMORY {
    ROM (rx): ORIGIN = 0x08000000, LENGTH = 64K
    RAM (rw): ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS {

    /* таблица векторов прерываний в самое начало ROM */
    .isr_vector_table ORIGIN(ROM): { 
        KEEP(*(.isr_vector_table));
    } > ROM

    /* затем сразу поместить секцию .rodata (константы, ..) */
    .rodata : { 
        *(.rodata*)
    } > ROM

    /* секция с кодом */
    .text ALIGN(4): { 
        *(.text*)
    } > ROM

    /* область ROM, куда будет загружены данные, которые должны попасть в RAM */
    .data_rom ALIGN(4): { 
        PROVIDE(__data_rom__ = .);
        . += SIZEOF(.data);
    }

    /* установить указатель на RAM. далее все секции будут с RAM VMA */
    . = ORIGIN(RAM); 

    /* bss-секция в RAM */
    .bss ALIGN(4) (NOLOAD): {
        PROVIDE(__bss_start__ = .);
        *(.bss*);
        PROVIDE(__bss_end__ = .);
    }

    /* Секция RAM с LMA, указывающим в ROM */
    .data ALIGN(4): AT(ADDR(.data_rom)) { 
        PROVIDE(__data_start__ = .);
        *(.data*);
        PROVIDE(__data_end__ = .);
    }
    PROVIDE(_end = .);

}