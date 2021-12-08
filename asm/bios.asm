;BIOS for my dtz80 Z80 computer
;rasm bios.asm bios && minipro -p "at28c256" -w bios.bin -s

RESET:
        org 0
        jp MAIN


        ; interrupt vector for SIO
        org $0c
        defw RX_CHA_AVAILABLE
        org $0E
        defw SPEC_RX_CONDITON

;---------------------------------------------------
        ; Main code
        org $0100           ; main code starts at $0100 because of interrupt vector!
MAIN:
	ld sp,stackpointer
	call SET_CTC         	; configure CTC
	call SET_SIO         	; configure SIO

	call  A_RTS_OFF

	call LCD_PREPARE
	ld hl,STARTUP_STR
	call LCD_MESSAGE

	ld a,0             	 	; set high byte of interrupt vectors to point to page 0
	ld i,a

	im 2               		; set int mode 2
	ei                      ; enable interupt


ENDLESS_LOOP:
        ld d,$ff
        call DELAY
        call ENDLESS_LOOP
	


RX_CHA_AVAILABLE:
		ex af,af'				 ;save registers
		exx					 ;save registers

		ld  a,(TEXT_COUNTER)
		inc  a
		ld  (TEXT_COUNTER),a
        
        in a,(SIO_DA)      ; read RX character into A

        ld hl,SCAN_LOOKUP     ; fetch scancode from lookup table
        ld b,0                
        ld c,a
        adc hl,bc
        ld a,(HL)


        out (SIO_DA),a      ; echo char to transmitter


        ;ld  hl,TEXT_BUFFER
        ;ld  (hl),a        
        ;call  LCD_MESSAGE
      
        out  (lcd_data),a
        call  LCD_WAIT_SHORT

        call TX_EMP          ; wait for outgoing char to be sent
        call RX_EMP            ; flush receive buffer



END_AVAILABLE		
        exx					;restore registers
	ex af,af'					;restore registers

        ei
        reti

SPEC_RX_CONDITON:
	jp $0000            ; if buffer overrun then restart the program



	include'dtz80-lib.inc'
	include'sio-ctc-init.inc'

STARTUP_STR:
	db 'dtZ80 Bios V 0.1 >',0
TEXT_BUFFER:
	db 0,0,0,0
TEXT_COUNTER:
	db 0
RAMCELL:
	db 0