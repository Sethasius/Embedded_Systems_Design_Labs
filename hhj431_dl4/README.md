# Design Lab 4

Made by: Seth Alan Brock

This is a collection of ARMv7 Assembly programs that each emulate a C program. 

---

## Table of Contents
- [About the Project](#about-the-project)
- [Built With](#built-with)
- [Program List](#program-list)
- [A. Multiply by Five](#a.-Multiply-by-Five)
- [B. Increment "x" "y" Times](#b.-Increment-"x"-"y"-times)
- [C. Multiply Using Addition](#c.-Multiply-Using-Addition)
- [D. nth Fibonacci](#d.-nth-Fibonacci)
## About the Project
This project was done for Dr. J. W. Bruce's Embedded Systems class at the University of Tennessee at Chattanooga for an assignment. 
## Program List
Each C program used a function call, each accepting either one or two variables. Since each variable was initialized with an empty value in C, the Armv7 Assembly programs use the data section to commit each to memory:
```Assembly
a: .word 0
b: .word 0
c: .word 0
d: .word 0
e: .word 0
f: .word 0
```
There are four programs in all. Each performs a mathematical function, such as multiplying the input by five or raising an input to another input. Each uses r0 and r1 as input registers. Each outputs a value in r0 that is then loaded into memory according to each variable.
### A. Multiply by Five
This program attempts to emulate the following C code:
```C
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
```
This function required only two instructions: an ADD and a LSL that was embedded in the ADD. The only input is the number to be multiplied in r0. The general format for loading a variable can be seen below:
```Assembly
LDR r0, =a
MOV r1, #1
STR r1, [r0]
LDR r0, [r0]
BL fcn4B
LDR r1, =d
STR r0, [r1]
```
The function uses the formula "x * 4 + 1", which can be seen below:
```Assembly
fcn4B:
	ADD r0, r0, r0, LSL #2
	BX lr
```
### B. Increment "x" "y" Times
This program attempts to emulate the following C code:
```C
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
```
This program essentially performs multiplication between two inputs, incrementing by "x" a "y" number of times.
```Assembly
fcn4B:
	MOV r2, #0
do_while:
	ADD r2, r2, r0
	SUBS r1, r1, #1
	BGT do_while
	BX lr
```
### C. Multiply Using Addition
This program attempts to emulate the following C code:
```C
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
```
This program takes the previous function, "fcn4B", and uses it to perform a power function. The function first preserves three non-changing registers and the link register. Two compares are used for the edge cases, exiting the loop if they are encountered. Three local variables are used to preserve "x", keep count, and keep count of how many times the number is multiplied.
```Assembly
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
```
### D. nth Fibonacci
This program attempts to emulate the following C code:
```C
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
```
This program uses a recursive function, so the syntax is not always entirely clear. First, two edge cases are considered, which are the first two Fibonacci numbers. Then two recursive function for finding the "F(n-1)" and "F(n-2)" are used. An ADD at the end combines the results.
```Assembly
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
```
