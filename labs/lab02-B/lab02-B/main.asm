;
; lab02-B.asm
;
; Created: 10/03/2020 1:33:03 PM
; Author : Andrew
;

.dseg
data:
	.byte 256

.cseg
// Assume the array is already sorted, and there are no repeated items
array:
	.db 1, 2, 5, 7, 8, 12, 20

// Count = 5
inserts:
    .db 0, 10, 1, 25, 6

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
		// ZH and ZL didn't need to be left shifted, since it started from 0
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
	clr r0
	clr r3
	clz

	zeroLoop:
		breq zeroLoop_end

		st X+, r0

		inc r2
		rjmp zeroLoop

	zeroLoop_end:

programStart:

  // Left Shift / Multiply by 2 - to address the word <-> byte address compatability
  ldi ZH, high(inserts<<1)
  ldi ZL, low(inserts<<1)

  clr r18 // Counter

  insertLoop:
  	  cpi r18, 5
	  breq insertLoop_end

	  ldi YH, high(data)
	  ldi YL, low(data)
	  mov r8, YH
	  mov r9, YL
	  mov r10, r1
	  lpm r11, Z+

	  rcall insert_request
	  
	  mov r1, r24
	  inc r18
	  rjmp insertLoop

	insertLoop_end:

end:
	rjmp end


/////////////////////////////////////////

insert_request:
	// r8  -> high(&sortedArray)
	// r9  -> low(&sortedArray)
	// r10 -> array_size
	// r11 -> value
	// r24 -> return value
	push r0
	clr r0

	push r1
	mov r1, r10

	push r16
	mov r16, r11

	push XH
	mov XH, r8
	push XL
	mov XL, r9

	push r17

	findHeadLoop:
	cp r1, r0
	brlo findHeadLoop_end

	ld r17, X+
	cp r16, r17
	brlo findHeadLoop_end
	breq insert_request_end

	inc r0
	rjmp findHeadLoop

	findHeadLoop_end:
	// r0 is now the index of the number which we want to insert.
	// So, shift the rest down

	st -X, r16
	inc r0
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

insert_request_end:
	mov r24, r1

	pop r17
	pop XL
	pop XH
	pop r16
	pop r1
	pop r0
	ret
