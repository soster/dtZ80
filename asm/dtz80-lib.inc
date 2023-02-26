;Library for the dtz80 computer rev. 1
;Uses the SIO, CTC
;start with:
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
    equ $43; SIO Control Channel B
SIO_DA
    equ $40; SIO Data Channel A
SIO_DB
    equ $41; SIO Data Channel B


;Soundchip Addresses
SOUND_REGISTER
    equ $80
SOUND_DATA
    equ $81

CR  equ $0d
LF  equ $0a
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

; if not 0, then start new song
RESET_SONG
	equ $f002
;Only works if copied into RAM:
RAM_DEST
	equ $8000
RAMCELL
	equ $f000
  

;7 segment numbers,0-9:
numbers:
    db $3f,$6,$5b,$4f,$66,$6d,$7d,$7,$7f,$6f,0    

; opcodes
OC_CLEAR:
    db "CL"
OC_VERSION
    db "VS"
OC_RESET
    db "RS"
OC_PLAY
    db "PL"
OPCODE_LENGTH 
    equ 2

;first non whitespace
FIRST_NON_WHTSPC
    equ $21

; variables in ram:
CHAR_BUFFER:
    equ $8000               ;holds the current character + 0 (2 Bytes!)
CURSOR_LINE:
    equ CHAR_BUFFER + 2     ;current line of the lcd cursor
CURSOR_COLUMN:
    equ CURSOR_LINE + 1     ;current column of the lcd cursor
SPECIAL_FLAGS
    equ CURSOR_COLUMN + 1   ;special flags: 76543210
                            ;0:serial mode (not ps2)
LINE_BUFFER:                ;20 characters
    equ SPECIAL_FLAGS + 1
LAST_OPCODE:                ;opcode always 2 characters, no leading zero
    equ LINE_BUFFER + 20;
CHAR_COUNTER:
    equ LAST_OPCODE + 2;
FILL_RAM_SIZE               ;how many bytes do we have to initialize?             
    equ CHAR_COUNTER+1-CHAR_BUFFER



;subroutines:

;startup initializations
startup:
    ld sp,stackpointer
    ret


; do a little post message on the seven segment display
; Sequence: 0 - 1 - 8
POST:
    ld a,0
    call SEGPRINT_NUM
    call delay
    ld a,1
    call SEGPRINT_NUM
    call delay
    ld a,8
    call SEGPRINT_NUM
    call delay
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




; Short delay:
DELAY_SHORT:
    push af
    ld a,$aa
DELAY_SHORT_LOOP:
    dec a
    jr nz,DELAY_SHORT_LOOP
    pop af
    ret

;Visualization Music Player
INC_RAM_COUNTER:
RAM_COUNTER_SEGPRINT:
    ret

    
    include 'tools.inc'; algorithms / subroutines





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

