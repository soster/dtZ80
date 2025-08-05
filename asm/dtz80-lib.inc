;Library for the dtz80 computer rev. 1
;Uses the SIO, CTC
;start with:
;ORG 0
;ld  sp,STACKPOINTER

;Constants
; Memory Map Constants
ROM_START       equ $0000
ROM_END         equ $7FFF
RAM_START       equ $8000
;RAM_END is set in bios.asm at the end of the code.
;RAM_END         equ $FFFF
STACK_TOP       equ $FFEF       ; Leave some space at top for I/O

STACKPOINTER
    equ STACK_TOP               ; Address for the stack pointer. Init with "ld  sp,STACKPOINTER"
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

; System Constants
BAUD_RATE       equ 19200
CPU_FREQ        equ 7372800


; Constants for the AY-3-8910A
AY_PORT_MODE        equ SOUND_REGISTER       ; Port address for mode
AY_PORT_CHANNEL_1   equ SOUND_REGISTER + 1   ; Port address for channel 1
AY_PORT_CHANNEL_2   equ SOUND_REGISTER + 2   ; Port address for channel 2
AY_PORT_CHANNEL_3   equ SOUND_REGISTER + 3   ; Port address for channel 3
AY_PORT_MIXER       equ SOUND_REGISTER + 6   ; Port address for mixer

; Pitch and volume for each channel
PITCH_CH1       equ 100    ; Pitch for channel 1
PITCH_CH2       equ 120    ; Pitch for channel 2
PITCH_CH3       equ 140    ; Pitch for channel 3
VOLUME          equ 15     ; Volume for all channels

; Melody notes (in pitch values)
NOTE_C4     equ 0x3C    ; Middle C
NOTE_D4     equ 0x36    ; D
NOTE_E4     equ 0x30    ; E
NOTE_F4     equ 0x2C    ; F
NOTE_G4     equ 0x28    ; G
NOTE_A4     equ 0x24    ; A
NOTE_B4     equ 0x20    ; B
NOTE_C5     equ 0x1C    ; High C

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
	equ $9000
RAMCELL
	equ $f000
MDLADDR
    equ $a000
  

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
RAM_COUNTER:
    equ CHAR_COUNTER + 1;

FILL_RAM_SIZE               ;how many bytes do we have to initialize?             
    equ RAM_COUNTER+1-CHAR_BUFFER



;subroutines:

;startup initializations
STARTUP:
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


    ; Define a simple melody
MELODY:
    db 262   ; C4 (do)
    db 262   ; C4 (do)
    db 392   ; G4 (sol)
    db 392   ; G4 (sol)    
    db 440   ; A4 (la)
    db 440   ; A4 (la)
    db 392   ; G4 (sol)

    db 349   ; F4 (fa)
    db 349   ; F4 (fa)
    db 330   ; E4 (mi)
    db 330   ; E4 (mi)
    db 294   ; D4 (re)
    db 294   ; D4 (re)
    db 262   ; C4 (do) 

; Define note lengths (in arbitrary time units)
NOTE_LENGTHS:
    db 10, 10, 10, 10, 10, 10, 20 ; Two measures for the first section
    db 10, 10, 10, 10, 10, 10, 20 ; Repeat same for the second section

; Subroutine for the startup sound  
STARTUP_SOUND:  
    ld a, 7  
    out (SOUND_REGISTER), a ; select the mixer register  

    ld a, 62  
    out (SOUND_DATA), a  ; enable channel A only  

    ld a, 8  
    out (SOUND_REGISTER), a ; channel A volume  

    ld a, 15  
    out (SOUND_DATA), a ; set maximum volume  

    ld a, 0  
    out (SOUND_REGISTER), a ; select channel A pitch  

    ; Initialize pointers
    ld hl, MELODY         ; Point to the melody
    ld de, NOTE_LENGTHS   ; Point to note lengths
  
    ld b, 8               ; Number of notes to play

PLAY_MELODY:
    ld a, (hl)           ; Load the current note frequency
    out (SOUND_DATA), a   ; Set the pitch
    inc hl                ; Move to the next note

    ld a, (de)           ; Load note length
    call SND_PAUSE       ; Pause for the note length
    inc de                ; Move to the next length
    djnz PLAY_MELODY     ; Decrement B and loop if not zero
    ld a, 0
    out (SOUND_DATA), a ; set maximum volume  

    ret                   ; Return from subroutine

SND_PAUSE:  
    push bc  
    push de  
    push af  
    ld bc, 0xFFFF ; Adjust the delay loop as needed for timing
SND_OUTER:  
    dec bc            ; Decrement BC  
    ld a, b          ; Copy B into A  
    or c             ; Bitwise OR of C with A (now, A = B | C)  
    jp nz, SND_OUTER ; If A is not zero, loop back to SND_OUTER
    pop af  
    pop de  
    pop bc  
    ret               ; Return from subroutine


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
    push hl
    push bc
    ld hl,numbers
    ld b,0
    ld c,a
    add hl,bc
    ld a,(HL)
    out (SEVENSEGO),a
    pop bc
    pop hl
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
inc_ram_counter:;Increment the counter
  PUSH  AF     ;save af
  LD  A,(ram_counter)
  INC A
  LD  (ram_counter),A
  POP AF
  RET

ram_counter_segprint:;print ram counter to seven segment
  PUSH  AF
  LD  A,(ram_counter)
  OUT (SEVENSEGO),A
  POP AF
  RET

    
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
