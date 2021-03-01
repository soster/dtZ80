; Init and test CTC Chip


CH0 equ 60h
CH1 equ 61h
CH2 equ 62h
CH3 equ 63h
sevensegio equ $00 	    ;I/O port 7 segment A0-A7=0

RAMCELL equ 0x8000

        org 0
        jp MAIN

        
        ; interrupt vector for CH2 Timer
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
;init CH0
;CH0 provides to SIO SERIAL A the RX/TX clock
        ld a,01000111b      ; interrupt off, counter mode, prsc=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows, sw reset, command word
        out (CH0),a
        ld a,0x06           ; time constant 6
        out (CH0),a
                            ; TO0 output frequency=INPUT CLK/time constant
                            ; which results in 1,843,200/6 = 307,200 Hz because the CTC is set to need RX/TX
                            ; clock 16 times the requested baud rate (in our case, 19,200 x 16 = 307,200 Hz)
;CH3 disabled
        ld a,00000011b      ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                            ; start timer on loading constant, no time constant follows, software reset, command word
        out (CH3),a         ; CH3 doesn't run

;init CH1
;CH1 divides CPU CLK by (256*256) providing a clock signal at TO1. TO1 is connected to TRG2.
;T01 outputs f= CPU_CLK/(256*256) => 3.68MHz / ( 256 * 256 ) => 56.15Hz
        ld a,00100111b      ; interrupt off; timer mode; prescaler=256; don't care ext; automatic trigger;
                            ; time constant follows; cont. operation; command word
        out (CH1),a
        ld a,0x00           ; time constant - 0 stands for 256
        out (CH1),a

;init CH2
;CH2 divides CLK/TRG2 clock providing a clock signal at TO2.
; T02 outputs f= CLK/TRG / 56 => 56.15Hz / 56 => 1.002Hz ~ 1s
        ld a,11000111b      ; interrupt on, counter mode, prescaler=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows,sw reset, command word
        out (CH2),a
        ld a,0x38           ; time constant 56d
        out (CH2),a         ; loaded into channel 2
        ld a,00010000b      ; D7..D3 provide the first part of the int vector (in our case, $10), followed by
                            ; D2..D1, provided by the CTC (they point to the channel), d0=interrupt word
        out (CH0),a         ; send to CTC

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

