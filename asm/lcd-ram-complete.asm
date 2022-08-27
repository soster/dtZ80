;sevenseg-ram.z80
;Count from 0-9 on the seven segment display
;Depends on RAM and therefore uses call and ret

;Constants



org 0
    call startup
    ld hl,LCD_COMMANDS      ;Address of command list, $ff terminated
    call delay
command_loop:
    ld a,(HL)           ;Next command
    inc a               ;Add 1 so we can test for $ff...
    jr z,command_end    ;...by testing for zero
    dec a               ;Restore the actual value
    out (4),a ;Output it.
    call delay
    out (0),a
    inc hl              ;Next command
    jr command_loop     ;Repeat
command_end:
    ld hl,message       ;Message address, 0 terminated
    ld b,0
message_loop:           ;Loop back here for next character
    ld a,(HL)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,done
    out (lcd_data),a    ;Output the character
    call DELAY
    out (0),a
    ld a,b
    ;CALL    segprint_num
    inc b
    inc hl              ;Point to next character
    call delay
    jr message_loop     ;Loop back for next character

done:
    halt

include'dtz80-lib.inc'
