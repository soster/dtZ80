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

;Character over serial arrives.
;Can be either via the ps2 keyboard adapter
;Or via a serial connection to another device.
RX_CHA_AVAILABLE:
        ex af,af'	        ;save registers
        exx		        ;save registers
        in a,(SIO_DA)         ;read RX character into A        

        ld hl,SPECIAL_FLAGS     ; load address of special_flags into hl
        ld b,(hl)               ; load value of address into b
        bit 0,b                 ; most right bit set in value?
        jr nz,CONTINUE_SERIAL_MODE; if yes, z is not set, serial_mode...

        cp CR                      ; a=Enter key from serial?
        jr z,SET_SERIAL_FLAG       ; if yes, set serial flag...

; PS2 Mode:
        ld hl,SCAN_LOOKUP     ; fetch scancode from lookup table
        ld b,0                ; only use 8 bits from 16
        ld c,a                ;BC, Low Byte
        adc hl,bc              ;Add BC to HL
        ld a,(HL)
        jr CONTINUE_COMMON_MODE

CONTINUE_SERIAL_MODE:
        out (SIO_DA),a          ;echo char to transmitter
        cp CR                   ;Enter?
        jr nz,NO_LF            ;If not, continue with NO_LF
        ld a,LF                 ;Load LF
        out (SIO_DA),a          ;Echo LF to serial
NO_LF:
        push af
        call TX_EMP             ; wait for outgoing char to be sent
        pop af

; common code for serial and ps2:
CONTINUE_COMMON_MODE:
        ld hl,TEXT_BUFFER      ;Load address of text_buffer into hl
        ld (hl),a              ;Load value of text_buffer into a
        call LCD_MESSAGE       ;echo a to LCD
        jr END_RX_CHA_AVAILABLE
SET_SERIAL_FLAG:
        ld hl,SERIAL_MODE_STR
        call SERIAL_MESSAGE
        ld a,(SPECIAL_FLAGS)
        or 00000001b            ;set flag for serial mode
        ld (SPECIAL_FLAGS),a

END_RX_CHA_AVAILABLE:
        call RX_EMP             ;flush receive buffer
        call TX_EMP             ;flush send buffer
        exx		        ;restore registers
        ex af,af'		;restore registers
        ei
        reti

; sends a text in hl to the serial output channel A:
SERIAL_MESSAGE:
        ld a,(HL)           ;Load character into A
        and a               ;Test for end of string (A=0)
        jr z,SERIAL_MESSAGE_END
        inc hl              ;Point to next character
        out (SIO_DA),a      ;echo char to transmitter
        call TX_EMP         ;empty buffer
        jr SERIAL_MESSAGE          ;next char
SERIAL_MESSAGE_END:
        ret

SPEC_RX_CONDITON:
        jp $0000            ; if buffer overrun then restart the program

        include 'dtz80-lib.inc'
        include 'lcd-lib.inc'
        include 'sio-ctc-init.inc'


SERIAL_MODE_STR:
        db CR,LF,'dtZ80 serial>',0

STARTUP_STR:
        db 'dtZ80 Bios V 0.1>',CR,0

SERIAL_STARTUP_STR:
        db CR,LF,'dtZ80 Bios V 0.1 ENTER for serial mode>',0


