        .text
        .equ PB_DATA, 0xFF200050
        .equ PB_INTR_MSK, 0xFF200058
        .equ PB_EDGE_CAP, 0xFF20005C
        .global read_PB_data_ASM
        .global PB_data_is_pressed_ASM
        .global read_PB_edgecap_ASM
        .global PB_edgecap_is_pressed_ASM
        .global PB_clear_edgecp_ASM
        .global enable_PB_INT_ASM
        .global disable_PB_INT_ASM

read_PB_data_ASM:
        LDR R1, =PB_DATA
		LDR R0, [R1]
        BX LR

PB_data_is_pressed_ASM:				// R0 contains which button to check, hot-one encoding
		LDR R1, =PB_DATA	
		LDR R2, [R1]				// R2 holds the contents of the pushbutton register
		AND R2, R2, R0				// AND R2 and R0 to check if pushbutton register content corresponds to the button we want to check
		CMP R2, R0
		MOVEQ R0, #1				// True, if pressed
		MOVNE R0, #0				// False, if not pressed
		BX LR

read_PB_edgecap_ASM:
        LDR R1, =PB_EDGE_CAP
        LDR R0, [R1]
        BX LR

PB_edgecap_is_pressed_ASM:
        LDR R1, =PB_EDGE_CAP
        LDR R2, [R1]
		CMP R0, R2
		MOVEQ R0, #1
		MOVNE R0, #0
        BX LR

PB_clear_edgecp_ASM:
        LDR R1, =PB_EDGE_CAP
        STR R0, [R1]
        BX LR

enable_PB_INT_ASM:					// R0 contains which button to enable, hot-one encoding
		LDR R1, =PB_INTR_MSK
		STR R0, [R1]				// Storing button (one hot encoded) to Mask register enables that button
		BX LR

disable_PB_INT_ASM:
        LDR R1, =PB_INTR_MSK
        LDR R2, [R1]
        BIC R2, R2, R0
        STR R2, [R1]
        BX LR

        .end