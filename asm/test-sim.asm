; Tests different routines with the z80sim simulator
; 
	org 0
	ld sp,$ffff
	ld a,'c'
	
	out (5),a
	ld a,64
	
	out (5),a


	halt

	include 'dtz80-lib.inc'
	