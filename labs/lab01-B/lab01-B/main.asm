;
; lab01-B.asm
;
; Created: 25/02/2020 2:14:47 PM
; Author : Andrew
;


; Replace with your application code
.include "m2560def.inc"

/*
	Write a program that divides a 16-bit unsigned integer by any 8-bit unsigned integer.
	Assume that the dividend and the divisor reside in registers of your choice.
	Your program should output the 16-bit quotient and the 16-bit remainder in registers.
	Test corner cases such as : maximum / minimum, divisor > dividend.
*/

.equ haha=0xffff
.equ lol=1

start:
	// rjmp eightBitDivision
	rjmp sixteenBitDivision

eightBitDivision:
	ldi r16, 65 // Dividend
	ldi r17, 4 // Divisor

	ldi r18, 0 // Quotient

	mov r19, r16 // FUTURE Remainder

	loop_eightBitDivision:
		// Exit loop if remainder < divisor
		cp r19, r17
		brlo endLoop_eightBitDivision
		
		// Subtract divisor, increment quotient
		sub r19, r17
		inc r18

		rjmp loop_eightBitDivision
	
	endLoop_eightBitDivision:
		rjmp end

sixteenBitDivision:
	ldi r17, high(haha) // MSB Dividend
	ldi r16, low(haha)  // LSB Dividend

	ldi r19, 0  // (Dummy) MSB Divisor
	ldi r18, low(lol) // LSB Divisor
		
	mov r25, r17 // MSB Remainder
	mov r24, r16 // LSB Remainder

	ldi r27, 0 // MSB Quotient
	ldi r26, 0 // LSB Quotient
	
	loop_sixteenBitDivision:
		// Check if remainder < divisor; 16-bit remainder
		cp r24, r18
		cpc r25, r19
		 
		brlo endLoop_sixteenBitDivision

		// 16 bit subtraction
		sub r24, r18
		sbci r25, 0

		// Increment quotient
		adiw r27:r26, 1

		rjmp loop_sixteenBitDivision
	
	endLoop_sixteenBitDivision:
		rjmp end

end:
	rjmp end
