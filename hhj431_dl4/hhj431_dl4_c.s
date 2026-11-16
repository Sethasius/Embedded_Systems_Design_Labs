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
@ DL4. C. Multiply Using Addition
@ 	This program has a function that accepts two variables, "x" and "y". "x" is the 
@ base of a power function. "y" is the power of the function.

/* 
// function prototype
uint32_t fcn4C1(uint32_t x, uint32_t y);
uint32_t fcn4C2(uint32_t x, uint32_t y);

// program variables
uint32_t        a,b,c,d,e,f;

// main()
int main(void) {
  a = some random number of your choice;
  b = some random number of your choice;
  c = some random number of your choice;
  d = some random number of your choice;

  e = fcn4C2(a,b);      // e equals a raised to the b power
  f = fcn4C2(c,d);      // f equals c raised to the d power
  // LOCK UP PROCESSOR HERE
  while(1);
} // end of main()

// function definitions

// return the value of x*y but compute via repeated addition
//  instead of using the multiplier
uint32_t fcn4C1( uint32_t x, uint32_t y) {
  uint32_t i, n;

  if ((x==0)||(y==0)) {
    return (0);
  }
  n = 0;
  i = y;
  do {
    n+=x;
    i--;
  } while (i>0);
  return (n);
}

// return the value of x raised to the power y but compute via
// repeated multiplication using the function above instead of the multiplier
uint32_t fcn4C2( uint32_t x, uint32_t y) {
  uint32_t i,m,n;

  if (y==0) {
   return (1);
  }
  if (x==0) {
    return (0);
  }

  n = 1;
  i = y;
  do {
    n=fcn4C1(n,x);
    i--;
  } while (i>0);
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
	BL fcn4C2		@ Expected: 1
	LDR r1, =e
	STR r0, [r1]
	
	LDR r0, =c
	MOV r1, #2
	STR r1, [r0]
	LDR r0, [r0]
	LDR r1, =d
	MOV r2, #8
	STR r2, [r1]
	LDR r1, [r1]
	BL fcn4C2		@ Expected: 0x100, 256d
	LDR r1, =f
	STR r0, [r1]

lockup:
	b lockup


@ ===============================================================================
@ Function: fcn4C1

/*
// return the value of x*y but compute via repeated addition
//  instead of using the multiplier
uint32_t fcn4C1( uint32_t x, uint32_t y) {
  uint32_t i, n;

  if ((x==0)||(y==0)) {
    return (0);
  }
  n = 0;
  i = y;
  do {
    n+=x;
    i--;
  } while (i>0);
  return (n);
}
*/

@ Inputs:
@	r0: Represents variable x
@	r1: Represents variable y, which is the counter for the do while loop
@ Local:
@	r2: Accumulator for the variable x`s increments
@ Outputs:
@	r0: 0 + x * y
@ ===============================================================================
.global fcn4C1
.type fcn4C1, %function
fcn4C1:
	@ Checks for x = 0
	CMP r0, #0
	MOVEQ r0, #0
	BXEQ lr
	@ Checks for y = 0
	CMP r1, #0
	MOVEQ r0, #0
	BXEQ lr
	@ Sets accumulator to 0
	MOV r2, #0
mult_while:
	ADD r2, r2, r0
	SUBS r1, r1, #1
	BGT mult_while
	MOV r0, r2
	BX lr
	
@ ===============================================================================
@ Function: fcn4C2
@	A function for returning a value to a power.

/*
// return the value of x raised to the power y but compute via
// repeated multiplication using the function above instead of the multiplier
uint32_t fcn4C2( uint32_t x, uint32_t y) {
  uint32_t i,m,n;

  if (y==0) {
   return (1);
  }
  if (x==0) {
    return (0);
  }

  n = 1;
  i = y;
  do {
    n=fcn4C1(n,x);
    i--;
  } while (i>0);
  return (n);
}
*/

@ Inputs:
@ 	r0: Represents variable x
@ 	r1: Represents variable y

@ Local:
@	r4: Preserves x
@	r5: Counter i
@	r6: Local n

@ Outputs:
@	r0: x ^ y
@ ===============================================================================
.global fcn4C2
.type fcn4C2, %function
fcn4C2:
	PUSH {r4-r6, lr}
	@ Checks to see if y = 0
	CMP r1, #0
	MOVEQ r0, #1		@ Moves 1 into output, branches to exit function
	BEQ exit_fcn4C2
	@ Checks to see if x = 0
	CMP r0, #0
	MOVEQ r0, #0		@ Moves 0 into output, branches to exit function
	BEQ exit_fcn4C2
	
	MOV r4, r0			@ Preserve x in r4
	MOV r5, r1			@ Local: i. Preserve y in r5, used as counter
	MOV r6, #1			@ Local: n.
power_while:
	MOV r0, r4			@ r0 = x
	MOV r1, r6			@ r1 = n
	BL fcn4C1			@ fcn4C1(x, n)
	MOV r6, r0			@ Update n
	
	SUBS r5, r5, #1		@ Decrement counter
	BGT power_while
	MOV r0, r6
	
exit_fcn4C2:
	POP {r4-r6, pc}		@ Restore previous registers and return to main