;
; lab04-C.asm
;
; Created: 21/04/2020 12:50:41 PM
; Author : Andrew
;
; Connect the strobe LED to OC3B (labelled PE2 on the board).
; Note that this pin labelled PE2 has been done so by mistake and is actually connected to PE4 pin of the microcontroller.  
;
; Use timer 3 in PWM mode to control the average voltage supplied to the strobe LED. 
; The LED should fade from full brightness to completely off each second. 
; The average voltage supplied should decrease linearly. 
; For generating a delay to update the PWM duty cycle, you may use a software delay (using software loop) or another timer such timer0.

.equ V = 74 // 50

.cseg
.org 0x0000
	jmp init

.org OVF0addr
	jmp Timer0OVF

init:


    ; Set PE4 / OC3B to output
	ldi r17, 0b10000
	out DDRE, r17

	;; The Output Compare Registers contain a 16-bit value that is continuously compared with the counter value (TCNTn).
	;; A match can be used to generate an Output Compare interrupt, or to generate a waveform output on the OCnx pin.
	;; The Output Compare Registers are 16-bit in size. 
	;; To ensure that both the high and low bytes are written simultaneously when the CPU writes to these registers, the access is performed using an 8-bit temporary High Byte Register (TEMP). 
	;; This temporary register is shared by all the other 16-bit registers.
	 
	; pg 152 r_PCPWM = log(TOP+1)/log(2)

	; Page 164
	  ; Set Output Compare Register 3 B value to
 	  ; 0x004A == 0b000000001001010
	  ;   | \
	  ;   |  LO
	  ;   HI
	  ldi r18, V
	  sts OCR3BL, r17
	  clr r17
	  sts OCR3BH, r17

	; Set Timer3 to Phase Correct PWM
	; Page 160 - datasheet
	  ; (1 << CS30)
	  ;  CSn2:0: Clock Select
	  ;  001 == clkIO/1 (No prescaling)
	ldi r17, (1 << CS30)
	sts TCCR3B, r17
	
	; Page 159 - datasheet
	  ; (1 << WGM30)
	  ;  Toggle on compare match
	; Page 158 - datasheet
  	  ; (1<<COM3B1)
  	  ;   If one or both of the COMnB1:0 bits are written to one, the OCnB output overrides the normal port functionality of the I/O pin it is connected to. 
	  ;   However, note that the Data Direction Register (DDR) bit corresponding to the OCnA, OCnB or OCnC pin must be set in order to enable the output driver.
	ldi r17, (1 << WGM30 | 1<<COM3B1)
	sts TCCR3A, r17 

	; Clear timer register
	clr r17
	sts TCNT3H, r17
	sts TCNT3L, r17


	// Enable timer0

	// Set everything in TCCR0A to 0
	clr r17
	out TCCR0A, r17

	ldi r17, 0b00000010
	out TCCR0B, r17 ; Clock Select Bit = clk_io / 8

	clr r19 ; Timer tick
	clr r20 ; mode - dec

	ldi r17, 1<<TOIE0
	sts TIMSK0, r17 ; Set the TOIE0 bit to 1

	sei

loop:
	rjmp loop

// Every 20 ms, change the PWM value
Timer0OVF:
	inc r19
	cpi r19, 156 // 20ms ; 10^6 / 128 * 0.02
	brne Timer0OVF_end
	clr r19

	cpi r20, 0 // Direction (0 - down; 1 - up)
	breq change_dec

	// Increment the PWM up to `V`
	change_inc:
		inc r18
		sts OCR3BL, r18 ; Store new PWM (LOW)

		// Change direction if r18 == V
		cpi r18, V
		brne Timer0OVF_end
		dec r20
		rjmp Timer0OVF_end

	change_dec:
		dec r18
		sts OCR3BL, r18 ; Store new PWM (LOW)

		// Change direction if r18 == 0
		cpi r18, 0
		brne Timer0OVF_end
		inc r20
		rjmp Timer0OVF_end

	Timer0OVF_end: reti
