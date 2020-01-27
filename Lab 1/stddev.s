		.text
		.global _start

_start: 
		LDR R4, =RESULT   // R4 points to the result location
		LDR R2, [R4, #4]  // R2 holds the number of elements in the list
		ADD R3, R4, #8    // R3 points to the first number
		LDR R0, [R3]	  // R0 HOLDS MAXIMUM TERM
		LDR R5, [R3]	  // R5 HOLDS MINIMUN TERM

LOOP:	
		SUBS R2, R2, #1   // decrement loop counter
		BEQ DONE          // exit from loop if the counter has reached 0
		ADD R3, R3, #4    // R3 points to next number in the list
		B CHECKMAX        // branch to CHECKMAX

CHECKMAX:
		LDR R1, [R3]      // R1 holds the next number in the list
		CMP R0, R1        // check if R1 is greater than the maximum
		BGE CHECKMIN      // if R1 is not greater than R0, branch to CHECKMIN
		MOV R0, R1        // if R1 is greater than R0, update R0 (MAX TERM) to hold R1
		B LOOP            // branch to LOOP

CHECKMIN:
		CMP R1, R5        // check if R1 is greater than R5(MIN TERM)
		BGE LOOP          // if R1 is not smaller than R5, branch back to LOOP
		MOV R5, R1        // if R1 is smaller than R5, update R5 (MIN TERM) to hold R1
		B LOOP

DONE:  
		SUBS R0, R0, R5   // MAX - MIN, R0 holds the difference
		ASR R0, R0, #2    // divide difference by 4 - arithmetic shift the bits 2 places to the right and fill vacated bits with copies of most signicant bit
		STR R0, [R4]      // store the result to R0 

END: 
		B END

RESULT: 	.word 0       // memory assigned for the result
N:			.word 7       // number of entries in the list
NUMBERS:	.word 4,5,3,6 // list data
			.word 1,8,2
