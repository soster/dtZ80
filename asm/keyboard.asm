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
    ld hl,start_message ;Message address, 0 terminated
message_loop:           ;Loop back here for next character
    call lcd_wait_loop  ;wait for lcd

    ld a,(hl)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,message_done

    out (lcd_data),a    ;Output the character
    inc hl              ;Point to next character
    jr message_loop     ;Loop back for next character

message_done:
    halt

start_message:
    db "Keyboard test:",0

INCLUDE 'library.asm'
