;sevenseg.asm
;displays 0-9 to the seven segment display
;use only with slow clock, no delay!

;Constants
ioport equ $00 ;I/O port

org 0
loop:
    ld a,$3f;0
    out (ioport),a
    ld a,$06;1
    out (ioport),a
    ld a,$5b;2
    out (ioport),a
    ld a,$4f;3
    out (ioport),a
    ld a,$66;4
    out (ioport),a
    ld a,$6d;5
    out (ioport),a
    ld a,$7d;6
    out (ioport),a
    ld a,$07
    out (ioport),a
    ld a,$7f
    out (ioport),a
    ld a,$66
    out (ioport),a
    jp done
loop2:
    out (ioport),a
    inc a
    jp loop2
    jr loop;start over

done:
    halt            ;Halt the processor
    
;this is just to recognize the binary file:
message:
    db "sevenseg.asm",0
