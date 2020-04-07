;
; lab03-C.asm
;
; Created: 7/04/2020 1:49:52 PM
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
	Left Button - PB0
	Right Button - PB1
*/

.include "m2560def.inc"

.macro StartDebouncer
	ldi r18, 0

	clr r17
	out TCNT0, r17 // Clear the timer
	clr r19 // Clear the tick

	// Enable the timer
	ldi r17, 1<<TOIE0
	sts TIMSK0, r17 ; Set the TOIE0 bit to 1
.endmacro

.macro StopDebouncer
	// Disable the timer
	clr r17
	sts TIMSK0, r17 ; Set the TOIE0 bit to 0

	ldi r18, 1
.endmacro

.cseg
.org 0x0000
	jmp start

.org INT0addr
	jmp EXT_INT0
.org INT1addr
	jmp EXT_INT1
.org OVF0addr
	jmp Timer0OVF

start:
init:
	ser r16
	out ddrc, r16 // LEDs 1-8

	clr r16 // Counter
	
	/* SETUP interrupt */
		// Setup interrupt check type
		ldi r17, 0b00001010 // Falling edge for INT1 and INT0
		sts EICRA, r17

		// Enable interrupts INT1 and INT0
		ldi r17, 0b00000011
		out EIMSK, r17
	/* END SETUP interrupt */

	/* SETUP timer */
		// Set everything in TCCR0A to 0
		clr r17
		out TCCR0A, r17

		ldi r17, 0b00000010
		out TCCR0B, r17 ; Clock Select Bit = clk_io / 8
	/* END SETUP timer */

	ldi r18, 1 // 0 - Not ready; 1 - Ready for input

	sei ; Global Interrupt - Enable I bit in Status Register

loop:
	out portc, r16
	rjmp loop

EXT_INT0:
	tst r18 // Check if input ready
	breq EXT_INT_RET

	StartDebouncer
	inc r16
	reti

EXT_INT1:
	tst r18 // Check if input ready
	breq EXT_INT_RET

	StartDebouncer
	dec r16
	reti

EXT_INT_RET:
	reti

/* Routine is called every time the timer interrupt is called (128us) */
Timer0OVF:
	inc r19
	cpi r19, 156 // 20ms ; 10^6 / 128 * 0.02

	brne Timer0OVF_end
	StopDebouncer

	Timer0OVF_end: reti
