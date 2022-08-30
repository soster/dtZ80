;BIOS for my dtz80 Z80 computer
;rasm bios.asm bios && minipro -p "at28c256" -w bios.bin -s
;assemble with symbols:
;rasm -s -sa bios.asm bios
;debugging with z88dk ticks:
;z88dk.ticks -iochar 5 bios.bin
;with symbols:
;z88dk.ticks -x bios.sym -pc 0 -d -iochar 5 bios.bin

;set debug=1 for simulator debugging in ticks:
DEBUG = 0

RESET:
        org 0
if      DEBUG
print   "**DEBUG MODE**"
        jp MAIN_DEBUG
else
print   "**PRODUCTION MODE**"
        jp MAIN
endif
        ; interrupt vector for SIO
        org $0c
        defw RX_CHA_AVAILABLE
        org $0E
        defw SPEC_RX_CONDITON

;---------------------------------------------------
ifnot   DEBUG
        ; Main code
        org $0100           ; main code starts at $0100 because of interrupt vector!
MAIN:
        ld sp,stackpointer
        call SET_CTC         	; configure CTC
        call SET_SIO         	; configure SIO

        call A_RTS_OFF

        call LCD_CLEAR

        call POST

        call INIT_RAM

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
endif

;for debugging / simulation purposes:
if      DEBUG
        org $0100
MAIN_DEBUG:
        include 'debug-bios.inc'
endif


INIT_RAM:
        ; clear ram
        ld hl,CHAR_BUFFER
        ld a,0
        ld bc,FILL_RAM_SIZE
        call FILL_RAM
        ret
        ; end clear ram





;-----------------------------
;Character over serial arrives.
;Can be either via the ps2 keyboard adapter
;Or via a serial connection to another device.
;ps/2 needs special mapping of characters.
;SPECIAL_FLAGS bit 0 = 1 if serial.
RX_CHA_AVAILABLE:
ifnot   DEBUG
        ex af,af'	        ;save registers
        exx		        ;save registers
        in a,(SIO_DA)         ;read RX character into A        
endif


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
; common code for serial and ps2:
CONTINUE_COMMON_MODE:
        ld hl,CHAR_BUFFER      ;Load address of CHAR_BUFFER into hl
        ld (hl),a              ;Load value of a into CHAR_BUFFER        
        call NEW_CHARACTER     ;Handle new entered character in a
        jr END_RX_CHA_AVAILABLE
SET_SERIAL_FLAG:
        ld hl,SERIAL_MODE_STR
        call SERIAL_MESSAGE
        ld a,(SPECIAL_FLAGS)
        or 00000001b            ;set flag for serial mode
        ld (SPECIAL_FLAGS),a

END_RX_CHA_AVAILABLE:
ifnot   DEBUG
        call RX_EMP             ;flush receive buffer
        exx		        ;restore registers
        ex af,af'		;restore registers
        ei
        reti
else
        ret
endif

; new character in a and (hl)
NEW_CHARACTER:
        out (SIO_DA),a         ;output character to serial
        cp CR                  ;Enter?
        jr nz,NO_LF            ;If not, continue with NO_LF
        ld a,LF                ;a=line feed
        out (SIO_DA),a         ;output additional LF to serial
        call CHECK_OPCODE      ;ENTER pressed, check opcode
        ld a,0
        ld (CHAR_COUNTER),a    ;reset opcode counter after enter
        jr CONT_OUTPUT         ;If ENTER, do not store it as opcode

NO_LF:                         ;skip line feed
        call STORE_OPCODE
CONT_OUTPUT:
        call LCD_MESSAGE       ;echo a to LCD       
        call TX_EMP
        ret
;-----------------------------

; Stores the character in CHAR_BUFFER
; Into (LAST_OPCODE + CHAR_COUNTER)
STORE_OPCODE:       
        ld a,(CHAR_BUFFER)
        cp FIRST_NON_WHTSPC
        jr c, RESET_OPCODE       ; a was less than the FIRST_NON_WHTSPC.

        push hl
        ld a,(CHAR_COUNTER)
        ld hl,LAST_OPCODE
        ld b,0
        ld c,a
        adc hl,bc               ; add CHAR_COUNTER to LAST_OPCODE
        ld a,(CHAR_BUFFER)
        ld (hl),a               ; Put current char into LAST_OPCODE
        ld a,(CHAR_COUNTER)
        pop hl

        inc a                   ; increment counter
        cp OPCODE_LENGTH        ; smaller than OPCODE_LENGTH?
        jr C,INC_OPCOUNTER      ; if yes, jump over ret and store incd counter
        ret
INC_OPCOUNTER:        
        ld (CHAR_COUNTER),a     ; store incremented counter
        ret
RESET_OPCODE:
        ld a,0
        ld (CHAR_COUNTER),a
        ld (LAST_OPCODE),a
        ld (LAST_OPCODE+1),a
        ret

; Check if the last opcode means something
; Stored in LAST_OPCODE
CHECK_OPCODE:
        ld hl,LAST_OPCODE       ; last opcode
        ld de,OC_CLEAR          ; opcode to compare
        ld b,0                  ; bc=string length
        ld c,OPCODE_LENGTH
        call STRCMP
        jr nz,CHECK_OC2
        call LCD_CLEAR
CHECK_OC2
        ret

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
        ;jp $0000            ; if buffer overrun then restart the program
        call RX_EMP
        call TX_EMP
        reti

        include 'dtz80-lib.inc'
        include 'lcd-lib.inc'
        include 'sio-ctc-init.inc'

SERIAL_MODE_STR:
        db CR,LF,'dtZ80 serial>',0

STARTUP_STR:
        db 'dtZ80 Bios V 0.1>',0

SERIAL_STARTUP_STR:
        db CR,LF,'dtZ80 Bios V 0.1 ENTER for serial mode>',0


