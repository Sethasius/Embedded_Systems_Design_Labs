.data
.align 2		@ Sets up for 2^2 byte address locations.
				@ 4-byte = 32-bit addressable data.

@ uint32_t	a,b,c;
@ Implements the variables above in memory
a: .word 1		@ a set to 1, to be compared to 0 and 2
b: .word 0		@ Will be set to 0 then 2 respectively
c: .word 0

.text

.global _start
_start:
@ ===============================================================================
@ DL3. C. If A Greater Than or Equal to B

@ 	Write the A32 assembly language program to implement the following C language 
@ program snippet.

@ uint32_t        a,b,c;
@ if (a >= b)
@    c=0xAAAABBBB;
@ else
@    c=0xBBBBAAAA;

@ Register Format:
@ r0: Holds address to "a", then the value of "a"
@ r1: Holds address to "b", then the value of "b"
@ r2: Holds address to "c"
@ r3: Temp variable, used to set "c" in function
@ ===============================================================================
	MOV r3, #1
	BL var_a_setter
	MOV r3, #0
	BL var_b_setter
	@ "a" and "b" intially set
	BL 	if_greater_equal_else
	
	
	MOV r3, #2
	BL var_b_setter
	BL 	if_greater_equal_else

	@ Exit program
	mov r0, #0
	mov r7, #1
	svc #0
	
.global if_greater_equal_else
.type if_greater_equal_else, %function
if_greater_equal_else:
	CMP r0, r1
	LDR r2, =c
	MOVWHS	r3, #0xBBBB
	MOVTHS	r3, #0xAAAA
	MOVWLO	r3, #0xAAAA
	MOVTLO	r3, #0xBBBB
	str r3, [r2]
	BX lr

@ Each variable setter accepts a value in r3 that is loaded into the memory
@ of each variable, as well as the register that will be used.
.global var_a_setter
.type var_setter, %function
var_a_setter:
	LDR r0, =a
	STR r3, [r0]
	LDR r0, [r0]
	BX lr

.global var_b_setter
.type var_setter, %function
var_b_setter:
	LDR r1, =b
	STR r3, [r1]
	LDR r1, [r1]
	BX lr