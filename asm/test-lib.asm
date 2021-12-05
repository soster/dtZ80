; test-lib.asm
; Test 7seg and lcd library routines
; Needs RAM
; rasm test-lib.asm test-lib && minipro -p "at28c256" -w test-lib.bin -s

  org 0
  LD  SP,stackpointer
  CALL LCD_WAIT
  CALL LCD_PREPARE
  LD HL,START_MESSAGE       ;Message address, 0 terminated
  call LCD_MESSAGE
  CALL DELAY
  ld a,#4
  CALL segprint_num
  HALT

start_message:
  DB  "1: 20 characters...12: 20 characters...23: 20 characters...34: 20 characters...45: 20 characters...5",0

include 'dtz80-lib.inc'