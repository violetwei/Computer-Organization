         .text
         .global _start

_start:  LDR R4, =N        // R4 points to the N location
		 LDR R5, [R4]      // LOOP1 Counter
		 LDR R7, [R4]      // LOOP2 Counter
		
LOOP1:  SUBS R5, R5, #1   // reduce the outer loop (LOOP1) counter by one each time
        BEQ END           // if the LOOP1 counter reaches zero, program finished, go to END
        LDR R7, [R4]     
		ADD R2, R4, #4	  // get address of the first number
	    ADD R3, R4, #8	  // get address of the second number
	    LDR R0, [R2]	  // store the first number in R0
	    LDR R1, [R3]	  // store the second number in R1
		SUBS R7, R7, #1   // reduce the inner loop (LOOP2) counter by one each time
		CMP R0, R1        // check if R0 is greater than R1
		BGE SWAP          // branch to SWAP

LOOP2:  SUBS R7, R7, #1   // decrement LOOP2 counter
		BEQ  LOOP1        // branch to LOOP1
		ADD R2, R2, #4    // R2 points to next number in the list
		ADD R3, R3, #4
		LDR R0, [R2]      // R0 holds A[i]
		LDR R1, [R3]      // R1 holds A[i-1]
		CMP R0, R1        // if A[i] < A[i-1], SWAP
		BGE SWAP          // branch to SWAP
 		B LOOP2           // go back to loop

SWAP:   MOV R6, R1     // move the second value to a register holding its value (swap)
        MOV R1, R0     // move first value to the second register (swap)
        MOV R0, R6     // move the holding value to first register (swap)
		STR R0, [R2]   // store the value of R2 to R0
		STR R1, [R3]   // store the value of R3 to R1
        B LOOP2        // branch back to LOOP2

END:		B END      // infinite loop

		
N: 		    .word	7			
NUMBERS:	.word	4, 5, 3, 6	
		    .word	1, 8, 2
