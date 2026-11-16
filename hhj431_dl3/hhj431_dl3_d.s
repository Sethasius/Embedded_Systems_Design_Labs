.data
.align 2		@ Sets up for 2^2 byte address locations.
				@ 4-byte = 32-bit addressable data.

@ uint32_t	a,b,c;
@ Implements the variables above in memory
a: .word 0		@ a set to 1, to be compared to 0 and 2
b: .word 0		@ Will be set to 0 then 2 respectively
c: .word 0

.text

.global _start
_start:
@ ===============================================================================
@ DL3. D. If A is Greater Than or Equal to B AND A is Greater Than C

@ 	Write the A32 assembly language program to implement the following C language 
@ program snippet.

@ uint32_t        a,b,c;
@ if ((a >= b) && (a > c))
@    b=a-c;
@ else
@    c=b+a;

@ Register Format:
@ r0: Holds address to "a", then the value of "a"
@ r1: Holds address to "b", then the value of "b"
@ r2: Holds address to "c", then the value of "c"
@ r3: Temp variable, used to set "c" in function
@ ===============================================================================
	
	@ Tests for when a = b and a > c
	@ a = 3
	@ b = 3
	@ c = 1
	MOV r3, #3
	BL var_a_setter
	MOV r3, #3
	BL var_b_setter
	MOV r3, #1
	BL var_c_setter
	BL 	if_and_else		@ b = a - c = 3 - 1 = 2
	
	@ Tests for when a > b and a > c
	@ a = 3
	@ b = 2
	@ c = 1
	BL 	if_and_else		@ b = a - c = 3 - 1 = 2

	@ Tests for when a < b and a > c
	@ a = 3
	@ b = 4
	@ c = 1
	MOV r3, #4
	BL var_b_setter
	BL 	if_and_else		@ c = b + a = 4 + 3 = 7

	@ Tests for when a > b and a < c
	@ a = 3
	@ b = 1
	@ c = 7
	MOV r3, #1
	BL var_b_setter
	BL 	if_and_else		@ c = b + a = 1 + 3 = 4
	
	@ Exit program
	mov r0, #0
	mov r7, #1
	svc #0
	
.global if_and_else
.type if_and_else, %function
if_and_else:
	CMP r0, r1			@ Compares a versus b
	BLO else			@ Branches if a < b
	CMP r0, r2			@ Compares a versus c
	BLS else			@ Branches if a <= c
	SUB r3, r0, r2		@ If a >= b && a > c: temp b = a - c
	LDR r1, =b
	STR r3, [r1]
	LDR r1, [r1]
	BX LR
else:
	ADD r3, r1, r0		@ Otherwise: temp c = b + a
	LDR r2, =c
	STR r3, [r2]
	LDR r2, [r2]
	BX lr

@ Each variable setter accepts a value in r3 that is loaded into the memory
@ of each variable, as well as the register that will be used.
.global var_a_setter
.type var_b_setter, %function
var_a_setter:
	LDR r0, =a
	STR r3, [r0]
	LDR r0, [r0]
	BX lr

.global var_b_setter
.type var_b_setter, %function
var_b_setter:
	LDR r1, =b
	STR r3, [r1]
	LDR r1, [r1]
	BX lr
	
.global var_c_setter
.type var_c_setter, %function
var_c_setter:
	LDR r2, =c
	STR r3, [r2]
	LDR r2, [r2]
	BX lr