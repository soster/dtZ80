;sound.z80
;Count from 0-9 on the seven segment display
;Depends on RAM and therefore uses call and ret

;Constants
data_port equ $d0
register_port equ $d8

org 0
    call startup
    ld hl,commands      ;Address of command list, $ff terminated

mloop:
    ld a,(hl)           ;Load character into A
    and a               ;Test for end of string (A=0)
    jr z,sound
    ld a,b
    call segprint_num
    inc b
    inc hl              ;Point to next character
    call delay
    jr mloop     ;Loop back for next character
sound:
  ld a, 7
  out (register_port), a ;select the mixer register
  ld a, 62
  out (data_port),a ; enable channel A only
  ld a, 8
  out (register_port),a ; channel A volume
  ld a, 15
  out (data_port),a ; set it to maximum
  ld a, 0
  out (register_port),a; select channel A pitch
reset:
  ld b, 255
loop:
  ld a, b
  out (data_port),a; set it
  call pause
  dec b
  jp nz, loop
  jp reset
pause:
  push bc
  push de
  push af

  LD BC, $1500            ;Loads BC with hex 1000
outer:
  DEC BC                  ;Decrements BC
  LD A, B                 ;Copies B into A
  OR C                    ;Bitwise OR of C with A (now, A = B | C)
  JP NZ, outer            ;Jumps back to Outer: label if A is not zero

  pop af
  pop de
  pop bc
  RET                     ;Return from call to this subroutine

done:
    halt

INCLUDE 'library.asm'
