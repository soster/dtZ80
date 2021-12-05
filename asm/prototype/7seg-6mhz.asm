;7seg-6mhz.z80
;minipro -p "at28c256" -w rasmoutput.bin -s

;Constants
ioport
  EQU #00 ;I/O port
n0
  EQU #3f
n1
  EQU #6
n2
  EQU #5b
n3
  EQU #4f
n4
  EQU #66
n5
  EQU #6d
n6
  EQU #7d
n7
  EQU #7
n8
  EQU #7f
n9
  EQU #6f

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
  OUT (ioport),A
MEND

org
  0
begin:
  segprint  n0
  delay (void)
  segprint  n1
  delay (void)
  segprint  n2
  delay (void)
  segprint  n3
  delay (void)
  segprint  n4
  delay (void)
  segprint  n5
  delay (void)
  segprint  n6
  delay (void)
  segprint  n7
  delay (void)
  segprint  n8
  delay (void)
  segprint  n9
  delay (void)

  LD  A,#ff
iterate:
  OUT (ioport),A
  delay (void)
  DEC A
  JP  NZ,iterate
  JP  begin
nop
nop
nop
