;
; lab04-B.asm
;
; Created: 14/04/2020 2:16:36 PM
; Author : Andrew
;

/*
Connect the strobe LED to OC3B (labelled PE2 on the board).
Note that this pin labelled PE2 has been done so by a mistake and it is actually connected to PE4 pin of the microcontroller.

Use timer 3 in PWM mode to control the average voltage supplied to the strobe LED.  
The LED should fade from full brightness to completely off each second. 
The average voltage supplied should decrease linearly. 

For generating a delay to update the PWM duty cycle, you may use a software delay (using software loop) or another timer such as timer0.
*/

;
; lab00-4 part b.asm
;
; Created: 14-Apr-20 2:13:57 PM
; Author : andre
;

// calculate speed of motor
// display speed on LEDs 
// update speed every 500ms 

// when IR light from emitter OpE goes through a hole, detector OpO outputs 0
// when IR light from emitter OpE does not go through hole, detector OpO outputs 1
// use falling edge of detector to trigger interrupt to count holes 
// OpO - connect to port pin - set as input

;
; lab00-4 part b.asm
;
; Created: 14-Apr-20 2:13:57 PM
; Author : andre
;

// calculate speed of motor
// display speed on LEDs 
// update speed every 500ms 

// when IR light from emitter OpE goes through a hole, detector OpO outputs 0
// when IR light from emitter OpE does not go through hole, detector OpO outputs 1
// use falling edge of detector to trigger interrupt to count holes 
// OpO - connect to port pin - set as input

.include "m2560def.inc" 

.equ HOLES_PER_REV = 4
.equ pattern = 0x00

.def temp = r17

.macro clearWord // sets value to zero 
	clr r17
	sts @0, r17
	sts @0+1, r17
.endmacro

.dseg
RevCount: // to count revs
	.byte 1
TempCounter: // to check time
	.byte 2
HoleCount: // to count holes
	.byte 1

.cseg 
// interrupt vector table and relevant interrupt service routines
.org 0x0000
	jmp start
.org INT2addr
	jmp INT2_ISR
.org OVF0addr
	jmp Timer0OVF

start:
	// stack shit
	ldi YH, high(RAMEND)
	ldi YL, low(RAMEND)
	out SPH, YH
	out SPL, YL

	// set PORT D for input
	clr temp // 0's 
	out DDRD, temp
	// set PORT C and G for output - LEDs
	ser temp // 1's
	out DDRC, temp
	out DDRG, temp

	ldi temp, (2 << ISC20) // set INT2 to falling edge interrupt - ISC21 = 1, ISC20 = 0 
	sts EICRA, temp // external interrupt control register A - for INT3:0, EICRB - for INT7:4

	ldi temp, (1 << INT2) // enable INT2 interrupt
	out EIMSK, temp

	clr temp 
	out TCCR0A, temp

	ldi temp, 0b00000010
	out TCCR0B, temp // timer prescaler = 8
	ldi temp, 1<<TOIE0
	sts TIMSK0, temp // overflow interrupt enable


	sei // set global interrupt

end:
	rjmp end

Timer0OVF:
	lds r24, TempCounter
	lds r25, TempCounter+1
	adiw r25:r24, 1

	lds r26, RevCount

	// microcontroller @ 16MHz
	// prescaler = 8
	// 256 * clock_period = 256*8/16MHz = 128us
	// timer overflow interrupt occurs every 128us
	// in one second there are 1/(128x10-6) ~= 7812 interrupts

	cpi r24, low(1953) // change to 3906 for 0.5s - 1953 for 0.25s
	ldi temp, high(1953)
	cpc r25, temp
	breq timer_tick // if 0.5s reached, need to output the rev count to leds
	// if 0.5s not reached yet keep counting 
	
	sts TempCounter, r24
	sts TempCounter+1, r25

	reti 

	timer_tick:
		clearWord TempCounter // set temp counter to zero
		rcall update_leds
		clr r26 // after updating leds, rev count is cleared
		sts RevCount, r26
	reti

update_leds:
	lds r1, RevCount // display rev count
	out PORTC, r1
	ret

// this interrupt runs each time a hole is detected
// 4x interrupts for one revolution - equal to no. holes per 250ms
INT2_ISR: 
	in temp, SREG
	push temp
	push r27
	push r26

	// increment rev count
	lds r26, RevCount
	lds r27, RevCount+1
	adiw r27:r26, 1
	sts RevCount, r26
	sts RevCount+1, r27

	// clear interrupt flag register
	clr temp
	out EIFR, temp
	
	pop r26
	pop r27
	pop temp
	out SREG, temp
	reti