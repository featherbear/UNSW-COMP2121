;
; lab02-C.asm
;
; Created: 12/03/2020 3:10:25 PM
; Author : Andrew
;

/*

[5] (7) ^ | 8 \0   | 7 8 \0 
[5] (7) ^ | 6 8 \0 | 6 7 8 \0
[5] (7) ^ | 6 4 \0 | 6 7 4 \0

[5] (3) ^ | 8 \0     | 8 3 \0     |
[5] (3) ^ | 8 2 \0   | 8 3 2 \0   |
[6] (3) ^ | 8 5 4 \0 | 8 5 4 3 \0 |

[5] (7) v | 4 \0       | 4 7 \0       |
[5] (7) v | 4 1 2 8 \0 | 4 1 2 7 8 \0 |
[5] (7) v | 4 6 \0 | 4 6 7 \0 |
[5] (7) v | 4 8 \0 | 4 7 8 \0 |

[5] (3) v | 4 \0   | 4 3 \0 |
[5] (3) v | 2 \0   | 3 2 \0 |
[5] (3) v | 4 1 \0 | 4 3 1 \0 |
[5] (3) v | 4 6 \0 | 4 3 6 \0 |

req > cur && dir == up     =>  stop when req < ptr || next < ptr   (>>)
req < cur && dir == up     =>  stop when req < ptr, then go back 1 (<<)
req > cur && dir == down   =>  stop when req > ptr, then go back 1 (<<)
req < cur && dir == down   =>  stop when req > ptr || next > ptr   (>>) 
             dir == null.

*/
.equ START_FLOOR=5

.dseg
data:
	.byte 256

.cseg
// Assume the queue is already sorted, and there are no repeated items
queue:
	.db 4,6, '\0'

requests:
    .db 3, '\0'

start:
initialise:
	ldi YH, high(RAMEND)
	ldi YL, low(RAMEND)
	out SPH, YH
	out SPL, YL

	// ZH and ZL didn't need to be left shifted, since it started from 0
    ldi ZH, high(queue /* << 1 */)
	ldi ZL, low(queue  /* << 1 */)
	lpm r20, Z

	// Repeat 256 times, or when 0 reached
	clr r1 // n_items counter // As a byte
	ldi XH, high(data)
	ldi XL, low(data)

	// Use zero-flag / buffer overflow property of a byte to count 256
	clz
	loadLoop:
		breq loadLoop_end // Depends if `inc r` zeroes the status register

		// Load program memory
		lpm r0, Z+ // Load to r0
		
		tst r0
		breq loadLoop_end
		
		// Store in data memory
		st X+, r0

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
  ldi ZH, high(requests<<1)
  ldi ZL, low(requests<<1)

  ldi r19, START_FLOOR // Set current floor

  // Current floor
  mov r12, r19

  ldi YH, high(data)
  ldi YL, low(data)
  mov r8, YH
  mov r9, YL

	// if queue is zero then no direction - idle
	// Is direction not just r11-curr?
	mov r16, r20
	sub r16, r12

	checkDirection:
	breq checkDirection_eq
	brlo checkDirection_dn

	checkDirection_up:
	ldi r16, 2
	rjmp checkDirection_end

	checkDirection_eq:
	ldi r16, 1
	rjmp checkDirection_end

	checkDirection_dn:
	ldi r16, 0
	// rjmp checkDirection_end

	checkDirection_end:
	mov r13, r16


  insertLoop:
  	  lpm r11, Z+ // Next item in request

	  tst r11
	  breq insertLoop_end

	  mov r10, r1 // queue size

	  // r24 = insert_request(r8:r9, r10, r11, r12, r13)
	  // -- newQueueSize = insert_request(*queue, queueSize, value, currentFloor, direction)
	  rcall insert_request
	  mov r1, r24 // Set r1 to queue size 
	  

	  rjmp insertLoop

	insertLoop_end:

end:
	rjmp end


/////////////////////////////////////////


insert_request:
	// r8  -> high(&queue)
	// r9  -> low(&queue)
	// r10 -> queueSize
	// r11 -> value

	// r12 -> currentFloor
	// r13 -> direction

	// r24 -> return value

	mov r24, r10

	// If current floor requested, then abort
	cp r11, r12
	brne differentFloor
	ret

	differentFloor:

	push r0
	clr r0


	push r1
	mov r1, r10 // Queue size

	push r15
	clr r15

	push r16
	mov r16, r11

	push XH
	mov XH, r8
	push XL
	mov XL, r9

	push r17

	push r18
	clr r18
	
	push r19
	mov r19, r13

	// -------------

	cpi r19, 1
	// idle / no queue
	brlo goingDown


	goingUp:
	cp r11, r12
	brlo rearSearch_lt

	fowardSearch_lt:
		fowardSearch_lt_loop:
			cp r1, r0
			brlo fowardSearch_gt_loop_end

			ld r17, X+
			cp r16, r17 
			brlo fowardSearch_lt_loop_end
			breq insert_request_end

			cp r17, r18
			brlo fowardSearch_lt_loop_end

			mov r18, r17
			inc r0
			rjmp fowardSearch_lt_loop
		fowardSearch_lt_loop_end:
			sbiw XH:XL, 1
			rjmp foundIndex

	rearSearch_lt:
		mov r0, r1

		add XL, r0
		adc XH, r15

		rearSearch_lt_loop:
			tst r0
			breq rearSearch_lt_loop_end

			ld r17, -X
			cp r16, r17
			brlo rearSearch_lt_loop_end
			breq insert_request_end

			dec r0
			rjmp rearSearch_lt_loop

		rearSearch_lt_loop_end:
			adiw XH:XL, 1
			rjmp foundIndex

	//
	goingDown:
		cp r11, r12
		brlo fowardSearch_gt

		rearSearch_gt:
			mov r0, r1

			add XL, r0
			adc XH, r15

			rearSearch_gt_loop:
				tst r0
				breq rearSearch_gt_loop_end

				ld r17, -X
				cp r17, r16
				brlo rearSearch_gt_loop_end
				breq insert_request_end

				dec r0
				rjmp rearSearch_gt_loop

			rearSearch_gt_loop_end:
				adiw XH:XL, 1
				rjmp foundIndex


		fowardSearch_gt:
			ser r18
			fowardSearch_gt_loop:
				cp r1, r0
				brlo fowardSearch_gt_loop_end

				ld r17, X+
				cp r17, r16
				brlo fowardSearch_gt_loop_end
				breq insert_request_end

				cp r18, r17
				brlo fowardSearch_gt_loop_end

				mov r18, r17
				inc r0
				rjmp fowardSearch_gt_loop

			fowardSearch_gt_loop_end:
				sbiw XH:XL, 1
				rjmp foundIndex


	foundIndex:
	// r0 is now the index of the number which we want to insert.
	// So, shift the rest down

	shiftLoop:
		cp r1, r0
		brlo shiftLoop_end
		// pick up the value
		ld r17, X

		// store the current
		st X+, r16

		// move
		mov r16, r17

		inc r0
		rjmp shiftLoop

	/*
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
	*/
	shiftLoop_end:
		inc r1
	
insert_request_end:
	mov r24, r1
	pop r19
	pop r18
	pop r17
	pop XL
	pop XH
	pop r16
	pop r15
	pop r1
	pop r0

	insert_request_finish:
	ret
