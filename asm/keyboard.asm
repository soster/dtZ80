;sevenseg-ram.z80
;Count from 0-9 on the seven segment display
;Depends on RAM and therefore uses call and ret

;Constants



org 0
    CALL    startup
    LD  HL,commands      ;Address of command list, $ff terminated

command_loop:
    CALL    lcd_wait_loop  ;wait for display to be ready
    LD  A,(HL)           ;Next command
    INC A               ;Add 1 so we can test for $ff...
    JR  Z,command_end    ;...by testing for zero
    DEC A               ;Restore the actual value
    OUT (lcd_command),A ;Output it.
    INC HL              ;Next command
    JR  command_loop     ;Repeat
command_end:
    LD  HL,start_message ;Message address, 0 terminated
message_loop:           ;Loop back here for next character
    CALL    lcd_wait_loop  ;wait for lcd

    LD  A,(HL)           ;Load character into A
    AND A               ;Test for end of string (A=0)
    JR  Z,message_done

    OUT (lcd_data),A    ;Output the character
    INC HL              ;Point to next character
    JR  message_loop     ;Loop back for next character

message_done:
    HALT

start_message:
    DB  "Keyboard test",0

INCLUDE
    'library.asm'
