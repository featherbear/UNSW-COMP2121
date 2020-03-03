;
; lab01-D.asm
;
; Created: 3/03/2020 1:12:26 PM
; Author : Andrew
;

.EQU arg=1

.dseg
data:
	.byte 256

.cseg
// Assume the array is already sorted, and there are no repeated items
array:
	.db 1, 2, 5, 7, 8, 12, 20
/*
	// Long method //
	.db 1
	.db 2
	.db 5
	.db 7
	.db 8
	.db 12
	.db 20
*/


start:
initialise:
    ldi ZH, high(array)
	ldi ZL, low(array)

	// Repeat 256 times, or when lower value reached
	clr r1 // n_items counter // As a byte
	ldi XH, high(data)
	ldi XL, low(data)

	clr r3 // Last value

	// Use zero-flag / buffer overflow property of a byte to count 256
	clz
	loadLoop:
		breq loadLoop_end

		// Load program memory
		lpm r0, Z+ // Load to r0
		
		// Stop if new < last
		cp r0, r3
		brlo loadLoop_end

		// Store in data memory
		st X+, r0

		mov r3, r0 // Store last value
		inc r1
		rjmp loadLoop

	loadLoop_end:
		mov r2, r1 // Copy of counter
		
	// Zero-pad the rest
	clz
	clr r0
	clr r3

	zeroLoop:
		breq zeroLoop_end

		st X+, r0

		inc r2
		rjmp zeroLoop

	zeroLoop_end:

programStart:
  ldi r16, arg

  clr r0
  clr r2

  ldi XH, high(data)
  ldi XL, low(data)

  findHeadLoop:
	cp r1, r0
	brlo findHeadLoop_end

	ld r17, X+
	cp r16, r17
	brlo findHeadLoop_end
	breq end

	inc r0
	rjmp findHeadLoop

  findHeadLoop_end:
	// r0 is now the index of the number which we want to insert.
	// So, shift the rest down

	st -X, r16
	adiw XH:XL, 1

  shiftLoop:
	cp r1, r0
	brlo shiftLoop_end

	// r17 holds the original value

	ld r16, X
	st X+, r17
	
	mov r17, r16

	inc r0

	rjmp shiftLoop

  shiftLoop_end:
	inc r1

end:
	rjmp end


	

