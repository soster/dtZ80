;sevenseg-ram.z80
;Count from 0-9 on the seven segment display
;Depends on RAM and therefore uses call and ret

;Constants
sevensegio equ $00 	    ;I/O port 7 segment A0-A7=0
stackpointer equ $8fff  ;Address for the stack pointer

org 0;start at address 0
    ld sp,stackpointer  ;Initialize Stack Pointer
    ld a,0              ;Offset for the number to display
next_number:
    call segprint_num   ;Display number stored in a
    inc a               ;Next number offset
    ld b,9              ;for checking if offset=9
    cp b                ;if a-b=0 set zero flag
    jr nz,next_number   ;if zero flag not set continue loop
    ld a,0              ;otherwise reset a to zero
    out (sevensegio),a  ;display nothing
    call delay
    call delay
    jr next_number

;subroutines:
delay:; 3 cascaded 8 bit loops to create some 100ms delay
    ld e,#4
  loop1:
    ld b,#40
  loop2:
    ld d,#ff
  loop3:
    dec	d
    jp	nz,loop3
    dec b
    jp nz,loop2
    dec e
    jp nz,loop1
    ret

  segprint_num:;interpret a as a number 0-9 and translate it to the 7seg byte
    ld hl,numbers
    ld b,0
    ld c,a
    add hl,bc
    ld a,(hl)
    out (sevensegio),a
    ld a,c
    call delay
    ret

numbers:;7 seg number representations 0-9
    db $3f,$6,$5b,$4f,$66,$6d,$7d,$7,$7f,$6f,0
