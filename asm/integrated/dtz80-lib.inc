;Constants
SEVENSEGO
  EQU $00 	    ;I/O port 7 segment A0-A7=0
LCD_COMMAND
  EQU $04	    ;LCD command I/O port, A5=1
LCD_DATA
  EQU $05        ;LCD data I/O port,A5=1,A0=1


;; CTC Addresses
CTC_CH0 EQU     60h
CTC_CH1 EQU     61h
CTC_CH2 EQU     62h
CTC_CH3 EQU     63h

; SIO Addresses
SIO_CA  EQU     42h; SIO Control Channel A
SIO_CB  EQU     43h; Not used
SIO_DA  EQU     40h; SIO Data Channel A
SIO_DB  EQU     41h; Not used


;Constants
SOUND_REGISTER
  EQU $80
SOUND_DATA
  EQU $81

stackpointer
  EQU $8fff  ;Address for the stack pointer

ram_counter
  EQU $b000   ; Address for a counter in RAM

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift
;ff terminated.
LCD_COMMANDS:
  DB  $37,$0f,$01,$06,$ff

;7 segment numbers,0-9:
numbers:
  DB  $3f,$6,$5b,$4f,$66,$6d,$7d,$7,$7f,$6f,0

message:
  DB  "HELLO WORLD!",0

;subroutines:

;startup initializations
startup:
  LD  SP,stackpointer
  RET

; 3 cascaded 8 bit loops to create some 100ms delay
DELAY:
  PUSH  DE
  PUSH  BC
  LD  E,#6
loop1
  LD  B,#40
loop2
  LD  D,#ff
loop3
  DEC D
  JP  NZ,loop3
  DEC B
  JP  NZ,loop2
  DEC E
  JP  NZ,loop1
  POP BC
  POP DE
  RET

segprint_num:;interpret a as a number 0-9 and translate it to the 7seg byte
  LD  HL,numbers
  LD  B,0
  LD  C,A
  ADD HL,BC
  LD  A,(HL)
  OUT (SEVENSEGO),A
  RET


; Sends the init commands to the lcd
; Ues HL, AF
LCD_PREPARE:
        LD      HL,LCD_COMMANDS      ;Address of command list for LCD, $ff terminated
LCD_COM_LOOP:
        CALL LCD_WAIT
        LD      A,(HL)           ;Next command
        INC     A               ;Add 1 so we can test for $ff...
        JR      Z,LCD_COM_END    ;...by testing for zero
        DEC     A               ;Restore the actual value
        OUT     (LCD_COMMAND),A ;Output it.

        INC     HL              ;Next command
        JR      LCD_COM_LOOP     ;Repeat
LCD_COM_END:
        RET

; Send a message to the LCD
; Expects the pointer in HL
; Message terminated by 0
; Uses HL, AF
LCD_MESSAGE:
        CALL    LCD_WAIT
        LD      A,(HL)           ;Load character into A
        AND     A               ;Test for end of string (A=0)
        JR      Z,MESSAGE_END
        OUT     (lcd_data),A    ;Output the character
        INC     HL              ;Point to next character
        JR      LCD_MESSAGE     ;Loop back for next character
MESSAGE_END:
        RET

; Wait passively for the lcd to execute the last command
LCD_WAIT:
        PUSH    AF
        LD      A,$ff
lcd_wait_loop:	 ;label with @ changes for each macro occurance
        DEC     A
        JR      NZ,lcd_wait_loop
        LD      A,0
        OUT     (0),A
        POP     AF
        RET

CR      EQU     0
L_SHIFT EQU     0
R_SHIFT EQU     0
CAPS_LOCK
        EQU     0
NUM_LOCK
        EQU     0
BACK_SPACE
        EQU     0x08
ESC     EQU     0
L_CTRL  EQU     0
SPACE   EQU     0x20


SCAN_LOOKUP:
        DB      0       ;FOR SCAN-CODE 0 WHICH DOES NOT EXIST, I
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 001 to 010
        DB      0,0,0,0,0,0,0,0,L_SHIFT,L_CTRL     ; scan code 011 to 020
        DB      'Q','!',0,0,0,'Z','S','A','W','@'     ; scan code 021 to 030
        DB      0,0,'C','X','D','E','$','#',0,0     ; scan code 031 to 040
        DB      SPACE,'V','F','T','R','%',0,0,'N','B'     ; scan code 041 to 050
        DB      'H','G','Y','^',0,0,0,'M','J','U'     ; scan code 051 to 060
        DB      '&','*',0,0,'<','K','I','O',')','('     ; scan code 061 to 070
        DB      0,0,'>','?','L',':','P','_',0,0     ; scan code 071 to 080
        DB      0,'"',0,'{','+',0,0,CAPS_LOCK,R_SHIFT,CR     ; scan code 081 to 090
        DB      '}',0,'|',0,0,0,0,0,0,0     ; scan code 091 to 100
        DB      0,BACK_SPACE,0,0,0,0,0,0,0,0     ; scan code 101 to 110
        DB      0,0,0,0,0,0,0,ESC,NUM_LOCK,0     ; scan code 111 to 120
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 121 to 130
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 131 to 140
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 141 to 150
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 151 to 160
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 161 to 170
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 171 to 180
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 181 to 190
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 191 to 200
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 201 to 210
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 211 to 220
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 221 to 230
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 231 to 240
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 241 to 250
        DB      0,0,0,0,0,0,0,0,0,0     ; scan code 251 to 260

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
  OUT (sevensego),A
  POP AF
  RET