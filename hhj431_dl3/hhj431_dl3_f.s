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
@ DL3. F. For Loop

@ 	Write the A32 assembly language program to implement the following C language 
@ program snippet.

@ uint32_t        a,b,c;
@ for (int i=0; i<16, i++) {
@    a += b;
@ }

@ Register Format:
@ r0: Holds address to "a", then the value of "a"
@ r1: Holds address to "b", then the value of "b"
@ r2: Counter
@ r3: Temp Value if needed
@ ===============================================================================
	
	@ For loop that starts at "1" and increments by "1" each loop
	MOV r3, #1
	BL var_a_setter
	BL var_b_setter
	BL for_loop
	
	@ For loop that starts at "1" and increments by "2" each loop
	MOV r3, #2
	BL var_b_setter
	BL for_loop
	
	@ For loop that starts at "10" and increments by "2" each loop
	MOV r3, #10
	BL var_a_setter
	BL for_loop
	
	@ Exit program
	mov r0, #0
	mov r7, #1
	svc #0
	
.global for_loop
.type for_loop, %function
for_loop:
	MOV r2, #16			@ Set counter to 16
loop:
	ADD r0, r0, r1
	SUBS r2, r2, #1
	BGT loop
	BX lr

@ Each variable setter accepts a value in r4 that is loaded into the memory
@ of each variable, as well as the register that will be used.
.global var_a_setter
.type var_a_setter, %function
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