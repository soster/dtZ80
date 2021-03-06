; test-lib.asm
; Test 7seg and lcd library routines
; Needs RAM
; rasm test-lib.asm test-lib && minipro -p "at28c256" -w test-lib.bin -s

  org 0
  CALL startup
  ld a,#0
  call segprint_num
  ld a,#1
  call segprint_num
  CALL LCD_WAIT
  ld a,#2
  CALL segprint_num
  CALL LCD_PREPARE
  ld a,#3
  CALL segprint_num
  LD HL,START_MESSAGE       ;Message address, 0 terminated
  call LCD_MESSAGE
  CALL DELAY
  ld a,#4
  CALL segprint_num
  HALT

start_message:
  DB  "Testing.. 7Seg should show 4",0

include 'dtz80-lib.inc'