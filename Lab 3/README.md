# Lab 3

This lab introduces the basic I/O capabilities of the DE1-SoC computer - the slider switches, push-buttons, LEDs and 7-Segment displays. After writing assembly drivers that interface with the I/Ocomponents, timers and interrupts are used to demonstrate polling and interrupt based applications written in C.

## 2 Basic I/O

The hardware setup of the I/O components is fairly simple to understand. The ARM cores havedesignated addresses in memory that are connected to hardware circuits on the FPGA, and these hardware circuits in turn interface with the physical I/O components. In the case of most of the basic I/O, the FPGA hardware can be as simple as a direct mapping from the I/O terminals to the memory address designated to it. For instance, the state of the slider switches is available to the FPGA on bus of 10 wires which carry either a logical ’0’ or ’1’. This bus can be directly passed as ’write-data’ to the memory address reserved for the slider switches(0xFF200040 in this case)

It is useful to have slightly more sophisticated FPGA hardware.  For instance, in the case of thepush-buttons, in addition to knowing the state of the button it is also helpful to know whether a falling edge is detected, signalling a keypress.  This can be achieved by a simple edge detection cir-cuit in the FPGA. The FPGA hardware to interface with the I/O is part of the De1-SoC computer, and is loaded when the .sof file is flashed onto the board. This section will deal with writing assembly code to control the I/O interact by reading from and writing to memory.

## 3 Timers
Timers are simply hardware counters that are used to measure time and/or synchronize events. They run on a known clock frequency that is programmable in some cases (by using a phase-lockedloop). Timers are usually (but not always) down counters, and by programming the start value, the time-out event (when the counter reaches zero) occurs at fixed time intervals.

### Creating an application: Stopwatch!
Create a simple stopwatch using the HPS timers, pushbuttons, and HEX displays.  The stopwatch should be able to count in increments of 10 milliseconds. Use a single HPS timer to count time. Display milliseconds on HEX1-0, seconds on HEX3-2, and minutes on HEX5-4.

PB0, PB1, and PB2 will be used to start, stop and reset the stopwatch respectively. Use another HPS timer set at a faster timeout value (5 milliseconds or less) to poll the push button edgecapture register.

## 4 Interrupts
Interrupts are hardware or software signals that are sent to the processor to indicate that an event has occurred that needs immediate attention. When the processor receives an interrupt, it pauses the current code execution, handles the interrupt by executing code defined in an Interrupt Service Routine (ISR), and then resumes normal execution.

Apart  from  ensuring  that  high  priority  events  are  given  immediate  attention, interrupts also help the processor to utilize resources more efficiently.  Consider the polling application from the previous section, where the processor periodically checked the push buttons for a keypress event. Asynchronous events such as this, if assigned an interrupt, can free the processors time and use it only when required.
