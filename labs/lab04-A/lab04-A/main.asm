;
; lab04-A.asm
;
; Created: 14/04/2020 12:59:10 PM
; Author : Andrew
;

;The keypad represents the floor select buttons on the lift.  
;
;Write a program to detect keypad presses and display the floor numberon the LED bar.
;
;Keys 1-9 to represent floors 1-9 and key 0 represents the 10th floor. 
;The other buttons do not need to be handled. 
;The keypad should be connected to PORTL, with none of the wires crossed over (same as in the board testing sheet).
;
;The low 4 bits will be connected to the rows, and the high 4 bits will be used to read the column outputs.
;You will need to activate the pull-up resistors on the input pins to reliably detect key presses.

;;;;;;;;;;;;;;;;;;;;; PSEUDO CODE FOR READING ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;init:
;  for column:
;    set column to INPUT // disabled bc grounded
;    for row:
;      set row to INPUT // disabled bc grounded
;
;read:
;  for column:
;    column set to OUTPUT; set to LOW - GND
;    for row:
;      row set to INPUT_PULLUP, digitalRead, then set back to INPUT (GND)
;    column set to INPUT
;
;         5 V
;          |
;          R
;          |
;   ---------------
;  /
;  |
; GND
;
; Pullup resistor is connected to 5V
; When the switch is closed, the circuit is grounded
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.include "m2560def.inc"
.def temp =r16
.def row =r17
.def col =r18
.def mask =r19
.def temp2 =r20
.equ PORTLDIR = 0xF0
.equ INITCOLMASK = 0xEF
.equ INITROWMASK = 0x01
.equ ROWMASK = 0x0F


start:
	init_stack:
		// Set up stack pointer
		ldi YH, high(RAMEND)
		ldi YL, low(RAMEND)
		out SPH, YH
		out SPL, YL


	init_display_leds:
		ser r16
		ldi r17, 0b00000011

		out ddrc, r16 // LEDs 1-8
		out ddrg, r17 // LEDs 9-10

	init_keypad:
		ldi temp, PORTLDIR ; columns are outputs, rows are inputs
		STS DDRL, temp     ; cannot use out




/* --------------- KEYPAD -------------- */

main:
	ldi mask, INITCOLMASK ; initial column mask
	clr col ; initial column

colloop:
	STS PORTL, mask ; set column to mask value (sets column 0 off)
	ldi temp, 0xFF ; implement a delay so the hardware can stabilize
	
delay:
	dec temp
	brne delay
	LDS temp, PINL ; read PORTL. Cannot use in 
	andi temp, ROWMASK ; read only the row bits
	cpi temp, 0xF ; check if any rows are grounded
	breq nextcol ; if not go to the next column
	ldi mask, INITROWMASK ; initialise row check
	clr row ; initial row
	
rowloop:      
	mov temp2, temp
	and temp2, mask ; check masked bit
	brne skipconv ; if the result is non-zero, we need to look again
	rcall convert ; if bit is clear, convert the bitcode
	rcall display_leds
	jmp main ; and start again
	










															skipconv:
																inc row ; else move to the next row
																lsl mask ; shift the mask to the next bit
																jmp rowloop          

															nextcol:     
																cpi col, 3 ; check if we are on the last column
																breq main ; if so, no buttons were pushed,
																; so start again.
																; else shift the column mask:
																sec ; We must set the carry bit
																rol mask ; and then rotate left by a bit,
																; shifting the carry into
																; bit zero. We need this to make
																; sure all the rows have
																; pull-up resistors
																inc col ; increment column value
																jmp colloop ; and check the next column
																; convert function converts the row and column given to a
																; binary number and also outputs the value to PORTC.
																; Inputs come from registers row and col and output is in
																; temp.
	
															convert:
																cpi col, 3 ; if column is 3 we have a letter
																breq letters
																cpi row, 3 ; if row is 3 we have a symbol or 0
																breq symbols
																mov temp, row ; otherwise we have a number (1-9)
																lsl temp ; temp = row * 2
																add temp, row ; temp = row * 3
																add temp, col ; add the column address
																; to get the offset from 1
																inc temp ; add 1. Value of switch is
																; row*3 + col + 1.
																jmp convert_end
	
															letters:
																ldi temp, 0xA
																add temp, row ; increment from 0xA by the row value
																jmp convert_end
	
															symbols:
																cpi col, 0 ; check if we have a star
																breq star
																cpi col, 1 ; or if we have zero
																breq zero
																ldi temp, 0xF ; we'll output 0xF for hash
																jmp convert_end
	
															star:
																ldi temp, 0xE ; we'll output 0xE for star
																jmp convert_end
	
															zero:
																clr temp ; set to zero
	
															convert_end:
																ret ; return to caller








/* ---------------- LED ---------------- */
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
	