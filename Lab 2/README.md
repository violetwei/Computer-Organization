# Lab 2
In this lab, you will learn how to use subroutines and the stack, program in C, and call code writtenin assembly from code written in C.

## Subroutines

### 1.1 The stack
The stack is a data structure which can be helpful for situations when there are not enough registers for a program to use only registers to store data. You will also need to make use of the stack when calling subroutines to save the state of the code outside of the subroutine. 

Review how the PUSH  and  POP instructions work. Note that pushing and popping can be implemented without using the PUSH and POP instructions by using other ARM instructions. Rewrite the following PUSH and POP instructions using only other instructions:
- PUSH {R0}
- POP {R0 - R2}

Write a test program in assembly to show that your rewritten versions correctly implement PUSH and POP. You should be able to show the TA the contents of main memory changing as registers arepushed onto the stack.

### 1.2 The subroutine calling convention
The convention which we will use for calling a subroutine in ARM assembly is as follows.

The caller must:
- Move arguments into R0 through R3.  (If more than four arguments are required, the caller should push the arguments onto the stack.)
- Call the subroutine using BL

The callee must
- Move the return value into R0
- Ensure that the state of the processor is restored to what it was before the subroutine call
- Use BX LR to return to the calling code

(The state can be saved and restored by pushing R4 through LR onto the stack at the beginning of the subroutine and popping R4 through LR off the stack at the end of the subroutine.)

Convert your program from Lab 1 for finding the max of an array into a program which uses a subroutine. The subroutine should return the max in R0.

### 1.3  Fibonacci calculation using recursive subroutine calls
A recursive subroutine is a subroutine which calls itself. You can calculate the nth Fibonacci number,Fn (where F0 = 1, F1 = 1, F2 = 2, F3 = 3, F4 = 5, . . . ), using a recursive subroutine as follows:
