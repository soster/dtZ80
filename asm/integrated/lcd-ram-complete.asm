;sevenseg-ram.z80
;Count from 0-9 on the seven segment display
;Depends on RAM and therefore uses call and ret

;Constants



org 0
    CALL    startup
    LD  HL,commands      ;Address of command list, $ff terminated
    call delay
command_loop:
    LD  A,(HL)           ;Next command
    INC A               ;Add 1 so we can test for $ff...
    JR  Z,command_end    ;...by testing for zero
    DEC A               ;Restore the actual value
    OUT (4),A ;Output it.
    CALL delay
    OUT (0),a
    INC HL              ;Next command
    JR  command_loop     ;Repeat
command_end:
    LD  HL,MESSAGE       ;Message address, 0 terminated
    LD  B,0
message_loop:           ;Loop back here for next character
    LD  A,(HL)           ;Load character into A
    AND A               ;Test for end of string (A=0)
    JR  Z,done
    OUT (lcd_data),A    ;Output the character
    CALL DELAY
    OUT (0),a
    LD  A,B
    ;CALL    segprint_num
    INC B
    INC HL              ;Point to next character
    CALL    delay
    JR  message_loop     ;Loop back for next character

done:
    HALT

INCLUDE 'library-complete.asm'
