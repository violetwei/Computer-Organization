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
        PUSH    {R11, LR}
        ADD     R11, SP, #4
        SUB     SP, SP, #8

Start:
        // 0xF & read_PB_data_ASM() - keep all 4 key digits
        BL      read_PB_data_ASM
        MOV     R3, R0
        AND     R3, R3, #15
        STR     R3, [R11, #-8] // 0xF & read_PB_data_ASM()
        // if first button (PushButton 0) is pressed (0x1)
        LDR     R3, [R11, #-8] // 0xF & read_PB_data_ASM()
        AND     R3, R3, #1  // 0x1
        CMP     R3, #0
        BEQ     Button1
        // Branch with Link to subroutine test_byte
        BL      test_byte
        B       Start

Button1:
        // if second key (PushButton 1) is pressed (0x2)
        LDR     R3, [R11, #-8] // 0xF & read_PB_data_ASM()
        AND     R3, R3, #2  // 0x2
        CMP     R3, #0
        BEQ     Button2
        // Branch with Link to subroutine test_char
        BL      test_char
        B       Start

Button2:
        // if third key (PushButton 2) is pressed (0x4)
        LDR     R3, [R11, #-8] // 0xF & read_PB_data_ASM()
        AND     R3, R3, #4 //0x4
        CMP     R3, #0
        BEQ     Button3
        // Branch with Link to subroutine test_pixel
        BL      test_pixel
        B       Start

Button3:
        // if the fourth key (PushButton 3) is pressed (0x8)
        LDR     R3, [R11, #-8] // 0xF & read_PB_data_ASM()
        AND     R3, R3, #8 // 0x8
        CMP     R3, #0
        BEQ     Start
        // Branch with Link to subroutine VGA_clear_charbuff_ASM, VGA_clear_pixelbuff_ASM
        BL      VGA_clear_charbuff_ASM
        BL      VGA_clear_pixelbuff_ASM
        B       Start
	
// convert test_char() funciton into assembly
test_char:
        PUSH {R0-R8, LR}
		MOV R0, #0 // x
		MOV R1, #0 // y
		MOV R2, #0 // c
		
write_char_inner:
        BL VGA_write_char_ASM
		ADD R0, R0, #1 // x++
		ADD R2, R2, #1 // c++
		CMP R0, #80 // check if reached right edge of screen
		BGE write_char_outer
		B write_char_inner
		
write_char_outer:
        MOV R0, #0 // reset x for the next row
		ADD R1, R1, #1 // next row
		CMP R1, #60 // check if reached bottom edge of screen
		BGE write_char_finish
		B write_char_inner
		
write_char_finish:
        POP {R0-R8, LR}
		BX LR

// test_byte() function into assembly
/*
test_byte:
        PUSH {R0-R8, LR}
		MOV R0, #0 // x
		MOV R1, #0 // y
		MOV R2, #0 // c
		
write_byte_inner:
        BL VGA_write_byte_ASM
		ADD R0, R0, #3 // x++
		ADD R2, R2, #1 // c++
		CMP R0, #80 // check if reached right edge of screen
		BGE write_byte_outer
		B write_byte_inner
		
write_byte_outer:
        MOV R0, #0 // reset x for the next row
		ADD R1, R1, #1 // next row
		CMP R1, #60 // check if reached bottom edge of screen 
		BGE write_byte_finish
		B write_byte_inner
		
write_byte_finish:
        POP {R0-R8, LR}
		BX LR
*/

test_byte:
        PUSH    {R11, LR}
        ADD     R11, SP, #4
        SUB     SP, SP, #16
        MOV     R3, #0
        STRB    R3, [R11, #-13]
        MOV     R3, #0
        STR     R3, [R11, #-12]
        B       Outer_Loop

begin_test_byte:
        MOV     R3, #0 // reset to 0
        STR     R3, [R11, #-8]
        B       Inner_Loop

write_byte_process:
        LDRB    R3, [R11, #-13]  
        ADD     R2, R3, #1
        STRB    R2, [R11, #-13]
        MOV     R2, R3
        LDR     R1, [R11, #-12]
        LDR     R0, [R11, #-8]
        BL      VGA_write_byte_ASM
        LDR     R3, [R11, #-8]
        ADD     R3, R3, #3
        STR     R3, [R11, #-8]

Inner_Loop:
        LDR     R3, [R11, #-8]
        CMP     R3, #79 // check x if reached right edge of screen
        BLE     write_byte_process
        LDR     R3, [R11, #-12]
        ADD     R3, R3, #1
        STR     R3, [R11, #-12]

Outer_Loop:
        LDR     R3, [R11, #-12]
        CMP     R3, #59 // check y if reached bottom edge of screen 
        BLE     begin_test_byte
        SUB     SP, R11, #4
        POP     {R11, PC}

// translate test_pixel() from c into assembly
test_pixel:
        PUSH {R0-R8, LR}
		MOV R0, #0 // x
		MOV R1, #0 // y
		MOV R2, #0 // color
		MOV R3, #320 // 320
		
draw_pixel_inner:
        BL VGA_draw_point_ASM
		ADD R0, R0, #1 // x++
		ADD R2, R2, #1 // color++
		CMP R0, R3 // check if reach the right edge of the screen
		BGE draw_pixel_outer
		B draw_pixel_inner
		
draw_pixel_outer:
        MOV R0, #0 // reset x
		ADD R1, R1, #1 // next row
		CMP R1, #240 // check if reach the bottom edge of screen
		BGE draw_pixel_finish
		B draw_pixel_inner
		
draw_pixel_finish:
        POP {R0-R8, LR}
		BX LR


// set all valid memory locations in character buffer to 0
// no input/output arguments
VGA_clear_charbuff_ASM:
	
	PUSH {R0-R8, LR}			// store registers in use for recovery later
	MOV R0, #79 				// start x counter at 59
	MOV R1, #59					// start y counter at 79
	MOV R8, R1					// copy of y counter for inner loop reset
	LDR R2, =CHARACTER_buffer	// base address
	LDR R3, ZEROS				// get some zeros ready

Char_Outer_Loop:
	CMP R0, #0
	BLT Char_End_Clear 	// Outer loop counter, looks at x address
	MOV R1, R8			// Reset inner loop - x counter

Char_Inner_Loop:
	CMP R1, #0			// Inner loop, looks at y address
	SUBLT R0, R0, #1	// Decrement outer loop
	BLT Char_Outer_Loop	// back to outer loop

	MOV R4, R1			// y counter
	ROR R4, #25			// rotate y counter into correct position
	ORR R4, R2			// get base address in there
	ORR R4, R0 			// add in the x counter

	STRB R3, [R4] 		// store 0s into the location we determined
	SUB R1, R1, #1 		// decrement y counter
	B Char_Inner_Loop

Char_End_Clear: 
	POP {R0-R8,LR}			// restore used registers
	BX LR 					// leave
	
// set all valid memory locations in pixel buffer to 0
// no input/output arguments
VGA_clear_pixelbuff_ASM:

	PUSH {R0-R8,LR}
	MOV R0, #300 			// start x counter at 319
	ADD R0, R0, #19				// immediate value structure can't handle 319, use addition instead
	MOV R1, #239			// start y counter at 239
	MOV R8, R1				// copy of y counter for inner loop reset
	LDR R2, =PIXEL_buffer	// base address
	LDR R3, ZEROS			// get some zeros ready

Outer_Loop_Clear:
		CMP R0, #0
		BLT End_Clear 		// Outer loop counter, at x address
		MOV R1, R8			// Reset inner loop

Inner_Loop_Clear:
		CMP R1, #0			// Inner loop, at y address
		SUBLT R0, R0, #1		// Decrement outer loop
		BLT Outer_Loop_Clear	// back to outer loop

		MOV R4, R1			// take y counter
		ROR R4, #22			// rotate y counter into correct position
		ORR R4, R2			// get base address in there
		MOV R6, R0 			// make a copy of the x counter
		LSL R6, #1			// shift one digit left
		ORR R4, R6 			// add in the x counter

		STRH R3, [R4] 		// store 0s into the location we determined
		SUB R1, R1, #1 		// decrement y counter
		B Inner_Loop_Clear

End_Clear: 
	POP {R0-R8,LR}			// restore registers
	BX LR 					


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
