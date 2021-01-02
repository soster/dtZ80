;7seg-6mhz.z80
;minipro -p "at28c256" -w rasmoutput.bin -s

;Constants
ioport equ $00 ;I/O port
n0 equ #3f
n1 equ #6
n2 equ #5b
n3 equ #4f
n4 equ #66
n5 equ #6d
n6 equ #7d
n7 equ #7
n8 equ #7f
n9 equ #6f

; macro instead of subroutine because stack is missing (no sub/ret)
MACRO delay
  ld e,#4
@j60:
  ld b,#40
@j61:
  ld d,#ff
@j62:
  dec	d
  jp	nz,@j62
  dec b
  jp nz,@j61
  dec e
  jp nz,@j60
MEND

MACRO segprint value
  ld a,{value}
  out (ioport),a
MEND

org 0
begin:
    segprint n0
    delay (void)
    segprint n1
    delay (void)
    segprint n2
    delay (void)
    segprint n3
    delay (void)
    segprint n4
    delay (void)
    segprint n5
    delay (void)
    segprint n6
    delay (void)
    segprint n7
    delay (void)
    segprint n8
    delay (void)
    segprint n9
    delay (void)

    ld a,#ff
iterate:
    out (ioport),a
    delay (void)
    dec a
    jp nz,iterate
    jp begin
nop
nop
nop
