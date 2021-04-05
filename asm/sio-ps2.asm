; Init and test SIO & CTC Chip
; Outputs "Hello World" to serial interface and then echoes inputs
; rasm sio-ps2.asm sio-ps2 && minipro -p "at28c256" -w sio-ps2.bin -s
; stty -F /dev/ttyUSB0 19200 cs8 -cstopb -parenb
; tio --baudrate 19200 --databits 8 --flow none --stopbits 1 --parity none /dev/ttyS0
; This works however: tio --baudrate 3600 --databits 8 --flow none --stopbits 1  --parity none /dev/ttyUSB0
; Max Base Frequency of the CTC seems to be 1.37 Mhz, it works if everything is calculated based on this instead of 7.3728Mhz

; CTC Addresses
CTC_CH0 EQU     60h
CTC_CH1 EQU     61h
CTC_CH2 EQU     62h
CTC_CH3 EQU     63h

; SIO Addresses
SIO_CA  EQU     42h; SIO Control Channel A
;SIO_CA  EQU     43h; Not used
SIO_DA  EQU     40h; SIO Data Channel A
;SIO_DA  EQU     41h; Not used


SEVENSEGIO
        EQU     0x00; 7 segment base address

LCD_COMMAND
        EQU     0x20	    ;LCD command I/O port, A5=1
LCD_DATA
        EQU     0x21        ;LCD data I/O port,A5=1,A0=1

RAMCELL EQU     0x8000

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
        LD      A,$01           ; Seven segment bits for "0"
        OUT     (SEVENSEGIO),A  ; Output to seven segment
        LD      D,0x80
        CALL    DELAY           ; little delay

        CALL    SET_CTC         ; configure CTC
        CALL    SET_SIO         ; configure SIO


        LD      A,$02           ; Seven segment bits for "0"
        OUT     (SEVENSEGIO),A  ; Output to seven segment

        LD      A,0             ; set high byte of interrupt vectors to point to page 0
        LD      I,A

        IM      2               ; set int mode 2
        EI                      ; enable interupts

        LD      A,00000000b     ; load initial value into RAM
        LD      (RAMCELL),A

        CALL    A_RTS_OFF        ; remove RTS  
        LD      HL,commands      ;Address of command list for LCD, $ff terminated

LCD_COM_LOOP:
        LD      A,$03           ; Seven segment bits for "0"
        OUT     (SEVENSEGIO),A  ; Output to seven segment
        CALL    LCD_WAIT
        LD      A,(HL)           ;Next command
        INC     A               ;Add 1 so we can test for $ff...
        JR      Z,LCD_COM_END    ;...by testing for zero
        DEC     A               ;Restore the actual value
        OUT     (LCD_COMMAND),A ;Output it.

        INC     HL              ;Next command
        JR      LCD_COM_LOOP     ;Repeat
LCD_COM_END:
        LD      D,0x80
        CALL    DELAY           ; little delay
        LD      A,$04
        OUT     (SEVENSEGIO),A


        

        
ENDLESS_LOOP:
        LD      D,0x80
        CALL    DELAY           ; little delay
        CALL    ENDLESS_LOOP

;-------------------------------------------------
SET_CTC:
;init CTC_CH0
;Information from the datasheet:
;Counter Mode = Bit 6 set, otherwise Timer mode. Timer mode references the system clock, counter mode the trigger signal. 
;For Channel 0 the trigger signal comes from a 7.3728 Mhz crystal.
;For Timer Mode: The prescaler in Bit 5 defines if the clock is divided by 16 (0) or 256 (1).
;
;
;CTC_CH0 provides to SIO SERIAL A the RX/TX clock
        LD      A,01000111b ; interrupt off, counter mode, prsc=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows, sw reset, command word
        OUT     (CTC_CH0),A
        ;LD      A,0x48      ; time constant 24*3
        LD       A,0x04
        OUT     (CTC_CH0),A
                            ; TO0 output frequency=INPUT CLK/time constant
                            ; which results in 7372800/24 = 307200 Hz because the CTC is set to need RX/TX
                            ; clock 16 times the requested baud rate (in our case, 19200 x 16 = 307200 Hz)
                            ; OSZ outputs ca. 57 khz, why?
;CTC_CH3 etc disabled
        LD      A,00000011b      ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                            ; start timer on loading constant, no time constant follows, software reset, command word
        OUT     (CTC_CH1),A         
        OUT     (CTC_CH2),A
        OUT     (CTC_CH3),A

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
        LD      A,01000000b      ; write into WR4: presc. 16x, ", 0 stop bits, 0 stop bits, unused, even, no parity
        OUT     (SIO_CA),A
        LD      A,00000101b      ; write into WR0: select WR5
        OUT     (SIO_CA),A
        LD      A,01101000b      ; write into WR5: DTR off, TX 8 bits, BREAK off, TX on, RTS off
        OUT     (SIO_CA),A

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
        ; Receiver Enable (D0)
        ; A 1 programmed into this bit allows receive operations to begin. Set this bit
        ; only after all other receive parameters are set and the receiver is completely
        ; initialized.
        LD      A,11000001b      ; 8 bits/RX char; auto enable OFF; RX enable
        OUT     (SIO_CA),A       ; after this receiving starts immediately!
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
        ;OUT     (SIO_DA),A      ; echo char to transmitter
        OUT     (SEVENSEGIO),A  ; echo value to 7seg
        ;OUT     (LCD_DATA),A    ; echo value to lcd
        ;CALL    TX_EMP          ; wait for outgoing char to be sent
        ;call RX_EMP            ; flush receive buffer
        ;LD      A,(RAMCELL)     ; change the pattern to show to the external
        ;XOR     11000000b       ; world that this ISR was honored
        LD      (RAMCELL),A
        CALL    A_RTS_ON        ; enable again RTS
        POP     AF
        EI
        RETI

SPEC_RX_CONDITON:                ; error condition?
        PUSH AF
        LD      A,$ff
        OUT     (SEVENSEGIO),A
        LD      D,0x80
        CALL    DELAY           ; little delay
        POP AF
        EI
        RETI
        ;JP      0000h            ; if buffer overrun then restart the program

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
        ;wait until lcd is ready
        IN      A,(LCD_COMMAND) ;Read the status into A
                                ;trick to conditionally jump if bit 7 is true:
        RLCA                    ;Rotate A left, bit 7 moves into the carry flag
        JR      C,LCD_WAIT      ;Loop back if the carry flag is set
        RET

SERIAL_MESSAGE:
        DB      "HELLO WORLD!",0

COMMANDS:
    db $3f,$0f,$01,$06,$ff