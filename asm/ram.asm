;ram.z80
;Uses RAM for the first time
;Sets the stackpointer to RAM
;sub and ret should work now!

;Constants
sevensegio
  EQU $00 	    ;I/O port 7 segment A0-A7=0
lcd_command
  EQU $20	      ;LCD command I/O port, A5=1
lcd_data
  EQU $21       ;LCD data I/O port,A5=1,A0=1
stackpointer
  EQU $8fff     ;Address for the stack pointer
sevensegram
  EQU $8000

org
  0                     ; start at address 0
  LD  SP,stackpointer   ; Initialize Stack Pointer
  LD  HL,commands       ; Address of command list, $ff terminated

command_loop:
  CALL  lcd_wait
  LD  A,(HL)            ;Next command
  INC A                ;Add 1 so we can test for $ff...
  JR  Z,command_end    ;...by testing for zero
  DEC A                ;Restore the actual value
  OUT (lcd_command),A  ;Output it.
  INC HL               ;Next command
  JR  command_loop     ;Repeat

command_end:
  LD  HL,MESSAGE       ;Message address, 0 terminated
message_loop:          ;Loop back here for next character
  CALL  lcd_wait
  LD  A,(HL)           ;Load character into A
  AND A                ;Test for end of string (A=0)
  JR  Z,number_loop
  OUT (lcd_data),A     ;Output the character
  INC HL               ;Point to next character
  JR  message_loop     ;Loop back for next character

number_loop:
  LD  A,0              ;Offset for the number to display
next_number:
  CALL  segprint_num   ;Display number stored in a
  INC A                ;Next number offset
  LD  B,9              ;for checking if offset=9
  CP  B                ;if a-b=0 set zero flag
  JP  NZ,next_number   ;if zero flag not set continue
  JR  number_loop      ;otherwise reset a to 0

;subroutines:
delay:; 3 cascaded 8 bit loops to create some 100ms delay
  LD  E,#4
  loop1
  LD  B,#40
  loop2
  LD  D,#ff
  loop3
  DEC D
  JP  NZ,loop3
  DEC B
  JP  NZ,loop2
  DEC E
  JP  NZ,loop1
  RET

  segprint;print content of a to 7segment and wait
  OUT (sevensegio),A
  CALL  delay
  RET

  segprint_num;interpret a as a number 0-9 and translate it to the 7seg byte
  LD  HL,numbers
  LD  B,0
  LD  C,A
  ADD HL,BC
  LD  A,(HL)
  OUT (sevensegio),A
  LD  A,C
  CALL  delay
  RET
  lcd_wait
  lcd_wait_loop
  IN  A,(lcd_command)  ;Read the status into A
                       ;trick to conditionally jump if bit 7 is true:
  RLCA                 ;Rotate A left, bit 7 moves into the carry flag
  JR  C,lcd_wait_loop  ;Loop back if the carry flag is set
  RET

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift

commands:               ;$ff terminated
  DB  $3f,$0f,$01,$06,$ff
message:
  DB  "HELLO WORLD!!!",0
numbers:;7 seg number representations 0-9
  DB  $3f,$6,$5b,$4f,$66,$6d,$7d,$7,$7f,$6f,0
