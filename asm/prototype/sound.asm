;sound.z80
;Example sound for the sound card
;Needs RAM

;Constants
data_port
  EQU $d0
register_port
  EQU $d8

org
  0
  CALL  startup
  LD  HL,commands      ;Address of command list, $ff terminated

mloop:
  LD  A,(HL)           ;Load character into A
  AND A               ;Test for end of string (A=0)
  JR  Z,sound
  LD  A,B
  CALL  segprint_num
  INC B
  INC HL              ;Point to next character
  CALL  delay
  JR  mloop     ;Loop back for next character
sound:
  LD  A,7
  OUT (register_port),A ;select the mixer register
  LD  A,62
  OUT (data_port),A ; enable channel A only
  LD  A,8
  OUT (register_port),A ; channel A volume
  LD  A,15
  OUT (data_port),A ; set it to maximum
  LD  A,0
  OUT (register_port),A; select channel A pitch
reset:
  LD  B,255
loop:
  LD  A,B
  OUT (data_port),A; set it
  CALL  pause
  DEC B
  JP  NZ,loop
  JP  reset
pause:
  PUSH  BC
  PUSH  DE
  PUSH  AF

  LD  BC,$1500            ; Loads BC with hex 1000
outer:
  DEC BC                  ; Decrements BC
  LD  A,B                 ; Copies B into A
  OR  C                   ; Bitwise OR of C with A (now, A = B | C)
  JP  NZ,outer            ; Jumps back to Outer: label if A is not zero

  POP AF
  POP DE
  POP BC
  RET                     ; Return from call to this subroutine

done:
  HALT

INCLUDE 'library.asm'
