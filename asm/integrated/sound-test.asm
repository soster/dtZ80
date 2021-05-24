;sound-test.asm
;Test dtz80 sound capability
;Needs RAM
; rasm sound-test.asm sound-test && minipro -p "at28c256" -w sound-test.bin -s

;Constants
data_port
  EQU $81
register_port
  EQU $80

org  0
  CALL startup
  LD A,0
  CALL segprint_num
  CALL LCD_PREPARE
  LD HL,START_MESSAGE       ;Message address, 0 terminated
  call LCD_MESSAGE
  LD A,1
  CALL segprint_num

sound:
  LD A,7
  OUT (register_port),A ;select the mixer register
  LD A,62
  OUT (data_port),A ; enable channel A only
  LD A,8
  OUT (register_port),A ; channel A volume
  LD A,15
  OUT (data_port),A ; set it to maximum
  LD A,0
  OUT (register_port),A; select channel A pitch
reset:
  
  LD B,255
loop:
  
  LD A,B
  OUT (data_port),A; set it
  CALL pause
  DEC B
  JP NZ,loop
  JP reset
pause:
  
  PUSH BC
  PUSH DE
  PUSH AF
  LD BC,$1500            ; Loads BC with hex 1000
outer:
  
  DEC BC                  ; Decrements BC
  LD A,B                 ; Copies B into A
  OR C                   ; Bitwise OR of C with A (now, A = B | C)
  JP NZ,outer            ; Jumps back to Outer: label if A is not zero

  POP AF
  POP DE
  POP BC
  RET                     ; Return from call to this subroutine

done:
  
  HALT


start_message:
  DB  "Sound Test",0

INCLUDE 'dtz80-lib.inc'
