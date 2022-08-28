; For debugging in the simulator
; Output should be:
; dtZ80 Bios V 0.1>test
	
	ld sp,stackpointer

	call INIT_RAM
		
	ld hl,STARTUP_STR
	call LCD_MESSAGE
	ld a,CR;activates serial mode
	call RX_CHA_AVAILABLE
	ld a,'t'
	call RX_CHA_AVAILABLE
	ld a,'e'
	call RX_CHA_AVAILABLE
	ld a,'s'
	call RX_CHA_AVAILABLE
	ld a,'t'
	call RX_CHA_AVAILABLE
	ld a,CR
	ld a,LF
	call RX_CHA_AVAILABLE
	halt
