;
; lab03-B.asm
;
; Created: 6/04/2020 11:23:18 PM
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

.macro clearWord
	clr r17
	sts @0, r17
	sts @0+1, r17
.endmacro

.dseg
	TempCounter:    .byte 2 ; Holds the number of ticks

.cseg
.org 0x0000
	jmp start
.org OVF0addr
	jmp Timer0OVF

.equ floor_number = 5

start:
init:
	ser r16
	ldi r17, 0b00000011
	out ddrc, r16 // LEDs 1-8
	out ddrg, r17 // LEDs 9-10

	ldi r16, floor_number
	clr r15 ; r15 = 0 -> DOWN
	inc r15 ; r15 = 1 -> UP

	/* SETUP timer */
	clearWord TempCounter

	clr r17
	out TCCR0A, r17

	ldi r17, 0b00000010
	out TCCR0B, r17 ; Clock Select Bit = clk_io / 8

	ldi r17, 1<<TOIE0
	sts TIMSK0, r17 ; Set the TOIE0 bit to 1

	sei ; Global Interrupt - Enable I bit in Status Register 
	/* END SETUP timer */

	// every 2 seconds; increase/decrease the floor number
					  ; if new floor is 10, set direction bit to down
					  ; if new floor is 1, set direction bit to up

loop:
	rjmp loop

// LOOP

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

		inc r0
		rjmp display_leds_loop

	display_leds_loopEnd:

	out portc, r18
	out portg, r19

	pop r0
	pop r18
	pop r19

	ret

// Post check - can't start on level 10
stepElevator:
	tst r15
	breq stepElevator_down ; Down
	stepElevator_up:
		inc r16
		cpi r16, 10
		breq stepElevator_set_direction_down
		rjmp stepElevator_end_decide

	stepElevator_down:
		dec r16
		tst r16
		breq stepElevator_set_direction_up
		rjmp stepElevator_end_decide

	stepElevator_end_decide:
		rcall display_leds
		ret

	stepElevator_set_direction_down:
	  dec r15
	  rjmp stepElevator_end_decide
	stepElevator_set_direction_up:
	  inc r15
	  rjmp stepElevator_end_decide

/* Routine is called every time the timer ticks */
Timer0OVF:
	// conflict register 24, 25
	lds r24, TempCounter
	lds r25, TempCounter+1

	adiw r25:r24, 1

	ldi r17, high(15624)
	cpi r24, low(15624)
	cpc r25, r17
	breq Timer0OVF_tick

	sts TempCounter, r24
	sts TempCounter+1, r25

	reti

Timer0OVF_tick:
	clearWord TempCounter
	call stepElevator

	reti