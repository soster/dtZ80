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

        call A_RTS_OFF

        call LCD_CLEAR

        call POST

        ; clear ram
        ld hl,TEXT_BUFFER
        ld a,0
        ld bc,$0009
        call FILL_RAM
        ; end clear ram

        ld a,00000000b
        ld (SPECIAL_FLAGS),a; initialize flags, e.g. ascii mode

        call LCD_RESET

 
        call LCD_PREPARE
        ld hl,STARTUP_STR
        call LCD_MESSAGE
        ld hl,SERIAL_STARTUP_STR
        call SERIAL_MESSAGE



        ld a,0             	 	; set high byte of interrupt vectors to point to page 0
        ld i,a

        im 2               		; set int mode 2
        ei                      ; enable interupt


ENDLESS_LOOP:        
        jp ENDLESS_LOOP



RX_CHA_AVAILABLE:
        ex af,af'		;save registers
        exx		       ;save registers
        IN   A,(SIO_DA)        ;read RX character into A        
        out (SIO_DA),a         ;echo char to transmitter
        push af
        call TX_EMP            ; wait for outgoing char to be sent
        pop af        

        ; FIXME ------------------
        ld hl,SPECIAL_FLAGS
        ld b,(hl)    ; test if ascii flag is set
        bit 0,b                 ; most right bit set?
        jr nz,CONTINUE_ASCII_MODE; if yes, z is not set...

        cp CR                       ; a=Enter key from serial?
        jr z,SET_ASCII_FLAG       ; if yes, simulate new line
        ; FIXME ------------------

        LD      HL,SCAN_LOOKUP     ; fetch scancode from lookup table
        LD      B,0
        LD      C,A
        ADC     HL,BC
        LD      A,(HL)

CONTINUE_ASCII_MODE:    
        ld  hl,TEXT_BUFFER
        ld  (hl),a        
        call  LCD_MESSAGE
        jr END_RX_CHA_AVAILABLE
SET_ASCII_FLAG:
        ; TODO
        LD hl,ASCII_MODE_STR
        call SERIAL_MESSAGE
        ; FIXME ------------------
        ld a,(SPECIAL_FLAGS)       
        or 00000001b
        ld (SPECIAL_FLAGS),a
        ; FIXME ------------------

        
END_RX_CHA_AVAILABLE:
        call RX_EMP            ; flush receive buffer
        exx					;restore registers
        ex af,af'					;restore registers

        ei
        reti

SPEC_RX_CONDITON:
        jp $0000            ; if buffer overrun then restart the program




        include'dtz80-lib.inc'
        include'sio-ctc-init.inc'





ASCII_MODE_STR:
        db #0d,#0a,'dtZ80 serial    >',0

STARTUP_STR:
        db 'dtZ80 Bios V 0.1>',0

SERIAL_STARTUP_STR:
        db #0d,#0a,'dtZ80 Bios V 0.1 ENTER for serial mode>',0        

  
