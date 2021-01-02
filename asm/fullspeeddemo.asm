;fullspeeddemo.asm
;uses a triple loop to create a delay between 7 segment numbers
;this can be executed with full speed

;Constants
ioport equ $00 ;I/O port

org 0
begin:
    ld a,$06;1
    out (ioport),a
;wait loops:
    ld bc, 500h            ;Loads BC with hex 1000
outer:
    ld de, 500h            ;Loads DE with hex 1000
inner:
    dec de                  ;Decrements DE
    ld a, d                 ;Copies D into A
    or e                    ;Bitwise OR of E with A (now, A = D | E)
    ;this is neccessary because dec 16bit registers does not set zero flag!
    jp nz,inner             ;Jump inner loop if a is not zero
    ; outer loop:
    dec bc                  ;Decrements BC
    ld a, b                 ;Same as in inner loop
    or c
    jp nz,outer
;---
ld a,$5b;2
out (ioport),a
jp begin


done:
    halt            ;Halt the processor

message:
    db "fullspeeddemo.asm",0
