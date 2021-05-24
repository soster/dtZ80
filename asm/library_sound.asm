;Library to include in the sound player
;Constants
sevensegio
  EQU $00 	    ;I/O port 7 segment A0-A7=0
lcd_command
  EQU $20	    ;LCD command I/O port, A5=1
lcd_data
  EQU $21        ;LCD data I/O port,A5=1,A0=1
button
  EQU $40	        ;Button Input, dummy for now
stackpointer
  EQU $8fff  ;Address for the stack pointer
ram_counter
  EQU $b000   ; Address for a counter in RAM

;Startup command sequence for the lcd:
;$3f: Function set: 8-bit interface, 2-line, small font
;$0f: Display on, cursor on
;$01: Clear display
;$06: Entry mode: left to right, no shift
;ff terminated.
commands:
  DB  $3f,$0f,$01,$06,$ff

;7 segment numbers,0-9:
numbers:
  DB  $3f,$6,$5b,$4f,$66,$6d,$7d,$7,$7f,$6f,0

message:
  DB  "HELLO WORLD!",0

;subroutines:

;startup initializations
startup:
  LD  SP,stackpointer
  RET

delay2:; 3 cascaded 8 bit loops to create some 100ms delay
  PUSH  DE
  PUSH  BC
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
  POP BC
  POP DE
  RET

inc_ram_counter:;Increment the counter
  PUSH  AF     ;save af
  LD  A,(ram_counter)
  INC A
  LD  (ram_counter),A
  POP AF
  RET

ram_counter_segprint:;print ram counter to seven segment
  PUSH  AF
  LD  A,(ram_counter)
  OUT (sevensegio),A
  POP AF
  RET


segprint_num:;interpret a as a number 0-9 and translate it to the 7seg byte
  PUSH  AF     ;save af
  PUSH  HL     ;save hl
  PUSH  BC     ;save bc
  LD  HL,numbers
  LD  B,0
  LD  C,A
  ADD HL,BC
  LD  A,(HL)
  OUT (sevensegio),A
  POP BC      ;restore bc
  POP HL      ;restore hl
  POP AF      ;restore af
  RET

lcd_wait_loop2:;wait until lcd is ready
  IN  A,(lcd_command)      ;Read the status into A
    ;trick to conditionally jump if bit 7 is true:
  RLCA                    ;Rotate A left, bit 7 moves into the carry flag
  JR  C,lcd_wait_loop2      ;Loop back if the carry flag is set
  RET
