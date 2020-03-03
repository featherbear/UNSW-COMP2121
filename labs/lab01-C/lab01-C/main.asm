;
; lab01-C.asm
;
; Created: 26/02/2020 10:52:04 PM
; Author : Andrew
;

/*
Write a program that loads a 2-byte unsigned integer from the program memory into registers and converts it to ASCII representation.
Store ASCII results in data memory.
Data memory should be allocated using the assembler directives instead of hard-coding the address.
*/

.include "m2560def.inc"

.dseg
ascii: .byte 5 // 6 for null terminator?

.cseg
input: .dw 64691

start:
	// Load value for MSB of `input` into r1
	ldi ZH, high(input+1)
	ldi ZL, low(input+1)
    lpm r1, Z
	
	// Load value for LSB of `input` into r0
	clc
	sbci ZL, 1
	sbci ZH, 0
	lpm

	// Set X register
	ldi XH, high(ascii)
	ldi XL, low(ascii)

	clr r2 // Count
	ldi r18, '0' // ASCII Offset for '0'
	
	ldi r17, high(10000)
	ldi r16, low(10000)

	cp r0, r16
	cpc r1, r17
	brlo loopA_end


	loopA:
		sub r0, r16
		sbc r1, r17
		inc r2

		cp r0, r16
		cpc r1, r17
		brlo loopA_end

		rjmp loopA

	loopA_end:
		add r2, r18
		st X+, r2
		clr r2

	ldi r17, high(1000)
	ldi r16, low(1000)

	cp r0, r16
	cpc r1, r17
	brlo loopB_end
		
	loopB:
		sub r0, r16
		sbc r1, r17
		inc r2

		cp r0, r16
		cpc r1, r17
		brlo loopB_end

		rjmp loopB

	loopB_end:
		add r2, r18
		st X+, r2
		clr r2

	ldi r17, high(100)
	ldi r16, low(100)

	cp r0, r16
	cpc r1, r17
	brlo loopC_end
		
	loopC:
		sub r0, r16
		sbc r1, r17
		inc r2

		cp r0, r16
		cpc r1, r17
		brlo loopC_end

		rjmp loopC

	loopC_end:
		add r2, r18
		st X+, r2
		clr r2

	ldi r17, high(10)
	ldi r16, low(10)

	cp r0, r16
	cpc r1, r17
	brlo loopD_end
		
	loopD:
		sub r0, r16
		sbc r1, r17
		inc r2

		cp r0, r16
		cpc r1, r17
		brlo loopD_end

		rjmp loopD

	loopD_end:
		add r2, r18
		st X+, r2
		clr r2

	add r0, r18
	st X, r0
	
end:
    rjmp end
