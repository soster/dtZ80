; For debugging in the simulator
; Output should be:
; dtZ80 Bios V 0.1>test
	
	ld sp,stackpointer

	call INIT_RAM
		
	ld hl,STARTUP_STR
	call LCD_MESSAGE
	
	ld a,CR;activates serial mode
	call RX_CHA_AVAILABLE
	ld hl,TEST_STR
    
BEGIN_TEST:	
	ld a,(HL)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,TEST_END		;If 0 then end.
	push hl
	call RX_CHA_AVAILABLE
	pop hl
	inc hl				;Next character
	jr BEGIN_TEST		;Continue loop
TEST_END:
	halt	

TEST_STR:
        db 'Dies ist ein Test.',CR,LF,'Und noch so ein Test.',CR,LF,0