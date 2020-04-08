
## Brief overview of the De1-SoC computer VGA interface

The VGA controller hardware has already been introduced in the ECSE 222 labs. The De1-So Ccomputer has a built in VGA controller, and the data displayed to the screen is acquired from two sections in the FPGA on-chip memory - the pixel buffer and the character buffer- which are described in sufficient detail in section 4.2.1 and 4.2.3 of the De1-SoC Computer Manual. 

For this lab, it is notrequired to make use of thed ouble buffering feature described in the manual. 

### VGA driver
Create an assembly files VGA.s where you will write the required subroutines and functions. You are required to write 5 subroutines:
- 1.VGAclearcharbuffASM
- 2.VGAclearpixelbuffASM
- 3.VGAwritecharASM
- 4.VGAwritebyteASM
- 5.VGAdrawpointASM

The subroutines VGA_clear_charbuff_ASM and VGA_clear_pixelbuff_ASM should clear (set to 0) all the valid memory locations in the character buffer and pixel buffer, respectively. Note that these two subroutine do not have any input/output arguments.

The subroutine VGA_writechar_ASM should write the ASCII code passed in the third argument(R2) to the screen at the (x,y) coordinates given in the first two arguments (R0andR1). Essentially,the subroutine will store the value of the third argument at the address calculated with the first two arguments. The subroutine should check that the coordinates supplied are valid (i.e. x = [0,79] andy = [0,59]).

The subroutine VGA_writebyte_ASM should write the hexadecimal representation of the value passed in the third argument to the screen. This means that this subroutine will print two characters to the screen! (For example, passing a value of 0xFF in byte should result in the characters ’FF’ being displayed on the screen starting at the (x,y) coordinates passed in the first two arguments). Again, check that the (x,y) coordinates are valid, taking into account that two characters will be displayed.

Finally, the VGA_drawpoint_ASM subroutine will draw a point on the screen with the colour as indicated in the third argument, by accessing only the pixel buffer memory. This subroutine is verysimilar to the VGA_writechar_ASM subroutine

