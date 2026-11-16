.data
.align 2		@ Sets up for 2^2 byte address locations.
				@ 4-byte = 32-bit addressable data.

@ uint32_t	a,b,c;
@ Implements the variables above in memory
a: .word 0		@ a set to 1, to be compared to 0 and 2
b: .word 0		@ Will be set to 0 then 2 respectively
c: .word 0
d: .word 0

.text

.global _start
_start:
@ ===============================================================================
@ DL3. E. If Elif Else

@ 	Write the A32 assembly language program to implement the following C language 
@ program snippet.

@ uint32_t        a,b,c,d;
@ if ((a >= b) && (a > c))
@    b=a-c+d;
@ else if (c<d)
@    c=b+a-d;
@ else
@    d=a;

@ Register Format:
@ r0: Holds address to "a", then the value of "a"
@ r1: Holds address to "b", then the value of "b"
@ r2: Holds address to "c", then the value of "c"
@ r3: Holds address to "d", then the value of "d"
@ r4: Used for temp variables
@ ===============================================================================
	
	@ Tests for when a = b and a > c
	@ a = 3
	@ b = 3
	@ c = 1
	@ d = 1
	MOV r4, #3
	BL var_a_setter
	MOV r4, #3
	BL var_b_setter
	MOV r4, #1
	BL var_c_setter
	MOV r4, #1
	BL var_d_setter
	BL 	if_elif_else 		@ b = a - c + d = 3 - 1 + 1 = 3
	
	@ Tests for when a > b and a > c
	@ a = 3
	@ b = 2
	@ c = 1
	@ d = 1
	MOV r4, #2
	BL var_b_setter
	BL 	if_elif_else		@ b = a - c + d = 3 - 1 + 1 = 3

	@ Tests for when c < d
	@ a = 3
	@ b = 4
	@ c = 1
	@ d = 2
	MOV r4, #4
	BL var_b_setter
	MOV r4, #2
	BL var_d_setter
	BL 	if_elif_else		@ c = b + a - d = 4 + 3 - 2 = 5

	@ Tests for when a < b, a <= c, and c > d
	@ a = 3
	@ b = 4
	@ c = 5
	@ d = 0
	MOV r4, #0
	BL var_d_setter
	BL 	if_elif_else		@ d = a = 3
	
	@ Exit program
	mov r0, #0
	mov r7, #1
	svc #0
	
.global if_elif_else
.type if_elif_else, %function
if_elif_else:
	CMP r0, r1			@ Compare a & b
	BLO elif			@ Branch if a < b
	CMP r0, r2			@ Compare a & c
	BLS elif			@ Branch if a <= c
	SUB r4, r0, r2		@ r4 = a - c
	ADD r4, r4, r3		@ temp b = r4 + d
	LDR r1, =b
	STR r4, [r1]
	LDR r1, [r1]
	BX lr
elif:
	CMP r2, r3			@ Compare c & d
	BHS else			@ Branch if c >= d
	ADD r4, r1, r0		@ r4 = b + a
	SUB r4, r4, r3 		@ temp c = r4 - d
	LDR r2, =c
	STR r4, [r2]
	LDR r2, [r2]
	BX lr
else:
	MOV r4, r0			@ temp d = a		
	LDR r3, =d
	STR r4, [r3]
	LDR r3, [r3]
	BX lr

@ Each variable setter accepts a value in r4 that is loaded into the memory
@ of each variable, as well as the register that will be used.
.global var_a_setter
.type var_b_setter, %function
var_a_setter:
	LDR r0, =a
	STR r4, [r0]
	LDR r0, [r0]
	BX lr

.global var_b_setter
.type var_b_setter, %function
var_b_setter:
	LDR r1, =b
	STR r4, [r1]
	LDR r1, [r1]
	BX lr
	
.global var_c_setter
.type var_c_setter, %function
var_c_setter:
	LDR r2, =c
	STR r4, [r2]
	LDR r2, [r2]
	BX lr
	
.global var_d_setter
.type var_d_setter, %function
var_d_setter:
	LDR r3, =d
	STR r4, [r3]
	LDR r3, [r3]
	BX lr