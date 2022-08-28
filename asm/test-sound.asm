;sound-test.asm
;Test dtz80 sound capability
;Needs RAM
;rasm sound-test.asm sound-test && minipro -p "at28c256" -w sound-test.bin -s



org 0
    ld sp,STACKPOINTER
    call LCD_PREPARE
    ld hl,START_MESSAGE       ;Message address, 0 terminated
    call LCD_MESSAGE

SOUND:
    ld a,7
    out (SOUND_REGISTER),a ;select the mixer register
    ld a,62
    out (SOUND_DATA),a ; enable channel A only
    ld a,8
    out (SOUND_REGISTER),a ; channel A volume
    ld a,15
    out (SOUND_DATA),a ; set it to maximum
    ld a,0
    out (SOUND_REGISTER),a; select channel A pitch
reset:

    ld b,255
loop:

    ld a,b
    out (SOUND_DATA),a; set it
    call pause
    dec b
    jp nz,loop
    jp reset


PAUSE:
    push bc
    push de
    push af
    ld bc,$1500            ; Loads BC with hex 1000
outer:

    dec bc                  ; Decrements BC
    ld a,b                 ; Copies B into A
    or c                   ; Bitwise OR of C with A (now, A = B | C)
    jp nz,outer            ; Jumps back to Outer: label if A is not zero

    pop af
    pop de
    pop bc
    ret                     ; Return from call to this subroutine

DONE:

    halt


START_MESSAGE:
    db "Sound Test",0

    include 'dtz80-lib.inc'
    include 'lcd-lib.inc'
