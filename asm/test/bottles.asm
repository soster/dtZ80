; 99 Bottles of Beer program in Z80 assembly language.
; Originally from 
; http://www.99-bottles-of-beer.net/language-assembler-(z80)-813.html
; Compile with:
; rasm bottles.asm bottles
; Start simulator:
; z88dk-ticks -iochar 5 bottles.bin

	org 0

start:
	ld sp,STACK
	ld c,99                       ; Number of bottles to start with


loopstart:
	call printc                   ; Print the number of bottles
	ld hl,line1                   ; Print the rest of the first line
	call printline

	call printc                   ; Print the number of bottles
	ld hl,line2_3                 ; Print rest of the 2nd and 3rd lines
	call printline

	dec c                         ; Take one bottle away
	call printc                   ; Print the number of bottles
	ld hl,line4                   ; Print the rest of the fourth line
	call printline

	ld a,c
	cp 0                          ; Out of beer bottles?
	jp nz,loopstart               ; If not, loop round again

	halt                           ; Return to BASIC


printc:                        	; Routine to print C register as ASCII decimal
	ld a,c
	call dtoa2d                   ; Split A register into D and E

	ld a,d                        ; Print first digit in D
	cp '0'                        ; Don't bother printing leading 0
	jr z,printc2
	out (5),a                    ; Spectrum: Print the character in 'A'

printc2:
	ld a,e                        ; Print second digit in E
	out (5),a                        ; Spectrum: Print the character in 'A'
	ret


printline:                     ; Routine to print out a line
	ld a,(hl)                     ; Get character to print
	cp 0                        ; See if end of string
	jp z,printend                 ; We're done if it is
	out (5),a                        ; Simulator: Print the character in a
	inc hl                        ; Move onto the next character
	jp printline                  ; Loop round

printend:
	ret


dtoa2d:                        ; Decimal to ASCII (2 digits only), in: A, out: DE
	ld d,'0'                      ; Starting from ASCII '0' 
	dec d                         ; Because we are inc'ing in the loop
	ld e,10                       ; Want base 10 please
	and a                         ; Clear carry flag

dtoa2dloop:
	inc d                         ; Increase the number of tens
	sub e                         ; Take away one unit of ten from A
	jr nc,dtoa2dloop              ; If A still hasn't gone negative, do another
	add a,e                       ; Decreased it too much, put it back
	add a,'0'                     ; Convert to ASCII
	ld e,a                        ; Stick remainder in E
	ret

; Data
line1:
	defb ' bottles of beer on the wall,',13,10,0
	;13,10 = CRLF, CR alone corrupts the simulator...
line2_3:
	defb ' bottles of beer, Take one down, pass it around,',13,10,0
line4:
	defb ' bottles of beer on the wall.',13,10,0
STACK: