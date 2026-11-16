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
@ DL4. B. Increment by "x" "y" times
@ 	This program has a function that accepts two variables, "x" and "y". "x" is the 
@ amount that the function increments by from zero. "y" is how many times that 
@ the number will increment.

/* 
// function prototype
uint32_t fcn4B(uint32_t x, uint32_t y);

// program variables
uint32_t        a,b,c,d,e,f;

// main()
int main(void) {
  a = some random number of your choice;
  b = some random number of your choice;
  c = some random number of your choice;

  e = fcn4B(a,b);
  f = fcn4A(c,d);
  // LOCK UP PROCESSOR HERE
  while(1); 
} // end of main()

// function definition
uint32_t fcn4B( uint32_t x, uint32_t y) {
  uint32_t m,n;

  n = 0;
  m = y;
  do {
    n+=x;
    y--;
  } while (m>0);
  return (n);
}
*/
@ ===============================================================================

main:
	LDR r0, =a
	MOV r1, #1
	STR r1, [r0]
	LDR r0, [r0]
	LDR r1, =b
	MOV r2, #5
	STR r2, [r1]
	LDR r1, [r1]
	BL fcn4B
	LDR r1, =e
	STR r0, [r1]
	
	LDR r0, =c
	MOV r1, #2
	STR r1, [r0]
	LDR r0, [r0]
	LDR r1, =d
	MOV r2, #20
	STR r2, [r1]
	LDR r1, [r1]
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
@ uint32_t fcn4B( uint32_t x, uint32_t y) {
@   uint32_t m,n;

@   n = 0;
@   m = y;
@   do {
@     n+=x;
@     y--;
@   } while (m>0);
@   return (n);
@ }

@ Inputs:
@	r0: Represents variable x
@	r1: Represents variable y, which is the counter for the do while loop
@ Local:
@	r2: Accumulator for the variable x`s increments
@ Outputs:
@	r2: 0 + x * y
@ ===============================================================================
.global fcn4B
.type fcn4B, %function
fcn4B:
	MOV r2, #0
do_while:
	ADD r2, r2, r0
	SUBS r1, r1, #1
	BGT do_while
	BX lr