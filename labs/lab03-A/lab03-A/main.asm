;
; lab03-A.asm
;
; Created: 31/03/2020 1:45:33 PM
; Author : Andrew
;

/*
	LED0 - PC0
	LED1 - PC1
	LED2 - PC2
	LED3 - PC3
	LED4 - PC4
	LED5 - PC5
	LED6 - PC6
	LED7 - PC7
	LED8 - PG0
	LED9 - PG1
*/

.include "m2560def.inc"

.equ floor_number = 10

start:
init:
	ser r16
	ldi r17, 0b00000011

	out ddrc, r16 // LEDs 1-8
	out ddrg, r17 // LEDs 9-10

	ldi r16, floor_number
	rcall display_leds

end:
	rjmp end

display_leds:
	// arg: r16 - led to show

	// r19 - high(16 bit register)
	// r18 - low(16 bit register)

	push r19
	push r18
	push r0

	clr r0 // Counter
	inc r0
	
	clr r19
	ldi r18, 1
    
	display_leds_loop:
		cp r16, r0
		breq display_leds_loopEnd

		lsl r18
		rol r19
		inc r18 // Add the next bit

		/*
		lsl r19
		inc r19
		lsl r18
		adc r19, r0
		*/

		inc r0
		rjmp display_leds_loop

	display_leds_loopEnd:

	out portc, r18
	out portg, r19

	pop r0
	pop r18
	pop r19

	ret
	