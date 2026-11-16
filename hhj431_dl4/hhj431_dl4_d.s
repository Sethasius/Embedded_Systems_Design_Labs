.global fcn4D
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
@ DL4. D. nth Fibonacci
@ 	This program computes the "nth" Fibonacci number 
/* 
// function prototype
uint32_t fcn4D(uint32_t n);

// program variables
uint32_t        a,b,c,d,e,f;

// main()
int main(void) {
  a = some random number of your choice;
  b = some random number of your choice;
  c = some random number of your choice;

  d = fcn4D(a);      // calculate the a-th number in the Fibonacci sequence
  e = fcn4D(b);      // calculate the b-th number in the Fibonacci sequence
  f = fcn4D(c);      // calculate the c-th number in the Fibonacci sequence
  // LOCK UP PROCESSOR HERE 
  while(1);
} // end of main()

// function definition
// a recursive function to calculate the n-th Fibonacci number
uint32_t fcn4D( uint32_t n)  {
  // Base cases: F(0) = 0, F(1) = 1
  if (n <= 1)
    { return (n);}
  // Recursive case: F(n) = F(n-1) + F(n-2)
  return (fcn4d(n-1) + fcn4d(n-2)); 
} 
*/
@ ===============================================================================

main:
	LDR r0, =a
	MOV r1, #1
	STR r1, [r0]
	LDR r0, [r0]
	BL fcn4D		@ Expected value: 1
	LDR r1, =d
	STR r0, [r1]
	
	LDR r0, =b
	MOV r1, #6
	STR r1, [r0]
	LDR r0, [r0]
	BL fcn4D		@ Expected value: 8
	LDR r1, =e
	STR r0, [r1]
	
	LDR r0, =c
	MOV r1, #10
	STR r1, [r0]
	LDR r0, [r0]
	BL fcn4D		@ Expected value: 0x37h, 55d
	LDR r1, =f
	STR r0, [r1]	

lockup:
	b lockup


@ ===============================================================================
@ Function: fcn4D

/*
// function definition
// a recursive function to calculate the n-th Fibonacci number
uint32_t fcn4D( uint32_t n)  {
  // Base cases: F(0) = 0, F(1) = 1
  if (n <= 1)
    { return (n);}
  // Recursive case: F(n) = F(n-1) + F(n-2)
  return (fcn4d(n-1) + fcn4d(n-2)); 
} 

*/

@ Inputs:
@	r0: n = Number of Fibonacci Sequence 
@ Local:
@	r4: Holds temp values
@	r5: Holds F(n-1) result to be added to total
@ Outputs:
@	r0: nth number of Fibonacci Sequence
@ ===============================================================================
.global fcn4D
.type fcn4D, %function
fcn4D:
	PUSH {r4, r5, r11, lr} @ Adding empty register to avoid SP bug
	MOV r4, r0
	@ First two Fibonacci numbers
	CMP r4, #1
	BLE exit_fcn4D
	
	@ For F(n-1)
	SUB r0, r4, #1
	BL fcn4D
	MOV r5, r0
	
	@ For F(n-2)
	SUB r0, r4, #2
	BL fcn4D
	
	@ Add F(n-1) + F(n-2)
	ADD r0, r5, r0
	
exit_fcn4D:
	POP {r4, r5, r11, pc}