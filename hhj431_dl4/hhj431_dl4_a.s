.global fcn4B
.global main
.data
.align 2		@ Sets up for 2^2 byte address locations.
				@ 4-byte = 32-bit addressable data.

@ uint32_t	a,b,c,d,e,f;
@ Implements the variables above in memory
a: .word 0
b: .word 0
c: .word 0
d: .word 0
e: .word 0
f: .word 0

.text

.global _start
_start:
@ ===============================================================================
@ DL4. A. Multiply by Five

/* 
// function prototype
uint32_t fcn4A(uint32_t x);

// program variables
uint32_t        a,b,c,d,e,f;

// main()
int main(void) {
  a = some random number of your choice;
  b = some random number of your choice;
  c = some random number of your choice;

  d = fcn4A(a);
  e = fcn4A(b);
  f = fcn4A(c);
  // LOCK UP PROCESSOR HERE 
} // end of main()

// function definition
uint32_t fcn4A( uint32_t x) {
  return (x+x+x+x+x);
}
*/
@ ===============================================================================

main:
	LDR r0, =a
	MOV r1, #1
	STR r1, [r0]
	LDR r0, [r0]
	BL fcn4B
	LDR r1, =d
	STR r0, [r1]
	
	LDR r0, =b
	MOV r1, #6
	STR r1, [r0]
	LDR r0, [r0]
	BL fcn4B
	LDR r1, =e
	STR r0, [r1]
	
	LDR r0, =c
	MOV r1, #16
	STR r1, [r0]
	LDR r0, [r0]
	BL fcn4B
	LDR r1, =f
	STR r0, [r1]

lockup:
	b lockup

@ ===============================================================================
@ Function: fcn4B
@ This function effectively multiplies the parameter by 5. Luckily enough, the 
@ ADD instruction can be paired with the LSL instruction to create the equation:
@ r0 = r0 + r0 * 4

@ // function definition
@ uint32_t fcn4A( uint32_t x) {
@   return (x+x+x+x+x);
@ }

@ Inputs:
@	r0: Represents variable x
@ Outputs:
@	r0: 5x
@ ===============================================================================
.global fcn4B
.type fcn4B, %function
fcn4B:
	ADD r0, r0, r0, LSL #2
	BX lr