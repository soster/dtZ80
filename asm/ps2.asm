;sevenseg-ram.z80
;Count from 0-9 on the seven segment display
;Depends on RAM and therefore uses call and ret

;Constants



org 0
    call startup
    ld hl,commands      ;Address of command list, $ff terminated

command_loop:
    call lcd_wait_loop  ;wait for display to be ready
    ld a,(hl)           ;Next command
    inc a               ;Add 1 so we can test for $ff...
    jr z,command_end    ;...by testing for zero
    dec a               ;Restore the actual value
    out (lcd_command),a ;Output it.

    inc hl              ;Next command
    jr command_loop     ;Repeat
command_end:
    ld hl,message       ;Message address, 0 terminated
    ld b,0
message_loop:           ;Loop back here for next character
    call lcd_wait_loop  ;wait for lcd

    ld a,(hl)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,done

    out (lcd_data),a    ;Output the character
    ld a,b
    call segprint_num
    inc b
    inc hl              ;Point to next character
    call delay
    jr message_loop     ;Loop back for next character

done:
    ld b,2
    ld a,00110000b
    out (button),a
    inc b
    jr z,done
    call lcd_wait_loop
    ld a,('x')
    out (lcd_data),a
    halt

INCLUDE 'library.asm'
