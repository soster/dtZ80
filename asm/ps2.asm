;sevenseg-ram.z80
;Count from 0-9 on the seven segment display
;Depends on RAM and therefore uses call and ret
; rasm ps2.asm ps2 && minipro -p "at28c256" -w ps2.bin -s
;Constants


prev_value
    EQU $0800
counter
    EQU $0801
last_clk
    EQU $0802
value
    EQU $0803
keycode
    EQU $0804

org 0
    CALL    startup
    LD  HL,numbers      ;Address of command list, $ff terminated

MESSAGE_LOOP:
    CALL DELAY
    LD  A,(HL)           ;Load character into A
    AND A               ;Test for end of string (A=0)
    JR  Z,next_key
    OUT (sevensegio),A    ;Output the character
    INC B
    INC HL              ;Point to next character
    JR  MESSAGE_LOOP     ;Loop back for next character




;1 start bit.  This is always 0.8 data bits, least significant bit first.1 parity bit (odd parity).1 stop bit.  This is always 1. Read when clock is low.

next_key:
    CALL DELAY
    LD  A,$3f
    OUT (sevensegio),A
    LD  A,0
    LD  (counter),A
    LD  (value),A
    LD  (keycode),A
    LD  (last_clk),A
    LD  A,00001100b      ;DATA&CLK high allows sending data from keyboard
    OUT (keyboard),A
    CALL DELAY
    LD  A,0
    OUT (keyboard),A
keyboard_loop:

    CALL DELAY
    IN  A,(keyboard)
    LD  (value),A
    AND 00000010b       ;only clock bit
    LD  HL,last_clk     ;load address of last clock into hl
    CP  (HL)            ;compare a with last clock, z=1 if true
    JP  Z,keyboard_loop ;go back if the same.
    LD  (last_clk),A     ;store last clock
    AND A               ;check if clk is zero
    JP  NZ,keyboard_loop ;if clk high then back
    LD  A,(counter)      ;load counter into A
    INC A               ;counter++
    LD  (counter),A      ;save counter
    ;ignore bits 1+10
    CP  1
    JP  Z,keyboard_loop
    CP  10
    JP  Z,keyboard_loop

    CP  11               ;11. bit=ready
    JP  Z,value_complete
    
    LD  A,(value)        ;load value again
    AND 00000001b       ;only data bit
    LD  B,A             ;put data bit into B

    LD  A,(KEYCODE)     ;Load Keycode
    SLA A               ;left shift keycode, bit 0=0
    OR B                ;put data bit into bit 0
    LD (KEYCODE),A
    JR  keyboard_loop
value_complete:
    LD A,(keycode)
    OUT (sevensegio),A  ;show keycode
    JP  next_key



INCLUDE 'library.asm'
