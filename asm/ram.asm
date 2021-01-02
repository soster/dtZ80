;ram.z80
;Uses RAM for the first time
;sub and ret should work now

;Constants
sevensegio equ $00 	    ;I/O port 7 segment A0-A7=0
lcd_command equ $20	    ;LCD command I/O port, A5=1
lcd_data equ $21        ;LCD data I/O port,A5=1,A0=1
stackpointer equ $8fff  ;Address for the stack pointer
sevensegram equ $8000

org 0;start at address 0
    ld sp,stackpointer  ;Initialize Stack Pointer
    ld hl,commands      ;Address of command list, $ff terminated

command_loop:
    call lcd_wait
    ld a,(hl)           ;Next command
    inc a               ;Add 1 so we can test for $ff...
    jr z,command_end    ;...by testing for zero
    dec a               ;Restore the actual value
    out (lcd_command),a ;Output it.
    inc hl              ;Next command
    jr command_loop     ;Repeat

command_end:
    ld hl,message       ;Message address, 0 terminated
message_loop:           ;Loop back here for next character
    call lcd_wait
    ld a,(hl)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,number_loop
    out (lcd_data),a    ;Output the character
    inc hl              ;Point to next character
    jr message_loop     ;Loop back for next character

number_loop:
    ld a,0              ;Offset for the number to display
next_number:
    call segprint_num   ;Display number stored in a
    inc a               ;Next number offset
    ld b,9              ;for checking if offset=9
    cp b                ;if a-b=0 set zero flag
    jp nz,next_number   ;if zero flag not set continue
    jr number_loop      ;otherwise reset a to 0

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

  segprint:;print content of a to 7segment and wait
    out (sevensegio),a
    call delay
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
  lcd_wait:
  lcd_wait_loop:
    in a,(lcd_command)  ;Read the status into A
                        ;trick to conditionally jump if bit 7 is true:
    rlca                ;Rotate A left, bit 7 moves into the carry flag
    jr c,lcd_wait_loop  ;Loop back if the carry flag is set
    ret

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift

commands:               ;$ff terminated
    db $3f,$0f,$01,$06,$ff
message:
    db "HELLO WORLD!!!",0
numbers:;7 seg number representations 0-9
    db $3f,$6,$5b,$4f,$66,$6d,$7d,$7,$7f,$6f,0
