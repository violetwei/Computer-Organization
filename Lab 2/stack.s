		.text
		.global _start

_start:	LDR R4, =N       // R4 points to the N location
		LDR R2, [R4]     // LOOP COUNTER
		ADD R3, R4, #4   // R3 points to the first number in the list

LOOP:	SUBS R2, R2, #1  // decrement loop COUNTER
		BEQ DONE         // exit from loop if COUNTER has reached 0
		LDR R0, [R3]     // R0 holds the value of R3
		STR R0, [SP] 
		ADD R3, R3, #4   // R3 points to next number in the list
		SUBS SP, SP, #4  
		LDR R0, [R3]
		STR R0, [SP]     
		B LOOP           // branch back to LOOP

DONE:	LDR R0, [SP]     // pop top value of stack to R0
		ADD SP, SP, #4   // SP points to next number
		LDR R1, [SP]     // pop the value of stack to R1
		ADD SP, SP, #4   // SP points to next number

END: 	B END           // infinite loop

N:		.word 2         // number of entries in the list
NUMBERS:.word 3,4       // list data

// stack: Last In First Out (LIFO)