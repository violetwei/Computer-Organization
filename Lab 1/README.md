# Lab 1: Introduction to ARM Programming

In this lab, learn how to work with an ARM processor and the basics of ARM assemblyby programming some common routines. 

## Working with the DE1-SoC Computer System
For this course, we will be working with the DE1-SoC Computer System, 
which is composed of anARM Cortex-A9 processor and peripheral components located on the FPGA on your DE1-SoC board.
The IDE we will be using is the Intel FPGA Monitor Program 16.1.  
In this part of the lab, you will learn how to program the Computer System in ARM assembly.

## Some programming challenges
### 1) Fast standard deviation computation
Suppose that you would like to use the ARM processor to compute the standard deviation of a signal. 
The formula for the standard deviation is [here](https://www.mathsisfun.com/data/standard-deviation-formulas.html).

Unfortunately, implementing this formula requires multi-plication, division, and square root operations, 
which are not available as instructions on all proces-sors and are slow to emulate using other instructions. 
The standard deviation can be approximately computed in a more hardware-friendly way using the so-called “range rule”, where xmax and xmin are the maximum value and minimum value of the signal, respectively.

Write an ARM assembly program which computes the standard deviation of a signal, using the range rule.  
The program should accept input values - more specifically, the number of samples inthe signal and their values 
- using a similar approach as shown in Part 1.  Save your code in a filenamed ‘stddev.s’

(Hint:you can reuse your code from Part 1 to compute the maximum value.  
Then, you can makea simple modification to this code to get code which computes the minimum.  
Also, remember that dividing by a power of 2 can be implemented using shift instructions.)


### 2) Centering an array
It is often necessary to ensure that a signal is “centered” (that is, its average is 0).  
For example,DC signals can damage a loudspeaker, so it is important to center an audio signal to remove DCcomponents before sending the signal to the speaker.
You can center a signal by calculating the average value of the signal and subtracting the aver-age from every sample of the signal.  
Write an ARM assembly program to center a signal.  
In this example, store the resulting centered signal ‘in place’ - i.e. in the same memory location that theinput signal is passed in. 

The program should be able to accept the signal length as an input param-eter. 
In order to simplify calculations, work with the assumption that only signal lengths thatare powers of two can be passed to the program. 
Save your code in a file named ‘center.s

### 3) Sorting
Write an ARM assembly program which sorts an array in ascending order. 
You could use the simple bubble sort algorithm:
You could also implement a more sophisticated sorting algorithm.  
Store the resulting sorted array‘in place’. The program should be able to accept the array length as an input parameter. 
Save yourcode in a file named ‘sort.s
