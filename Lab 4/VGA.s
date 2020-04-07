    .text

	.equ PIXEL_buffer, 0xC8000000
	.equ CHARACTER_buffer, 0xC9000000

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM

	.equ PB_DATA, 0xFF200050
    .equ PB_INTR_MSK, 0xFF200058
    .equ PB_EDGE_CAP, 0xFF20005C

    .global read_PB_data_ASM
    .global PB_data_is_pressed_ASM
    .global read_PB_edgecap_ASM
    .global PB_edgecap_is_pressed_ASM
    .global PB_clear_edgecp_ASM
    .global enable_PB_INT_ASM
    .global disable_PB_INT_ASM
	
// VGA Application Test 
VGA_test:
        push    {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #8
.L6:
        bl      read_PB_data_ASM
        mov     r3, r0
        and     r3, r3, #15
        str     r3, [fp, #-8]
        ldr     r3, [fp, #-8]
        and     r3, r3, #1
        cmp     r3, #0
        beq     .Button0
        bl      test_byte
        b       .L6
.Button0:
        ldr     r3, [fp, #-8]
        and     r3, r3, #2
        cmp     r3, #0
        beq     .Button1
        bl      test_char
        b       .L6
.Button1:
        ldr     r3, [fp, #-8]
        and     r3, r3, #4
        cmp     r3, #0
        beq     .Button2
        bl      test_pixel
        b       .L6
.Button2:
        ldr     r3, [fp, #-8]
        and     r3, r3, #8
        cmp     r3, #0
        beq     .L6
        bl      VGA_clear_charbuff_ASM
        bl      VGA_clear_pixelbuff_ASM
        b       .L6
	
// convert test_char() funciton into assembly
test_char:
        push    {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #16
        mov     r3, #0
        strb    r3, [fp, #-13]
        mov     r3, #0
        str     r3, [fp, #-12]
        b       .L2
.L5:
        mov     r3, #0
        str     r3, [fp, #-8]
        b       .L3
.L4:
        ldrb    r3, [fp, #-13]  @ zero_extendqisi2
        add     r2, r3, #1
        strb    r2, [fp, #-13]
        mov     r2, r3
        ldr     r1, [fp, #-12]
        ldr     r0, [fp, #-8]
        bl      VGA_write_char_ASM
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
.L3:
        ldr     r3, [fp, #-8]
        cmp     r3, #79
        ble     .L4
        ldr     r3, [fp, #-12]
        add     r3, r3, #1
        str     r3, [fp, #-12]
.L2:
        ldr     r3, [fp, #-12]
        cmp     r3, #59
        ble     .L5
        nop
        sub     sp, fp, #4
        pop     {fp, pc}


// test_byte() function into assembly
test_byte:
        push    {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #16
        mov     r3, #0
        strb    r3, [fp, #-13]
        mov     r3, #0
        str     r3, [fp, #-12]
        b       .Link2
.Link5:
        mov     r3, #0
        str     r3, [fp, #-8]
        b       .Link3
.Link4:
        ldrb    r3, [fp, #-13]  @ zero_extendqisi2
        add     r2, r3, #1
        strb    r2, [fp, #-13]
        mov     r2, r3
        ldr     r1, [fp, #-12]
        ldr     r0, [fp, #-8]
        bl      VGA_write_byte_ASM
        ldr     r3, [fp, #-8]
        add     r3, r3, #3
        str     r3, [fp, #-8]
.Link3:
        ldr     r3, [fp, #-8]
        cmp     r3, #79
        ble     .Link4
        ldr     r3, [fp, #-12]
        add     r3, r3, #1
        str     r3, [fp, #-12]
.Link2:
        ldr     r3, [fp, #-12]
        cmp     r3, #59
        ble     .Link5
        nop
        sub     sp, fp, #4
        pop     {fp, pc}

// translate test_pixel() from c into assembly
test_pixel:
        push    {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #16
        mov     r3, #0
        strh    r3, [fp, #-14]  @ movhi
        mov     r3, #0
        str     r3, [fp, #-12]
        b       .B2
.B5:
        mov     r3, #0
        str     r3, [fp, #-8]
        b       .B3
.B4:
        ldrh    r3, [fp, #-14]
        add     r2, r3, #1
        strh    r2, [fp, #-14]  @ movhi
        mov     r2, r3
        ldr     r1, [fp, #-12]
        ldr     r0, [fp, #-8]
        bl      VGA_draw_point_ASM
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
.B3:
        ldr     r3, [fp, #-8]
        cmp     r3, #320
        blt     .B4
        ldr     r3, [fp, #-12]
        add     r3, r3, #1
        str     r3, [fp, #-12]
.B2:
        ldr     r3, [fp, #-12]
        cmp     r3, #239
        ble     .B5
        nop
        sub     sp, fp, #4
        pop     {fp, pc}


// set all valid memory locations in character buffer to 0
// inputs: none
VGA_clear_charbuff_ASM:
	
	PUSH {R0-R8,LR}				// store registers in use for recovery later
	MOV R0, #79 				// start x counter at 59
	MOV R1, #59					// start y counter at 79
	MOV R8, R1					// copy of y counter for inner loop reset
	LDR R2, =CHARACTER_buffer	// base address
	LDR R3, ZEROS				// get some zeros ready

CHAR_LOOP_O:
	CMP R0, #0
	BLT CHAR_END_CLEAR 	// Outer loop counter, looks at x address
	MOV R1, R8			// Reset inner loop

CHAR_LOOP_I:
	CMP R1, #0			// Inner loop, looks at y address
	SUBLT R0, R0, #1	// Decrement outer loop
	BLT CHAR_LOOP_O		// back to outer loop

	MOV R4, R1			// take y counter
	ROR R4, #25			// rotate y counter into correct position
	ORR R4, R2			// get base address in there
	ORR R4, R0 			// add in the x counter

	STRB R3, [R4] 		// store 0s into the location we determined
	SUB R1, R1, #1 		// decrement y counter
	B CHAR_LOOP_I

CHAR_END_CLEAR: 
	POP {R0-R8,LR}			// restore used registers
	BX LR 					// leave
	
// set all valid memory locations in pixel buffer to 0
// inputs: none
VGA_clear_pixelbuff_ASM:

	PUSH {R0-R8,LR}
	MOV R0, #300 			// start x counter at 319
	ADD R0, R0, #19				// immediate value structure can't handle 319, use addition instead
	MOV R1, #239			// start y counter at 239
	MOV R8, R1				// copy of y counter for inner loop reset
	LDR R2, =PIXEL_buffer	// base address
	LDR R3, ZEROS			// get some zeros ready

LOOP_OUTER:
		CMP R0, #0
		BLT END_CLEAR 		// Outer loop counter, looks at x address
		MOV R1, R8			// Reset inner loop

LOOP_INNER:
		CMP R1, #0			// Inner loop, looks at y address
		SUBLT R0, R0, #1		// Decrement outer loop
		BLT LOOP_OUTER		// back to outer loop

		MOV R4, R1			// take y counter
		ROR R4, #22			// rotate y counter into correct position
		ORR R4, R2			// get base address in there
		MOV R6, R0 			// make a copy of the x counter
		LSL R6, #1			// shift one digit left
		ORR R4, R6 			// add in the x counter

		STRH R3, [R4] 		// store 0s into the location we determined
		SUB R1, R1, #1 		// decrement y counter
		B LOOP_INNER

END_CLEAR: 
	POP {R0-R8,LR}			// restore used registers
	BX LR 					// leave


// write ASCII code passed in 3rd input
// store value of 3rd input at address calculated with first 2 inputs
// check that the supplied coordinates are valid
// inputs: R0 = x coordinate, R1 = y coordinate, R2 = ASCII code for char
VGA_write_char_ASM:

	PUSH {R0-R5, LR}			// save the registers we're about to use
	LDR R5, =CHARACTER_buffer	// base address

	CMP R0, #79				// check that x is within the allowed range
	BGT END_WRITE_CHAR
	CMP R0, #0
	BLT END_WRITE_CHAR
	CMP R1, #59				// check that y is within the allowed range
	BGT END_WRITE_CHAR
	CMP R1, #0
	BLT END_WRITE_CHAR

	MOV R4, R1			// take y value
	ROR R4, #25			// rotate y value into correct position
	ORR R4, R5			// get base address in there
	ORR R4, R0 			// add in the x value
	STRB R2, [R4]		// store the input value to the address

END_WRITE_CHAR:
	POP {R0-R5, LR}		// recover saved registers
	BX LR	 			// leave


// write hexadecimal representation of value passed in 3rd input
// this means that two characters are printed, starting at coordinates
// passed in through first 2 arguments
// inputs: R0 = x coordinate, R1 = y coordinate, R2 = byte to be written
VGA_write_byte_ASM:

	PUSH {R0-R5, LR}
	LDR R5, =CHARACTER_buffer

	CMP R0, #79			// check that x is within the allowed range
	BGT END_WRITE_BYTE
	CMP R0, #0
	BLT END_WRITE_BYTE
	CMP R1, #59			// check that y is within the allowed range
	BGT END_WRITE_BYTE
	CMP R1, #0
	BLT END_WRITE_BYTE

	// store first four bits in memory location indicated by input
	MOV R3, R2		// copy input into another register
	LSR R3, #4		// remove rightmost bits from input
	CMP R3, #10		// check if the hex digit is a letter or number
	ADDGE R3, R3, #55	// make it the appropriate ASCII letter
	ADDLT R3, R3, #48	// make it the appropriate ASCII number
	MOV R4, R1		// take y value
	ROR R4, #25		// rotate y value into correct position
	ORR R4, R5		// get base address in there
	ORR R4, R0 		// add in the x counter
	STRB R3, [R4]	// store the input value to the address

	ADD R0, R0, #1	// increment x address by 1 to go to next grid spot
	CMP R0, #79		// check if the x counter has reached the right side of the screen
	MOVGT R0, #0	// if yes, send x back to 0 (left side)
	ADDGT R1, #1	// if yes, increment y by 1
	CMP R1, #59		// check if the y counter has reached the bottom of the screen
	MOVGT R1, #0		// if yes, send y back to 0 (top)

	// store second four bits in memory location indicated by x and y
	MOV R3, #0xF	// get 1s in the last 4 bits
	AND R2, R3		// keep last four bits of input
	CMP R2, #10		// check if the hex digit is a letter or number
	ADDGE R2, R2, #55	// make it the appropriate ASCII letter
	ADDLT R2, R2, #48	// make it the appropriate ASCII number
	MOV R4, R1		// take y value
	ROR R4, #25		// rotate y value into correct position
	ORR R4, R5		// get base address in there
	ORR R4, R0 		// add in the x value
	STRB R2, [R4]	// store the input value to the address
	

END_WRITE_BYTE:
	POP {R0-R5, LR}	// recover saved registers
	BX LR			// leave
	

// draw a point on the screen with the indicated colour, accessing
// only pixel buffer memory
// similar to VGA_write_char_ASM
// inputs: R0 = x coordinate, R1 = y coordinate, R2 = colour
VGA_draw_point_ASM:

	PUSH {R0-R6, LR}
	LDR R5, =PIXEL_buffer

	MOV R3, #300 			// use R3 as comparison register
	ADD R3, R3, #19				// immediate value structure can't handle 319, use addition instead
	CMP R0, R3				// check that x is within the allowed range
	BGT END_DRAW_POINT
	CMP R0, #0 
	BLT END_DRAW_POINT
	CMP R1, #239			// check that y is within the allowed range
	BGT END_DRAW_POINT
	CMP R1, #0
	BLT END_DRAW_POINT

	MOV R4, R1			// take y value
	ROR R4, #22			// rotate y value into correct position
	ORR R4, R5			// get base address in there
	MOV R6, R0 			// make a copy of the x counter
	LSL R6, #1			// shift one digit left
	ORR R4, R6 			// add in the x counter
	STRH R2, [R4]		// store the input value to the address

END_DRAW_POINT:
	POP {R0-R6, LR}		// recover saved registers
	BX LR				// leave

ZEROS:	.word 0x0

// pushbutton drivers subroutine
read_PB_data_ASM:
        LDR R1, =PB_DATA
		LDR R0, [R1]
        BX LR

PB_data_is_pressed_ASM:				// R0 contains which button to check, hot-one encoding
		LDR R1, =PB_DATA	
		LDR R2, [R1]				// R2 holds the contents of the pushbutton register
		AND R2, R2, R0				// AND R2 and R0 to check if pushbutton register content corresponds to the button we want to check
		CMP R2, R0
		MOVEQ R0, #1				// True, if pressed
		MOVNE R0, #0				// False, if not pressed
		BX LR

read_PB_edgecap_ASM:
        LDR R1, =PB_EDGE_CAP
        LDR R0, [R1]
        BX LR

PB_edgecap_is_pressed_ASM:
        LDR R1, =PB_EDGE_CAP
        LDR R2, [R1]
		CMP R0, R2
		MOVEQ R0, #1
		MOVNE R0, #0
        BX LR

PB_clear_edgecp_ASM:
        LDR R1, =PB_EDGE_CAP
        STR R0, [R1]
        BX LR

enable_PB_INT_ASM:					// R0 contains which button to enable, hot-one encoding
		LDR R1, =PB_INTR_MSK
		STR R0, [R1]				// Storing button (one hot encoded) to Mask register enables that button
		BX LR

disable_PB_INT_ASM:
        LDR R1, =PB_INTR_MSK
        LDR R2, [R1]
        BIC R2, R2, R0
        STR R2, [R1]
        BX LR
