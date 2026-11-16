# Design Lab 3

Made by: Seth Alan Brock

This is a collection of ARMv7 Assembly programs that each emulate a C program. 

---

## Table of Contents
- [About the Project](#about-the-project)
- [Built With](#built-with)
- [Program List](#program-list)
- [A. If Equals](#a.-if-equals)
- [B. If Equals Else](#b.-if-equals-else)
- [C. If Greater Than or Equal](#c.-if-greater-than-or-equal)
- [D. If Greater Than or Equal AND Greater Than](#d.-if-greater-than-or-equal-and-greater-than)
- [E. If Elif Else](#e.-if-elif-else)
- [F. For Loop](#f.-for-loop)
- [G. While Loop](#g.-while-loop)
- [H. Do While Loop](#h.-do-while-loop)
## About the Project
This project was done for Dr. J. W. Bruce's Embedded Systems class at the University of Tennessee at Chattanooga for an assignment. 
## Program List
Each C program used a different tool to perform a function. The tools used are the names of each section. Since each variable was initialized with an empty value in C, the Armv7 Assembly programs use the data section to commit each to memory:
```Assembly
a: .word 0
b: .word 0
c: .word 0
```
For ease of use and test cases, a setter function was devised to quickly set up each variable. The only input is a register, typically r3 and sometimes r4, that had a literal moved into it. The outputs were the variable in memory being set to the input literal and a corresponding register, such as r0 for the variable "a".
```Assembly
var_a_setter:
	LDR r0, =a
	STR r3, [r0]
	LDR r0, [r0]
	BX lr
```
A function was created for each program to emulate the desired C program's behavior. 
The first two programs, If Equals and If Equals Else, do not have the setters embedded in them, however every other program does.
### A. If Equals
This program attempts to emulate the following C code:
```C
uint32_t        a,b,c;

if (a == 0xDEADBEEF) a=0x8BADF00D;
```
Only three instructions are really needed to implement this program. A compare that sees if a is equal to "DEADBEEF", a conditional branch that branches when they are not equal, and a setter to store the value in "a's" memory.
```Assembly
if_equal:
	CMP r1, r2		@ Compares a with 0xDEADBEEF
	BXNE lr
	STR r3, [r0]
```
One pair of instructions that were particularly useful were "MOVW" and "MOVT". "MOVW" loads a value in the least significant half (LSH) of a 32-bit register, clearing every other part. "MOVW" loads a value in the most significant half (MSH) of a 32-bit register, preserving every other part. Paired together, they can load a register with values that literals normally can not reach. This was used to set the registers to be tested, such as below:
```Assembly
MOVW r1, #0xBEEF	@ Moves 0xBEEF into bottom half of word in r1
MOVT r1, #0xDEAD	@ Moves 0xDEAD into top half of word in r1
```
### B. If Equals Else
This program attempts to emulate the following C code:
```C
uint32_t        a,b,c;

if (a == 0xDEADBEEF)
   b=0x8BADF00D;
else
   b=0xCAFEF00D;

```
Six instructions are needed to emulate the C code. 
A compare that checks if a is equal to "DEADBEEF". A pair of "MOVW" and "MOVT" with the "EQ" condition code to move "8BADFOOD" into "b". A pair of "MOVW" and "MOVT" with the "EQ" condition code to move "CAFEF00D" into "b". The "STR" instruction to copy the information to "b" in memory.
```Assembly
if_equal_else:
	CMP r1, r2		@ Compares a with 0xDEADBEEF
	MOVWEQ	r3, #0xF00D
	MOVTEQ	r3, #0x8BAD
	MOVWNE	r3, #0xF00D
	MOVTNE	r3, #0xCAFE
	str r3, [r0]
	BX lr
```
### C. If Greater Than or Equal
This program attempts to emulate the following C code:
```C
uint32_t        a,b,c;

if (a >= b)
   c=0xAAAABBBB;
else
   c=0xBBBBAAAA;
```
This program uses the "if else" that was in the previous program, but altered to compare two variables. After the comparison, two actions are chosen to see what to do. Condition codes are tacked onto each "MOVW" and "MOVT" instruction. The "HS" condition code stands for "higher same", while the "LO" stands for "lower". 
```Assembly
@ Register Format:
@ r0: Holds address to "a", then the value of "a"
@ r1: Holds address to "b", then the value of "b"
@ r2: Holds address to "c"
@ r3: Temp variable, used to set "c" in function

if_greater_equal_else:
	CMP r0, r1
	LDR r2, =c
	MOVWHS	r3, #0xBBBB
	MOVTHS	r3, #0xAAAA
	MOVWLO	r3, #0xAAAA
	MOVTLO	r3, #0xBBBB
	str r3, [r2]
	BX lr
```
### D. If Greater Than or Equal AND Greater Than
This program attempts to emulate the following C code:
```C
uint32_t        a,b,c;

if ((a >= b) && (a > c))
   b=a-c;
else
   c=b+a;

```
This program does require a bit more than the previous ones. First, lets clearly define the register format.
```Assembly
@ Register Format:
@ r0: Holds address to "a", then the value of "a"
@ r1: Holds address to "b", then the value of "b"
@ r2: Holds address to "c", then the value of "c"
@ r3: Temp variable, used to set "c" in function

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

```
### E. If Elif Else
This program attempts to emulate the following C code:
```C
uint32_t        a,b,c,d;
if ((a >= b) && (a > c))
   b=a-c+d;
else if (c<d)
   c=b+a-d;
else
   d=a;
```
The register format for the below ARMv7 program is as follows:
```Assembly
@ Register Format:
@ r0: Holds address to "a", then the value of "a"
@ r1: Holds address to "b", then the value of "b"
@ r2: Holds address to "c", then the value of "c"
@ r3: Holds address to "d", then the value of "d"
@ r4: Used for temp variables
```
The program aims to emulate an "if elif else" statement set. This will require two branches to the "elif" and "else" sections of the code. The first branch checks "a >= b" and "a > c" and will branch to "elif". 
```Assembly
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
```
From "elif", "c" and "d" are compared to see if "c" is higher or the same. If not, it branches to "else". 
```Assembly
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
```
If each of the above conditional branches were met, "else" will trigger.
```Assembly
else:
	MOV r4, r0			@ temp d = a		
	LDR r3, =d
	STR r4, [r3]
	LDR r3, [r3]
	BX lr
```
### F. For Loop
This program attempts to emulate the following C code:
```C
uint32_t        a,b,c;

for (int i=0; i<16, i++) {
   a += b;
}
```
This program takes two inputs: the initial value of "a" and how much you wanted to increment it by "b". r2 was used as a counter, set to decrement from 16 during each loop. r0 was set as "a", and r1 was set as "b".
```Assembly
for_loop:
	MOV r2, #16			@ Set counter to 16
loop:
	ADD r0, r0, r1
	SUBS r2, r2, #1
	BGT loop
	BX lr
```
### G. While Loop
This program attempts to emulate the following C code:
```C
uint32_t        a,b,c;

a = 0;
while (a < 128) {
   a++;
   b+=a;
}
```
This program emulates a while loop that stops once "a" is greater than or equal to 128. A while loop checks at the beginning of the loop whether or not the boolean statement has been satisfied. To perform this, a compare and branch if greater than set of instructions are used at the start of the loop. Another branch is placed at the bottom to loop back until the condition has been met.
```Assembly
while_loop:
	CMP r0, #128		@ Checks "a" against 128
	BGE done			@ Exit if a >= 128
	ADD r0, r0, #1		@ a++
	ADD r1, r1, r0		@ b = b + a
	B while_loop
done:
	MOV r3, r1
	LDR r1, =b
	STR r3, [r1]
	LDR r1, [r1]
	BX lr
```
### H. Do While Loop
This program attempts to emulate the following C code:
```C
uint32_t        a,b,c;

a = 0;
do {
   a++;
   b+=a;
} while (a < 128);
```
A do while loop operates similarly to a while except with its boolean statement at the end. This ensures that it always runs at least once. This is simpler to emulate in ARMv7 because a branch conditional at the end can be used.
```Assembly
do_while_loop:
	ADD r0, r0, #1		@ a++
	ADD r1, r1, r0		@ b = b + a
	CMP r0, #128		@ Checks "a" against 128
	BLT do_while_loop		@ Exit if a >= 128
done:
	MOV r3, r1
	LDR r1, =b
	STR r3, [r1]
	LDR r1, [r1]
	BX lr

```