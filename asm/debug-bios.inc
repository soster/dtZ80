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
    jr z,TEST_STRCMP		;If 0 then end.
	push hl
	call RX_CHA_AVAILABLE
	pop hl
	inc hl				;Next character
	jr BEGIN_TEST		;Continue loop
TEST_STRCMP:			;should output 'equal'
	ld hl,STR_A
	ld de,STR_B
	ld b,0
	ld c,4
	call strcmp
	jr z, TEST_EQUAL
	ld hl,STR_NEQ
	call LCD_MESSAGE
	halt
TEST_EQUAL:
	ld hl,STR_EQ
	call LCD_MESSAGE
	halt	

TEST_STR:
        db 'Test.',CR,LF,'CL',CR,LF,0

STR_A:
	db '123',0

STR_B:
	db '123',0
STR_EQ:
	db 'equal',CR,LF,0
STR_NEQ:
	db 'not equal',CR,LF,0