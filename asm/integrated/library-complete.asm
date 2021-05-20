;Constants
sevensegio equ $00 	    ;I/O port 7 segment A0-A7=0
lcd_command equ $04	    ;LCD command I/O port, A5=1
lcd_data equ $05        ;LCD data I/O port,A5=1,A0=1
button	equ $40	        ;Button Input, dummy for now
keyboard equ $80
stackpointer equ $8fff  ;Address for the stack pointer

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift
;ff terminated.
commands:
    db $37,$0f,$01,$06,$ff

;7 segment numbers,0-9:
numbers:
    db $3f,$6,$5b,$4f,$66,$6d,$7d,$7,$7f,$6f,0

message:
    db "HELLO WORLD!",0

;subroutines:

;startup initializations
startup:
    ld sp,stackpointer
    ret

delay:; 3 cascaded 8 bit loops to create some 100ms delay
  push de
  push bc
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
  pop bc
  pop de
    ret

segprint_num:;interpret a as a number 0-9 and translate it to the 7seg byte
    push af     ;save af
    push hl     ;save hl
    push bc     ;save bc
    ld hl,numbers
    ld b,0
    ld c,a
    add hl,bc
    ld a,(hl)
    out (sevensegio),a
    pop bc      ;restore bc
    pop hl      ;restore hl
    pop af      ;restore af
    ret

LCD_WAIT:
    push af   ; save registers
    ld a,$ff  ; count down from ff
lcd_wait_loop:
    nop       ; just to wait a little longer
    dec a     ; decrement...
    jp nz,lcd_wait_loop; jump if 0
    OUT (sevensegio),a; reset a0-an and do0-do8
    pop af; restore register
    ret
