;Constants
sevensegio equ $00 	    ;I/O port 7 segment A0-A7=0
lcd_command equ $20	    ;LCD command I/O port, A5=1
lcd_data equ $21        ;LCD data I/O port,A5=1,A0=1
button	equ $40	        ;Button Input, dummy for now
stackpointer equ $8fff  ;Address for the stack pointer
ram_counter equ $b000   ; Address for a counter in RAM

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift
;ff terminated.
commands:
    db $3f,$0f,$01,$06,$ff

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

delay2:; 3 cascaded 8 bit loops to create some 100ms delay
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

inc_ram_counter:;Increment the counter
  push af     ;save af
  ld a,(ram_counter)
  inc a
  ld (ram_counter),a
  pop af
  ret

ram_counter_segprint:;print ram counter to seven segment
  push af
  ld a,(ram_counter)
  out (sevensegio),a
  pop af
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

lcd_wait_loop:;wait until lcd is ready
    in a,(lcd_command)      ;Read the status into A
    ;trick to conditionally jump if bit 7 is true:
    rlca                    ;Rotate A left, bit 7 moves into the carry flag
    jr c,lcd_wait_loop      ;Loop back if the carry flag is set
    ret
