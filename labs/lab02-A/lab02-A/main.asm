;
; lab02-A.asm
;
; Created: 10/03/2020 12:02:03 PM
; Author : Andrew
;
/*

Implement a program that loads a null-terminated string from program memory and pushes it onto the stack, 
then writes out the reversed string into data memory.

The stack pointer must be initialized before use.

eg: "abc",0 will be stored in data memory as "cba",0

*/

.include "m2560def.inc"

.dseg
data: .byte 256

.cseg
str: .db "ABCDEFGIJKLMNOPQRSTUVWXYZ",0

start:
	// Set stack pointer registers
	ldi YH, high(RAMEND)
	ldi YL, low(RAMEND)
	out SPH, YH // Cannot use `ldi` for the stack pointer registers
	out SPL, YL // Instead we store to intermediate registers (Y) and then use `out`

	// Load data
    ldi ZH, high(str<<1)
	ldi ZL, low(str<<1)

	// Counter
	clr r17

	stackPusher_loop:
		// Load next byte, increment pointer
		lpm r16, Z+

		// If a null-terminator (0x00) is found, stop pushing onto the stack
		cpi r16, 0
		breq stackPusher_loopEnd

		
		push r16 // Push byte onto stack
		inc r17  // Increment counter

		rjmp stackPusher_loop
		
	stackPusher_loopEnd:

	// Set data memory location
	ldi XH, high(data)
	ldi XL, low(data)

	stackPopper_loop:
		// Repeat until the counter reaches zero
		cpi r17, 0
		breq stackPopper_loopEnd

		pop r16    // Grab the last item off the stack
		st X+, r16 // Store byte into data
		
		dec r17
		rjmp stackPopper_loop

	stackPopper_loopEnd:
		// Store null-terminator
		st X, r17

end:
	rjmp end
