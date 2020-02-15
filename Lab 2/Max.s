		.text
		.global _start

_start: LDR R0, =NUMBERS    // R0 points to the NUMBERS location
		LDR R1, =N          // R1 points to the N location
		LDR R4, [R1]        // R4 holds the value of N -- COUNTER
		PUSH {R0, R1, LR}   // push registers onto stack
		BL SUBROUTINE       // branch to the subroutine
		LDR R0, [SP, #4]    // R0 holds value [[SP] + 4] (4 bytes from SP)
		STR R0, MAX         // store the value of MAX to R0
		LDR LR, [SP, #8]    // LR holds value [[SP] + 8]
		ADD SP, SP, #12     // clean up the stack to do the calculation

STOP: B STOP

SUBROUTINE:	PUSH {R0-R3}        // push R0 to R3 onto stack
			LDR R1, [SP, #20]   // R1 holds the value [[SP] + 20]
			LDR R2, [SP, #16]   // R2 holds the value [[SP] + 16]
			MOV R0, #0          // R0 holds the return value

MAXIMUM:	SUBS R4, R4, #1     // decrement COUNTER
			BEQ DONE            // exit from loop if the counter has reached 0
			LDR R3, [R2], #4
			CMP R0, R3          // check if R3 is greater than R0
			BGE MAXIMUM
			MOV R0, R3
			B MAXIMUM

DONE: 		STR R0, [SP,#20]  
			POP {R0-R3}       // pop R0 to R3 off the stack
			BX LR             // return to calling code


NUMBERS:	.word 4,5,3,6
			.word 1,8,2,-100
N:			.word 8
MAX:		.space 4
	