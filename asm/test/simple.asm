; Outputs a simple 'X' to the simulator console
; This is just to check if the simulator works.
;
; compile with:
; rasm simple.asm simple
; Simulate with:
; z88dk-ticks -iochar 5 simple.bin
	
	org 0
	ld sp,STACK
	ld a,'X'
	out (5),a
	ld a,10
	out (5),a
	halt
STACK: