;Library for my dtz80 computer
;Uses the SIO, CTC and 4 line LCD 2004A based on the HD44780 (?)
;4 line lcd: http://www.ekenrooi.net/lcd/lcd0.shtml#_4_line_displays
;LCD: https://www.sparkfun.com/datasheets/LCD/HD44780.pdf
;Start your program with:
;ORG 0
;ld  sp,STACKPOINTER

;Constants
STACKPOINTER
    equ $ffff;Address for the stack pointer. Init with "ld  sp,STACKPIONTER"
SEVENSEGO
    equ $00;I/O port 7 segment A0-A7=0
LCD_COMMAND
    equ $04;LCD command I/O port, A5=1
LCD_DATA
    equ $05;LCD data I/O port,A5=1,A0=1


;; CTC Addresses
CTC_CH0
    equ $60
CTC_CH1
    equ $61
CTC_CH2
    equ $62
CTC_CH3
    equ $63

; SIO Addresses
SIO_CA
    equ $42; SIO Control Channel A
SIO_CB
    equ $43; Not used
SIO_DA
    equ $40; SIO Data Channel A
SIO_DB
    equ $41; Not used


;Soundchip Addresses
SOUND_REGISTER
    equ $80
SOUND_DATA
    equ $81

RAM_COUNTER
    equ $b000   ; Address for a counter in RAM  

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font (only 2 or 1 line mode possible)
;$0f: Display on, cursor on (alt: Display on, cursor off = $0C), Display off = $08
;$01: Clear display
;$06: Entry mode: left to right, no shift <- don't do this for 4 line mode!
;$80: DRAM Counter to 0 ($80+ADDR)
;ff terminated.
LCD_COMMANDS:
    db $3f,$0c,$01,$80,$ff

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift
;ff terminated.
LCD_COMMANDS_CURSOR:
    db $37,$0f,$01,$06,$ff

; For compatibility with 2 line displays there is some weird adressing going on,
; line 2 starts at $40 and line 4 at $54. For a 2 line display use only $00 and $14.
; addresses are $00,$40,$14,$54 or'd with $80. $80 is bit #7 set to high, rest of the bits are the address.
LCD_LINE_ADDR:
    db $80,$c0,$94,$d4
;Number of lines in LCD
LCD_LINES
    equ $04

;7 segment numbers,0-9:
numbers:
    db $3f,$6,$5b,$4f,$66,$6d,$7d,$7,$7f,$6f,0

message:
    db "HELLO WORLD!",0

;subroutines:

;startup initializations
startup:
    ld sp,stackpointer
    ret

; 3 cascaded 8 bit loops to create some 100ms delay
DELAY:
    push de
    push bc
    ld e,$6
loop1
    ld b,$40
loop2
    ld d,$ff
loop3
    dec d
    jp nz,loop3
    dec b
    jp nz,loop2
    dec e
    jp nz,loop1
    pop bc
    pop de
    ret

;interpret a as a number 0-9 and translate it to the 7seg byte
SEGPRINT_NUM:
    ld hl,numbers
    ld b,0
    ld c,a
    add hl,bc
    ld a,(HL)
    out (SEVENSEGO),a
    ret


LCD_SET_RAM_ADDR:
    call LCD_WAIT
    or $7f;For setting dram address highest bit = 1
    out (LCD_COMMAND),a
    call LCD_WAIT
    ret


; Sends the init commands to the lcd
; Ues HL, AF
LCD_PREPARE:
    ld hl,LCD_COMMANDS      ;Address of command list for LCD, $ff terminated
LCD_COM_LOOP:

    ld a,(HL)           ;Next command
    inc a               ;Add 1 so we can test for $ff...
    jr z,LCD_COM_END    ;...by testing for zero
    dec a               ;Restore the actual value
    out (LCD_COMMAND),a ;Output it.
    call LCD_WAIT

    inc hl              ;Next command
    jr LCD_COM_LOOP     ;Repeat
LCD_COM_END:
    ret



; Sends the init commands to the lcd
; Ues HL, AF
LCD_PREPARE_CURSOR:
    ld hl,LCD_COMMANDS_CURSOR      ;Address of command list for LCD, $ff terminated
LCD_COM_LOOP2:

    ld a,(HL)           ;Next command
    inc a               ;Add 1 so we can test for $ff...
    jr z,LCD_COM_END2    ;...by testing for zero
    dec a               ;Restore the actual value
    out (LCD_COMMAND),a ;Output it.
    call LCD_WAIT
    inc hl              ;Next command
    jr LCD_COM_LOOP2     ;Repeat
LCD_COM_END2:
    ret

; Send a message to the LCD
; Expects the pointer in HL
; Message terminated by 0
; Uses HL, AF, BC
LCD_MESSAGE:
    ld b,0;column
    ld c,0;line
