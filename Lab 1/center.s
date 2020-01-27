		.text 
		.global _start
_start: 
		LDR R2,	=N          // R2 points to the N location
		LDR R3, =NUMBERS    // R3 points to the NUMBERS location
		MOV R1, R3	        // R1 is POINTER FOR THE FIRST ELEMENT
		LDR R5, [R2]        // R5 is POINTER FOR THE COUNTER
		LDR R0, [R3]		// TOTAL SUM (R0 holds first number in list initially)

SUM:
		SUBS R5, R5, #1     // decrement the loop COUNTER
		BEQ DONE            // end loop if COUNTER has reached 0, branch to DONE
	    ADD R1, R1, #4      // R1 points to the next number in the list - index
		LDR R4, [R1]        // R4 holds the next number in the list - value
		ADD R0, R0, R4      // add R4 to the TOTAL SUM register R0 
		B SUM               // branch back to loop

	
DONE:	MOV R6, #0			// shifting number, R6 is divider
		LDR R5, [R2]        // R5 holds the value of N

LOG:	CMP R5, #1			// check if COUNTER is 1
		BEQ AVER            // if yes, branch to AVER
		ASR R5, R5, #1      // arithmetic shift the bits 1 places to the right and fill vacated bits with copies of most signicant bit
		ADD R6, R6, #1      // increment divider
		B LOG               // branch back to LOG

AVER:
		ASR R0, R0, R6      // divide by 2^(value of R6) - arithmetic shift the value of R0 (value of R6) places to the right
		MOV R1, R3          // update R1 to hold R3
		LDR  R5, [R2]       // R5 holds the value of N, COUNTER
		B CENTER            // branch to CENTER

CENTER: 
		LDR  R7, [R1]       // R7 holds the value of R1 (the next number in the list)
		SUB  R7, R7, R0     // R7 holds num - average
		STR  R7, [R3]	    // store the value of R3 to R7
		ADD  R3  R3, #4     // R3 points to next number in the list
		ADD  R1, R1, #4     // R1 points to the next number in the list - index
		SUBS  R5, R5, #1    // decrement the COUNTER
		BEQ END             // branch to END if COUNTER has reached 0
		B CENTER            // branch back to the loop
		
END:	B END               // infinite loop

N:			.word 7         // number of entries in the list
NUMBERS:	.word 4,5,3,6   // list data
			.word 1,8,2
