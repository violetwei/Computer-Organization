    .text
    .equ SW_BASE, 0xFF200040
    .global read_slider_switches_ASM

read_slider_switches_ASM:
    // read the value at the memory location designeated for the slider switches data into the R0 
    // then branch to the link register
    LDR R1, =SW_BASE
    LDR R0, [R1]
    BX LR

    .end