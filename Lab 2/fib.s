		.text
		.global _start

_start:	LDR R0, =N       // R0 points to the N location
		LDR R1, [R0]     // R1 holds the value of N
		LDR R2, [R0,#4]  // load the value [[R0] + 4] into register R2
		PUSH {R1-R2,LR}  // push R1 to R2 and LR onto stack
		BL FIB           // call the subroutine (FIB)
		STR R2, RESULT   // R2 points to the result location
		POP {R1-R2, LR}
		B END             

FIB:	PUSH {R1, R2, LR}
		CMP R1,#2         // check if value of R1 is greater than 2
		BLT LESS          // branch to LESS if n < 2
		SUB R1, R1, #1    // decrement 1
		BL FIB            // call the subroutine (FIB) 

		LDR R1, [SP]      // R1 holds value of SP
		SUB R1, R1, #2    // n-2
		BL FIB            // call the subroutine (FIB)

		POP {R1, R2, LR}  // pop R1 R2 LR off the stack
		LDR R1,[SP]
		STR R2,[SP,#4]
		BX LR             // return to the calling code

LESS:	POP {R1, R2, LR}
		ADD R2, R2, #1    // add 1 to the result
		STR R2, [SP, #4]
		STR R2, [SP, #16]
		BX LR             // return to the calling code

END: 	B END 

N:		 .word 10         // calculate fib(10)
Result:  .space 4 

// LR is used to store the return program counter (PC) 
// when a subroutine or function is called