;
; lab01-A.asm
;
; Created: 25/02/2020 12:00:09 PM
; Author : Andrew
;

/*
Load the 16-bit numbers 40960 and 2730 into register pairs r17:r16 and r19:r18.
Add them together and store the result in register pair r21:r20.
You can directly load the numbers into registers as constants.

When that's working try adding the numbers 640 and 511.
Does your program deal with overflow correctly?
*/

.include "m2560def.inc"

start:
	// Part A, add 40960 to 2730
	
	// Load 40960 into r17:r16
    ldi r17, high(40960)
	ldi r16, low(40960)
	
	// Load 2730 into r19:r18
	ldi r19, high(2730)
	ldi r18, low(2730)

	add r16, r18 // Add
	adc r17, r19 // Add with carry

	// Store result
	mov r21, r17 
	mov r20, r16

pt2:
	ldi r24, high(640)
	ldi r23, low(640)
	ldi r26, high(511)
	ldi r25, low(511)

	add r23, r25
	adc r24, r26

end:
	rjmp end
