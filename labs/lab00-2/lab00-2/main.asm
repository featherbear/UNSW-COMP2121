;
; lab00-2.asm
;
; Created: 25/02/2020 11:54:01 AM
; Author : Andrew
;


.include "m2560def.inc"
start:
	ldi r16, 200
	ldi r17, 100
	add r16, r17
halt:
	rjmp halt