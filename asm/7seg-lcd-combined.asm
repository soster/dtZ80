;LCD.z80
;Writing to a standard LCD
;Works without RAM (no stack)
;RASM compatible
;derived from bread80, bread80.com

;Constants
sevensegio
  EQU $00 	 ;I/O port 7 segment A0-A7=0
lcd_command
  EQU $20	 ;LCD command I/O port, A5=1
lcd_data
  EQU $21        ;LCD data I/O port,A5=1,A0=1
; 7 segment values:
n0
  EQU $3f
n1
  EQU $6
n2
  EQU $5b
n3
  EQU $4f
n4
  EQU $66
n5
  EQU $6d
n6
  EQU $7d
n7
  EQU $7
n8
  EQU $7f
n9
  EQU $6f

; macro instead of subroutine because stack is missing (no sub/ret)
MACRO delay
  LD  E,#4
@j60:
  LD  B,#40
@j61:
  LD  D,#ff
@j62:
  DEC D
  JP  NZ,@j62
  DEC B
  JP  NZ,@j61
  DEC E
  JP  NZ,@j60
MEND

MACRO segprint  value
  LD  A,{value}
  OUT (sevensegio),A
MEND

;MACRO because we can't use call/ret
MACRO lcd_wait
@lcd_wait_loop:	 ;label with @ changes for each macro occurance
  IN  A,(lcd_command)  ;Read the status into A
    			 ;trick to conditionally jump if bit 7 is true:
  RLCA                ;Rotate A left, bit 7 moves into the carry flag
  JR  C,@lcd_wait_loop ;Loop back if the carry flag is set
MEND

org
  0
  LD  HL,commands      ;Address of command list, $ff terminated

command_loop:
  lcd_wait  (void)	 ;macro to wait for lcd readiness...
  LD  A,(HL)           ;Next command
  INC A               ;Add 1 so we can test for $ff...
  JR  Z,command_end    ;...by testing for zero
  DEC A               ;Restore the actual value
  OUT (lcd_command),A ;Output it.

  INC HL              ;Next command
  JR  command_loop     ;Repeat

command_end:
  LD  HL,MESSAGE       ;Message address, 0 terminated
message_loop:           ;Loop back here for next character
  lcd_wait  (void)	 ;wait for lcd
  delay (void)

  LD  A,(HL)           ;Load character into A
  AND A               ;Test for end of string (A=0)
  JR  Z,done

  OUT (lcd_data),A    ;Output the character
  OUT (sevensegio),A  ;Output to 7seg, too
  INC HL              ;Point to next character
  JR  message_loop     ;Loop back for next character

done:
  LD  HL,numbers
number_loop:
  lcd_wait  (void)
  delay (void)
  LD  A,(HL)
  AND A
  JR  Z,done
  OUT (lcd_data),A
  segprint  A
  INC HL
  JR  number_loop;

;Startup command sequence:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift

commands:               ;$ff terminated
  DB  $3f,$0f,$01,$06,$ff

message:
  DB  "HELLO WORLD!",0
numbers:
  DB  n0,n1,n2,n3,n4,n5,n6,n7,n8,n9,0
