;fullspeeddemo.asm
;uses a triple loop to create a delay between 7 segment numbers
;this can be executed with full speed (6Mhz)

;Constants
ioport
    EQU $00 ;I/O port

org 0
begin:
    LD  A,$06;1
    OUT (ioport),A
;wait loops:
    LD  BC,500h             ;Loads BC with hex 500
outer:
    LD  DE,500h             ;Loads DE with hex 500
inner:
    DEC DE                  ;Decrements DE
    LD  A,D                 ;Copies D into A
    OR  E                   ;Bitwise OR of E with A (now, A = D | E)
    ;this is neccessary because dec 16bit registers does not set zero flag!
    JP  NZ,inner             ;Jump inner loop if a is not zero
    ; outer loop:
    DEC BC                  ;Decrements BC
    LD  A,B                 ;Same as in inner loop
    OR  C
    JP  NZ,outer
;---
    LD  A,$5b;2
    OUT (ioport),A
    JP  begin


done:
    HALT            ;Halt the processor

message:
    DB  "fullspeeddemo.asm",0
