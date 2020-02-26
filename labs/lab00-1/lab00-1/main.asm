;
; lab00-1.asm
;
; Created: 25/02/2020 11:50:52 AM
; Author : Andrew
;


; Replace with your application code
.include "m2560def.inc"

start:
	ldi r16, 8
	ldi r17, 9
halt:
	rjmp halt
