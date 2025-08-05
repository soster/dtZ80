; Include this for LCD functionality.
; 4 rows, 20 Columns character LCD 2004A based on the HD44780 controller
; 4 line lcd: http://www.ekenrooi.net/lcd/lcd0.shtml#_4_line_displays
; https://www.sparkfun.com/datasheets/LCD/HD44780.pdf


; LCD Commands:
LCD_COM_CLEAR
    equ 00000001b
LCD_COM_HOME
    equ 00000010b
LCD_COM_ON_CURSOR
    equ 00001110b
LCD_COM_ON_NO_CURSOR
    equ 00001100b
LCD_COM_CUR_LEFT
    equ 00010000b
LCD_COM_CUR_RIGHT
    equ 00010100b
; ----

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font (only 2 or 1 line mode possible)
;$0f: Display on, cursor on (alt: Display on, cursor off = $0C), Display off = $08
;$01: Clear display
;$06: Entry mode: left to right, no shift <- don't do this for 4 line mode!
;$80: DRAM Counter to 0 ($80+ADDR)
;ff terminated.
LCD_COMMANDS:
    db $3f,LCD_COM_ON_CURSOR,LCD_COM_CLEAR,$80,$ff





; For compatibility with 2 line displays there is some weird adressing going on,
; line 2 starts at $40 and line 4 at $54. For a 2 line display use only $00 and $14.
; addresses are $00,$40,$14,$54 or'd with $80. $80 is bit #7 set to high, rest of the bits are the address.
LCD_LINE_ADDR:
    db $80,$c0,$94,$d4
;Number of lines in LCD
LCD_LINES
    equ $04



message:
    db "HELLO WORLD!",0

LCD_RESET:
    out (1),a; LCD RESET LINE A0 = 1
    call DELAY_SHORT; Wait a little
    out (0),a; RESET A0 to 0

LCD_SET_RAM_ADDR:
    call LCD_WAIT
    or $7f;For setting dram address highest bit = 1
    out (LCD_COMMAND),a
    call LCD_WAIT
    ret


; Sends the init commands to the lcd
; Ues HL, AF
LCD_PREPARE:
    ld hl,LCD_COMMANDS      ;Address of command list for LCD, $ff terminated
LCD_COM_LOOP:

    ld a,(HL)           ;Next command
    inc a               ;Add 1 so we can test for $ff...
    jr z,LCD_COM_END    ;...by testing for zero
    dec a               ;Restore the actual value
    out (LCD_COMMAND),a ;Output it.
    call LCD_WAIT

    inc hl              ;Next command
    jr LCD_COM_LOOP     ;Repeat
LCD_COM_END:
    ret


; Send a message to the LCD
; Expects the pointer in HL
; Message terminated by 0
; Uses HL, AF, BC
LCD_MESSAGE:
    ld a,(CURSOR_COLUMN)
    ld b,a;column

    ld a,(CURSOR_LINE)
    ld c,a;line

LCD_MESSAGE_BEG:
    ld a,(HL)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,MESSAGE_END

    inc hl              ;Point to next character

    ; test for special characters:
    cp CR                       ; a=Enter key?
    jr z,MESSAGE_NEW_LINE       ; if yes, simulate new line
    cp BACK_SPACE               ; a=Backspace?
    jr nz,CONTINUE_SPECIAL1     ; if not, ...
    dec b                       ; col counter
    push af                     ; save a!             
    ld a,LCD_COM_CUR_LEFT
    out (LCD_COMMAND),a         ;Cursor one left
    call LCD_WAIT
    ld a,SPACE
    out (LCD_DATA),a            ;overwrite character
    call LCD_WAIT
    ld a,LCD_COM_CUR_LEFT
    out (LCD_COMMAND),a         ;again one left
    call LCD_WAIT
    pop af                      ;restore a
    jr LCD_MESSAGE_BEG          ;next char
CONTINUE_SPECIAL1:
    ; end special characters
    out (lcd_data),a    ;Output the character
    call LCD_WAIT

    inc b               ; INC character counter
    ld a,b             ; Load num of characters into A
    cp $14;            ; $14=first of next line
    jp z,MESSAGE_NEW_LINE
    jr LCD_MESSAGE_BEG ;Loop back for next character
MESSAGE_NEW_LINE:
    push hl
    ld b,0;Reset character counter
    inc c;inc line counter
    ld hl,LCD_LINE_ADDR;holds the lcd addresses for the 4 lines
    add hl,bc;b already is 0, c has line counter in it!
    ld a,(HL); Load new address for LCD Line
    out (LCD_COMMAND),a;set new character pos address
    call LCD_WAIT
    ld a,c
    cp LCD_LINES; line counter = num of lines?
    jp z,MESSAGE_RESET_LINE
MESSAGE_NEW_LINE_END:
    pop hl
    jr LCD_MESSAGE_BEG
MESSAGE_RESET_LINE:
    ld c,0; Reset line counter
    jr MESSAGE_NEW_LINE_END
MESSAGE_END:
    ; write back current column & line:
    ld hl,CURSOR_COLUMN
    ld (hl),b
    ld hl,CURSOR_LINE
    ld (hl),c
    ret




; sends A to the LCD on the next 
; natural LCD pos
LCD_PRINT_CHAR
    ; a will be stored in the 573, we have to toggle something after a delay
    out (lcd_data),a
    call DELAY_SHORT
    out (2),a; Sets LCD RW (A1) to Read and therefore acknowledges the last send char
    ret


; Send a message to the LCD
; Expects the pointer in HL
; Message terminated by 0
; Uses HL, AF
; Does not properly work with 4 line lcd
LCD_MESSAGE_SIMPLE:
    call LCD_WAIT
    ld a,(HL)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,MESSAGE_SIMPLE_END
    out (lcd_data),a    ;Output the character
    inc hl              ;Point to next character
    jr LCD_MESSAGE_SIMPLE     ;Loop back for next character
MESSAGE_SIMPLE_END:
    ret

LCD_CLEAR:
    ld a,$01;
    out (LCD_COMMAND),a
    call LCD_WAIT
    ret



; Wait passively for the lcd to execute the last command
; Also resets the stored value on the data lines
LCD_WAIT:
    push af
    ld a,$ff
lcd_wait_loop:
    dec a
    jr nz,lcd_wait_loop

    ld a,$ff
lcd_wait_loop2:
    dec a
    jr nz,lcd_wait_loop2

    ld a,0
    out (SEVENSEGO),a;reset output so that the lcd can acknowledge the last value
    pop af
    ret


; Wait passively for the lcd to execute the last command
; Also resets the stored value on the data lines
LCD_WAIT_SHORT:
    push af
    ld a,$aa
lcd_wait_loop3:
    dec a
    jr nz,lcd_wait_loop3
    ld a,0
    out (SEVENSEGO),a;reset output so that the lcd can acknowledge the last value
    pop af
    ret
