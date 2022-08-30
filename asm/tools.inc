; Subroutines / tools



; This fills the ram with a starting at hl with a for bc bytes.
; HL = start address of block
; DE = HL + 1
FILL_RAM:
	ld e,l
	ld d,h
	inc de

        ;; initialise first byte of block
        ;; with data byte
	ld (hl),a

        ;; BC = length of block in bytes
        ;; HL+BC-1 = end address of block


        ;; fill memory
	ldir
	ret


; hl and de pointing to the first character of the strings to compare
; bc holding the length of the strings.
; z flag set if equal

STRCMP:
	push hl
	push de
cmploop:
	ld a,(de)          ; Compare bytes.
	cpi
	jr nz,nomatch      ; If (HL) != (DE), abort.
	inc de              ; Update pointer.
	jp pe,cmploop

	pop de
	pop hl
	ld a,(de)          ; Check string lengths to see if really equal.
	cp (hl)
	ret
nomatch:
	dec hl
	cp (hl)            ; Compare again to affect carry.
	pop de
	pop hl
	ret

; Decimal to ASCII (2 digits only), in: A, out: DE
DTOA2D:
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
