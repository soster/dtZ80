; Outputs a simple 'X' to the simulator console
; compile with z80asm simple.asm
; start simulator with z80sim
; enter:
; r simple.hex
; g	
	
	org 0
	ld sp,STACK
	ld a,'X'
	out (1),a
	ld a,10
	out (1),a
	halt
STACK: