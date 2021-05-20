; Init and test SIO & CTC Chip (Complete Version)
; PS/2 Interface via SIO
; rasm sio-ps2.asm sio-ps2 && minipro -p "at28c256" -w sio-ps2.bin -s
; stty -F /dev/ttyUSB0 19200 cs8 -cstopb -parenb
; tio --baudrate 19200 --databits 8 --flow none --stopbits 1 --parity none /dev/ttyS0

; CTC Addresses
CTC_CH0 EQU     60h
CTC_CH1 EQU     61h
CTC_CH2 EQU     62h
CTC_CH3 EQU     63h

; SIO Addresses
SIO_CA  EQU     42h; SIO Control Channel A
SIO_CB  EQU     43h; Not used
SIO_DA  EQU     40h; SIO Data Channel A
SIO_DB  EQU     41h; Not used


SEVENSEGIO
        EQU     0x00; 7 segment base address

LCD_COMMAND equ $04	    ;LCD command I/O port, A5=1
LCD_DATA equ $05        ;LCD data I/O port,A5=1,A0=1

RAMCELL EQU     0x8000

CR       EQU     0
L_SHIFT  EQU     0
R_SHIFT  EQU     0
CAPS_LOCK EQU     0
NUM_LOCK EQU     0
BACK_SPACE EQU     0x08
ESC      EQU     0
L_CTRL   EQU     0
SPACE    EQU    0x20

RESET:
        ORG     0
        JP      MAIN


        ; interrupt vector for SIO
        ORG     0ch
        DEFW    RX_CHA_AVAILABLE
        ORG     0Eh
        DEFW    SPEC_RX_CONDITON

;---------------------------------------------------
        ; Main code
        ORG     0100h           ; main code starts at $0100 because of interrupt vector!
MAIN:

        LD      A,$3f           ; Seven segment bits for "0"
        OUT     (SEVENSEGIO),A  ; Output to seven segment

        CALL    SET_CTC         ; configure CTC
        CALL    SET_SIO         ; configure SIO




        LD      A,0             ; set high byte of interrupt vectors to point to page 0
        LD      I,A

        IM      2               ; set int mode 2
        EI                      ; enable interupts

        LD      A,00000000b     ; load initial value into RAM
        LD      (RAMCELL),A

        CALL    A_RTS_OFF        ; remove RTS

        LD      HL,commands      ;Address of command list for LCD, $ff terminated

        LD      A,$6           ; Seven segment bits for "1"
        OUT     (SEVENSEGIO),A  ; Output to seven segment

LCD_COM_LOOP:
        CALL    LCD_WAIT
        LD      A,(HL)           ;Next command
        INC     A               ;Add 1 so we can test for $ff...
        JR      Z,LCD_COM_END    ;...by testing for zero
        DEC     A               ;Restore the actual value
        OUT     (LCD_COMMAND),A ;Output it.

        INC     HL              ;Next command
        JR      LCD_COM_LOOP     ;Repeat
LCD_COM_END:
        LD      D,ffh
        CALL    DELAY
        LD      A,$5b
        OUT     (SEVENSEGIO),A

        LD  HL,START_MESSAGE       ;Message address, 0 terminated
        LD  B,0
message_loop:           ;Loop back here for next character
        LD  A,(HL)           ;Load character into A
        AND A               ;Test for end of string (A=0)
        JR  Z,ENDLESS_LOOP
        OUT (lcd_data),A    ;Output the character
        CALL LCD_WAIT
        LD  A,B
        INC B
        INC HL              ;Point to next character
        JR  message_loop     ;Loop back for next character


        
ENDLESS_LOOP:
        LD      D,ffh
        CALL    DELAY
        CALL    ENDLESS_LOOP

;-------------------------------------------------
SET_CTC:
;init CTC_CH0
;Information from the datasheet:
;Counter Mode = Bit 6 set, otherwise Timer mode. Timer mode references the system clock, counter mode the trigger signal. 
;For Channel 0 the trigger signal comes from a 7.3728 Mhz crystal. (deprecated, now use global clock)
;ATTENTION: Trigger signal not working anymore. Therefore, we use the system clock with 7.3728 Mhz / 16 / 24 = 19.200 Hz
;For Timer Mode: The prescaler in Bit 5 defines if the clock is divided by 16 (0) or 256 (1).
;
;
;CTC_CH0 provides to SIO SERIAL A the RX/TX clock
        LD      A,00000111b ; interrupt off, timer mode, prsc=16, ext. start,
                            ; start upon loading time constant, time constant, sw reset, command word
                            ; divides clock by 16
        OUT     (CTC_CH0),A
        LD      A,0x18      ; time constant 24, divides further by 24 = 19.200 Baud / Hz
        OUT     (CTC_CH0),A
                            ; TO0 output frequency=INPUT CLK/time constant
                            ; Old:
                            ; which results in 7372800/24 = 307200 Hz because the CTC is set to need RX/TX
                            ; clock 16 times the requested baud rate (in our case, 19200 x 16 = 307200 Hz)
                            ; OSZ outputs ca. 57 khz (57600), why?
;CTC_CH3 disabled
        LD      A,00000011b      ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                            ; start timer on loading constant, no time constant follows, software reset, command word
        OUT     (CTC_CH3),A         ; CH3 doesn't run

;init CTC_CH1
;CTC_CH1 divides CPU CLK by (256*256) providing a clock signal at TO1. TO1 is connected to TRG2.
;T01 outputs f= CPU_CLK/(256*256) => 6MHz / ( 256 * 256 ) => 91.55Hz
        LD      A,00100111b      ; interrupt off; timer mode; prescaler=256; don't care ext; automatic trigger;
                            ; time constant follows; cont. operation; command word
        OUT     (CTC_CH1),A
        LD      A,0x00           ; time constant - 0 stands for 256
        OUT     (CTC_CH1),A

;init CTC_CH2
;CTC_CH2 divides CLK/TRG2 clock providing a clock signal at TO2.
; T02 outputs f= CLK/TRG / 91 => 91.55Hz / 91 => ~ Hz / 1s
        LD      A,01000111b      ; interrupt off, counter mode, prescaler=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows,sw reset, command word
        OUT     (CTC_CH2),A
        LD      A,0x5b           ; time constant 91d
        OUT     (CTC_CH2),A         ; loaded into channel 2
        LD      A,00010000b      ; D7..D3 provide the first part of the int vector (in our case, $10), followed by
                            ; D2..D1, provided by the CTC (they point to the channel), d0=interrupt word
        OUT     (CTC_CH0),A         ; send to CTC

        RET

;-------------------------------------------------------------------------------
SET_SIO:
;program the SIO
        ;set up TX and RX:
        ; the followings are settings for channel A
        LD      A,00110000b      ; write into WR0: error reset, select WR0
        OUT     (SIO_CA),A
        LD      A,00011000b      ; write into WR0: channel reset
        OUT     (SIO_CA),A
        LD      A,00000100b      ; write into WR0: select WR4
        OUT     (SIO_CA),A
        LD      A,00000100b      ; write into WR4: presc. 1x, 1 stop bit, no parity
        OUT     (SIO_CA),A
        LD      A,00000101b      ; write into WR0: select WR5
        OUT     (SIO_CA),A
        LD      A,11101000b      ; write into WR5: DTR on, TX 8 bits, BREAK off, TX on, RTS off
        OUT     (SIO_CA),A
        ; the following are settings for channel B (not used here, just for clarifications)
        LD      A,00000001b      ; write into WR0: select WR1
        OUT     (SIO_CB),A
        LD      A,00000100b      ; write into WR0: status affects interrupt vectors
        OUT     (SIO_CB),A
        LD      A,00000010b      ; write into WR0: select WR2
        OUT     (SIO_CB),A
        LD      A,0h             ; write into WR2: set interrupt vector, but bits D3/D2/D1 of this vector
                                ; will be affected by the channel & condition that raised the interrupt
                                ; (see datasheet): in our example, 0x0C for Ch.A receiving a char, 0x0E
                                ; for special conditions
        OUT     (SIO_CB),A
        
        ; the following are settings for channel A
        LD      A,01h            ; write into WR0: select WR1
        OUT     (SIO_CA),A
        LD      A,00011000b      ; interrupts on every RX char; parity is no special condition;
                                 ; buffer overrun is special condition
        OUT     (SIO_CA),A
SIO_A_EI:
        ;enable SIO channel A RX
        LD      A,00000011b      ; write into WR0: select WR3
        OUT     (SIO_CA),A
        LD      A,11000001b      ; 8 bits/RX char; auto enable OFF; RX enable
        OUT     (SIO_CA),A
        RET


;-------------------------------------------------

DELAY:                      ; routine to add a programmable delay (set by value stored in D)
        PUSH    BC
loop1:
        LD      B,0xff
loop2:
        DJNZ    loop2
        DEC     D
        JP      NZ,loop1
        POP     BC
        RET

;-------------------------------------------------------------------------------
; serial management
;-------------------------------------------------------------------------------


A_RTS_OFF:
        LD      A,00000101b      ; write into WR0: select WR5
        OUT     (SIO_CA),A
        LD      A,11101000b      ; 8 bits/TX char; TX enable; RTS disable
        OUT     (SIO_CA),A
        RET

A_RTS_ON:
        LD      A,00000101b      ; write into WR0: select WR5
        OUT     (SIO_CA),A
        LD      A,11101010b      ; 8 bits/TX char; TX enable; RTS enable
        OUT     (SIO_CA),A
        RET

SIO_A_DI:
        ;disable SIO channel A RX
        LD      A,00000011b      ; write into WR0: select WR3
        OUT     (SIO_CA),A
        LD      A,00001100b      ; write into WR3: RX disable;
        OUT     (SIO_CA),A
        RET

RX_CHA_AVAILABLE:
        PUSH    AF              ; backup AF
        CALL    A_RTS_OFF       ; disable RTS
        IN      A,(SIO_DA)      ; read RX character into A

        LD  HL, SCAN_LOOKUP     ; fetch scancode from lookup table
        LD  B, 0
        LD  C, A
        ADC HL, BC
        LD A,(HL)


        OUT     (SIO_DA),A      ; echo char to transmitter
        ;OUT     (SEVENSEGIO),A  ; echo value to 7seg
        OUT     (LCD_DATA),A    ; echo value to lcd
        OUT     (SEVENSEGIO),A  ; echo value to 7seg
        CALL    TX_EMP          ; wait for outgoing char to be sent
        ;call RX_EMP            ; flush receive buffer
        LD      A,(RAMCELL)     ; change the pattern to show to the external
        XOR     11000000b       ; world that this ISR was honored
        LD      (RAMCELL),A
        CALL    A_RTS_ON        ; enable again RTS
        POP     AF
        EI
        RETI

SPEC_RX_CONDITON:
        JP      0000h            ; if buffer overrun then restart the program

TX_EMP:
        ; check for TX buffer empty
        SUB     A
        INC     A
        OUT     (SIO_CA),A
        IN      A,(SIO_CA)
        BIT     0,A
        JP      Z,TX_EMP
        RET

RX_EMP:
        ;check for RX buffer empty
        ;modifies A
        SUB     A               ;clear a, write into WR0: select RR0
        OUT     (SIO_CA),A
        IN      A,(SIO_CA)      ;read RRx
        BIT     0,A
        RET     Z               ;if any rx char left in rx buffer
        IN      A,(SIO_DA)      ;read that char
        JP      RX_EMP

LCD_WAIT:
    push af
    ld a,$ff
lcd_wait_loop:
    nop
    dec a
    jp nz,lcd_wait_loop
    OUT (sevensegio),a
    pop af
    ret


SERIAL_MESSAGE:
        DB      "HELLO WORLD!",0

START_MESSAGE:
    db "Initializing...",0

COMMANDS:
    db $3f,$0f,$01,$06,$ff

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