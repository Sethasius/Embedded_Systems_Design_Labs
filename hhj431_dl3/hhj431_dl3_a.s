.data
.align 2		@ Sets up for 2^2 byte address locations.
				@ 4-byte = 32-bit addressable data.

@ uint32_t	a,b,c;
@ Implements the variables above in memory
@ Uses 0 to initialize
a: .word 0
b: .word 0
c: .word 0

.text

.global _start
_start:
@ ===============================================================================
@ DL3. A. If Equals

@ 	Write the A32 assembly language program to implement the following C language 
@ program snippet.

@ uint32_t        a,b,c;
@ if (a == 0xDEADBEEF) a=0x8BADF00D;

@ Register Format:
@ r0: Holds address to "a"
@ r1: Used to represent the literal value of "a", allows for directly checking 
@	  with CMP.
@ r2: Holds the value "0xDEADBEEF" to be used in if statement
@ r3: Holds the value "0x8BADF00D" to be used in if statement
@ ===============================================================================
	@ Used for if conditional
	MOVW r2, #0xBEEF	@ Moves 0xF00D into bottom half of word in r1
	MOVT r2, #0xDEAD	@ Moves 0x8BAD into top half of word in r1
	MOVW r3, #0xF00D	@ Moves 0xF00D into bottom half of word in r1
	MOVT r3, #0x8BAD	@ Moves 0x8BAD into top half of word in r1
	
	@ Makes a = 1
	LDR r0, =a			@ Sets address to "a" in r0
	MOV r1, #1
	STR r1, [r0]
	BL 	if_equal
	
	@ Makes a = 0xDEADBEEF
	LDR r0, =a			@ Sets address to "a" in r0
	MOVW r1, #0xBEEF	@ Moves 0xBEEF into bottom half of word in r1
	MOVT r1, #0xDEAD	@ Moves 0xDEAD into top half of word in r1
						@ Must be used after MOVW otherwise r1 is overwritten
	STR r1, [r0]
	BL 	if_equal

	@ Exit program
	mov r0, #0
	mov r7, #1
	svc #0
	
.global if_equal
.type if_equal, %function
if_equal:
	CMP r1, r2		@ Compares a with 0xDEADBEEF
	BXNE lr
	STR r3, [r0]
	BX lr
	