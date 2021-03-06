; Init and test CTC Chip
; rasm ctc.asm ctc && minipro -p "at28c256" -w ctc.bin -s

CTC_CH0 equ 60h; CTC base address
CTC_CH1 equ 61h
CTC_CH2 equ 62h
CTC_CH3 equ 63h

sevensegio equ $00;7 segment base address

RAMCELL equ 0x8000

        org 0
        jp MAIN

        
        ; interrupt vector for CTC_CH2 Timer
        org 14h
        defw CH2_TIMER

;---------------------------------------------------
        ; Main code
        org 0100h           ; main code starts at $0100
MAIN:
        ld sp,0xffff        ; set the stack pointer to top of RAM

        ld a,0x3f
        out (sevensegio),a

        ld d,0x80
        call delay          ; little delay
        call SET_CTC        ; set the CTC



        xor a             ; clear reg. A
        ld i,a              ; set most significant bits of interrupt vector to $0000
        ld (RAMCELL),a      ; reset the seconds' counter into RAM
        ld a,0x6
        out (sevensegio),a
        im 2                ; interrupt mode 2
        ei                  ; enable interrupts


DO_NOTHING:                 ; this is the main loop: the CPU simply does nothing...
        ld d,0x80
        call delay
        jp DO_NOTHING

;-------------------------------------------------
; Interrupt service routine (ISR) for CH2 timer
CH2_TIMER:
        di                  ; disable interrupts
        push af             ; save reg. A
        ld a,(RAMCELL)      ; load the timer from RAM
        inc a               ; increment it
        ld (RAMCELL),a      ; write the new value
        out (sevensegio),a  ; send it to the PIO
        pop af              ; recover reg. A
        ei                  ; re-enable interrupts
        reti                ; exit from ISR

;-------------------------------------------------
SET_CTC:
;init CTC_CH0
;CTC_CH0 provides to SIO SERIAL A the RX/TX clock
        ld a,01000111b      ; interrupt off, counter mode, prsc=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows, sw reset, command word
        out (CTC_CH0),a
        ld a,0x0f           ; time constant 16
        out (CTC_CH0),a
                            ; TO0 output frequency=INPUT CLK/time constant
                            ; which results in 7,372,800/16 = 460,800 Hz because the CTC is set to need RX/TX
                            ; clock 16 times the requested baud rate (in our case, 28,800 x 16 = 460,800 Hz)
;CTC_CH3 disabled
        ld a,00000011b      ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                            ; start timer on loading constant, no time constant follows, software reset, command word
        out (CTC_CH3),a         ; CH3 doesn't run

;init CTC_CH1
;CTC_CH1 divides CPU CLK by (256*256) providing a clock signal at TO1. TO1 is connected to TRG2.
;T01 outputs f= CPU_CLK/(256*256) => 6MHz / ( 256 * 256 ) => 91.55Hz
        ld a,00100111b      ; interrupt off; timer mode; prescaler=256; don't care ext; automatic trigger;
                            ; time constant follows; cont. operation; command word
        out (CTC_CH1),a
        ld a,0x00           ; time constant - 0 stands for 256
        out (CTC_CH1),a

;init CTC_CH2
;CTC_CH2 divides CLK/TRG2 clock providing a clock signal at TO2.
; T02 outputs f= CLK/TRG / 91 => 91.55Hz / 91 => ~ Hz / 1s
        ld a,11000111b      ; interrupt on, counter mode, prescaler=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows,sw reset, command word
        out (CTC_CH2),a
        ld a,0x5b           ; time constant 91d
        out (CTC_CH2),a         ; loaded into channel 2
        ld a,00010000b      ; D7..D3 provide the first part of the int vector (in our case, $10), followed by
                            ; D2..D1, provided by the CTC (they point to the channel), d0=interrupt word
        out (CTC_CH0),a         ; send to CTC

        ret
;-------------------------------------------------

delay:                      ; routine to add a programmable delay (set by value stored in D)
        push bc
loop1:
        ld b,0xff
loop2:
        djnz loop2
        dec d
        jp nz, loop1
        pop bc
        ret