LCD_MESSAGE_BEG:
    ld a,(HL)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,MESSAGE_END
    out (lcd_data),a    ;Output the character
    call LCD_WAIT
    inc hl              ;Point to next character
    inc b               ; INC character counter
    ld a,b             ; Load num of characters into A
    cp $14;            ; $14=first of next line
    jp z,MESSAGE_NEW_LINE
    jr LCD_MESSAGE_BEG ;Loop back for next character
MESSAGE_NEW_LINE:
    push hl
    ld b,0;Reset character counter
    inc c;inc line counter
    ld hl,LCD_LINE_ADDR;holds the lcd addresses for the 4 lines
    add hl,bc;b already is 0, c has line counter in it!
    ld a,(HL); Load new address for LCD Line
    out (LCD_COMMAND),a;set new character pos address
    call LCD_WAIT
    ld a,c
    cp LCD_LINES; line counter = num of lines?
    jp z,MESSAGE_RESET_LINE
MESSAGE_NEW_LINE_END:
    pop hl
    jr LCD_MESSAGE_BEG
MESSAGE_RESET_LINE:
    ld c,0; Reset line counter
    jr MESSAGE_NEW_LINE_END
MESSAGE_END:
    ret


; Send a message to the LCD
; Expects the pointer in HL
; Message terminated by 0
; Uses HL, AF
LCD_MESSAGE_OLD:
    call LCD_WAIT
    ld a,(HL)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,MESSAGE_END_OLD
    out (lcd_data),a    ;Output the character
    inc hl              ;Point to next character
    jr LCD_MESSAGE     ;Loop back for next character
MESSAGE_END_OLD:
    ret




LCD_CLEAR:
    ld a,$01;
    out (LCD_COMMAND),a
    call LCD_WAIT
    ret



; Wait passively for the lcd to execute the last command
; Also resets the stored value on the data lines
LCD_WAIT:
    push af
    ld a,$ff
lcd_wait_loop:
    dec a
    jr nz,lcd_wait_loop

    ld a,$ff
lcd_wait_loop2:
    dec a
    jr nz,lcd_wait_loop2

    ld a,0
    out (SEVENSEGO),a;reset output so that the lcd can acknowledge the last value
    pop af
    ret


; Wait passively for the lcd to execute the last command
; Also resets the stored value on the data lines
LCD_WAIT_SHORT:
    push af
    ld a,$aa
lcd_wait_loop3:
    dec a
    jr nz,lcd_wait_loop3
    ld a,0
    out (SEVENSEGO),a;reset output so that the lcd can acknowledge the last value
    pop af
    ret


CR  equ 0
L_SHIFT
    equ 0
R_SHIFT
    equ 0
CAPS_LOCK
    equ 0
NUM_LOCK
    equ 0
BACK_SPACE
    equ $08
ESC equ 0
L_CTRL
    equ 0
SPACE
    equ $20

KEY_1
    equ $16
KEY_2
    equ $1e
KEY_3
    equ $26
KEY_4
    equ $25
KEY_5
    equ $2e
KEY_6
    equ $36
KEY_7
    equ $3d
KEY_8
    equ $3e
KEY_9
    equ $46
KEY_0
    equ $45

;Increment the counter
INC_RAM_COUNTER:
    push af     ;save af
    ld a,(ram_counter)
    inc a
    ld (ram_counter),a
    pop af
    ret

;print ram counter to seven segment
RAM_COUNTER_SEGPRINT:
    push af
    ld a,(ram_counter)
    out (sevensego),a
    pop af
    ret


; Lookup table for the keyboard
SCAN_LOOKUP:
    db 0       ;FOR SCAN-CODE 0 WHICH DOES NOT EXIST, I
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 001 to 010
    db 0,0,0,0,0,0,0,0,L_SHIFT,L_CTRL     ; scan code 011 to 020
    db 'Q','1',0,0,0,'Z','S','A','W','2'     ; scan code 021 to 030
    db 0,0,'C','X','D','E','4','3',0,0     ; scan code 031 to 040
    db SPACE,'V','F','T','R','5',0,0,'N','B'     ; scan code 041 to 050
    db 'H','G','Y','6',0,0,0,'M','J','U'     ; scan code 051 to 060
    db '7','8',0,0,'<','K','I','O','0','9'     ; scan code 061 to 070
    db 0,0,'>','?','L',':','P','_',0,0     ; scan code 071 to 080
    db 0,'"',0,'{','+',0,0,CAPS_LOCK,R_SHIFT,CR     ; scan code 081 to 090
    db '}',0,'|',0,0,0,0,0,0,0     ; scan code 091 to 100
    db 0,BACK_SPACE,0,0,0,0,0,0,0,0     ; scan code 101 to 110
    db 0,0,0,0,0,0,0,ESC,NUM_LOCK,0     ; scan code 111 to 120
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 121 to 130
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 131 to 140
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 141 to 150
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 151 to 160
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 161 to 170
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 171 to 180
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 181 to 190
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 191 to 200
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 201 to 210
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 211 to 220
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 221 to 230
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 231 to 240
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 241 to 250
    db 0,0,0,0,0,0,0,0,0,0     ; scan code 251 to 260

