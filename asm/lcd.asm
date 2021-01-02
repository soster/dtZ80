;LCD.z80
;Writing to a standard LCD
;Works without RAM (no stack)
;RASM compatible
;derived from bread80, bread80.com

;Constants
lcd_command equ $20	 ;LCD command I/O port, A5=1
lcd_data equ $21        ;LCD data I/O port,A5=1,A0=1

;MACRO because we can't use call/ret
MACRO lcd_wait
@lcd_wait_loop:	 ;label with @ changes for each macro occurance
    in a,(lcd_command)  ;Read the status into A
    			 ;trick to conditionally jump if bit 7 is true:
    rlca                ;Rotate A left, bit 7 moves into the carry flag
    jr c,@lcd_wait_loop ;Loop back if the carry flag is set
MEND
    
org 0
    ld hl,commands      ;Address of command list, $ff terminated
    
command_loop:
    lcd_wait (void)	 ;macro to wait for lcd readiness...
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
    lcd_wait (void)	 ;wait for lcd

    ld a,(hl)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,done

    out (lcd_data),a    ;Output the character
    inc hl              ;Point to next character
    jr message_loop     ;Loop back for next character

done:
    halt                ;Halt the processor

;Startup command sequence:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift

commands:               ;$ff terminated
    db $3f,$0f,$01,$06,$ff
    
message:
    db "HELLO WORLD!",0
