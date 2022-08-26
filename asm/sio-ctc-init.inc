;Init CTC and SIO chips.
;included in the dtZ80 bios.
;TODO use the second SIO channel.
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
        ;LD      A,00000011b      ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                            ; start timer on loading constant, no time constant follows, software reset, command word
        ;OUT     (CTC_CH3),A         ; CH3 doesn't run
        ;out     (CTC_CH1),A
        ;out     (CTC_CH2),A

;init CTC_CH1
;CTC_CH1 divides CPU CLK by (256*256) providing a clock signal at TO1. TO1 is connected to TRG2.
;T01 outputs f= CPU_CLK/(256*256) => 6MHz / ( 256 * 256 ) => 91.55Hz
        ;LD      A,00100111b      ; interrupt off; timer mode; prescaler=256; don't care ext; automatic trigger;
                            ; time constant follows; cont. operation; command word
        ;OUT     (CTC_CH1),A
        ;LD      A,0x00           ; time constant - 0 stands for 256
        ;OUT     (CTC_CH1),A

;init CTC_CH2
;CTC_CH2 divides CLK/TRG2 clock providing a clock signal at TO2.
; T02 outputs f= CLK/TRG / 91 => 91.55Hz / 91 => ~ Hz / 1s
        ;LD      A,01000111b      ; interrupt off, counter mode, prescaler=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows,sw reset, command word
        ;OUT     (CTC_CH2),A
        ;LD      A,0x5b           ; time constant 91d
        ;OUT     (CTC_CH2),A         ; loaded into channel 2
        ;LD      A,00010000b      ; D7..D3 provide the first part of the int vector (in our case, $10), followed by
                            ; D2..D1, provided by the CTC (they point to the channel), d0=interrupt word
        ;OUT     (CTC_CH0),A         ; send to CTC

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
        ; the following are settings for channel B
        LD      A,01h            ; write into WR0: select WR1
        OUT     (SIO_CB),A
        LD      A,00000100b      ;no interrupt in CH B, special RX condition affects vect
        ;LD      A,00011000b      ; interrupts on every RX char; parity is no special condition;
                                 ; buffer overrun is special condition
        OUT     (SIO_CB),A        
SIO_A_EI:
        ;enable SIO channel A RX
        LD      A,00000011b      ; write into WR0: select WR3
        OUT     (SIO_CA),A
        LD      A,11000001b      ; 8 bits/RX char; auto enable OFF; RX enable
        OUT     (SIO_CA),A
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
B_RTS_OFF:
        LD      A,00000101b      ; write into WR0: select WR5
        OUT     (SIO_CB),A
        LD      A,11101000b      ; 8 bits/TX char; TX enable; RTS disable
        OUT     (SIO_CB),A
        RET

B_RTS_ON:
        LD      A,00000101b      ; write into WR0: select WR5
        OUT     (SIO_CB),A
        LD      A,11101010b      ; 8 bits/TX char; TX enable; RTS enable
        OUT     (SIO_CB),A
        RET

SIO_B_DI:
        ;disable SIO channel B RX
        LD      A,00000011b      ; write into WR0: select WR3
        OUT     (SIO_CB),A
        LD      A,00001100b      ; write into WR3: RX disable;
        OUT     (SIO_CB),A
        RET        

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