;Music Player
;rasm player.asm player && minipro -p "at28c256" -w player.bin -s

;Only works if copied into RAM:
RAM_DEST
	equ $8000

RAMCELL
	equ $f000

; if not 0, then start new song
RESET_SONG
	equ $f002





RESET:
	org 0
	jp MAIN

   ; interrupt vector for SIO
	org $0c
	defw RX_CHA_AVAILABLE
	org $0E
	defw SPEC_RX_CONDITON


	org $0100           ; main code starts at $0100 because of interrupt vector!
MAIN:
	ld sp,stackpointer
	call SET_CTC         ; configure CTC
	call SET_SIO         ; configure SIO
	ld a,0             ; set high byte of interrupt vectors to point to page 0
	ld i,a

	im 2               ; set int mode 2
	ei                      ; enable interupts

	ld a,0     ; load initial value into RAM
	ld (RAMCELL),a
	ld (RESET_SONG),a

	call A_RTS_OFF        ; remove RTS

  ;Show some numbers:
	ld a,0
	ld (ram_counter),a
	ld a,1              ;Offset for the number to display
	call delay

	call LCD_PREPARE
	ld hl,STARTUP_STR
	call LCD_MESSAGE


	call BOOTSTRAP


	INCLUDE'dtz80-lib.inc'
	INCLUDE'sio-ctc-init.inc'

ERROR_STR
	db 'ERROR',0

STARTUP_STR
	db '8 Bit Music Player',0

PLAYING_STR
	db 'PLAYING ',0

STOP_STR
	db 'STOPPED',0


RX_CHA_AVAILABLE:
	in a,(SIO_DA)      ; read RX character into A

	ld hl,SCAN_LOOKUP     ; fetch scancode from lookup table
	ld b,0
	ld c,a
	adc hl,bc
	ld a,(HL)

	ld (RESET_SONG),a

	ld de,CHECK_SCANCODE_FOR_SONG ;This will be the address on the stack after the interrupt
	push de          ;Put on Stack. Will jump here after RETI

	ei
	reti

SPEC_RX_CONDITON:
	ld hl,ERROR_STR
	call LCD_MESSAGE
	call DELAY
	jp $0000            ; if buffer overrun then restart the program				

; Check for input character in (RESET_SONG) and plays song number
CHECK_SCANCODE_FOR_SONG:
	call LCD_PREPARE; delete screen
	ld hl,PLAYING_STR;
	call LCD_MESSAGE; "PLAYING "

	ld a,(RESET_SONG); fetch input character
	out (lcd_data),a ;Output the character

				;Check for input number
	cp '1'
	jr z,SELECT_1

	cp '2'
	jr z,SELECT_2

	cp '3'
	jr z,SELECT_3

	cp '4'
	jr z,SELECT_4

	cp '5'
	jr z,SELECT_5

	cp '6'
	jr z,SELECT_6

	cp SPACE
	jr z,SELECT_SPACE


				;Default:
	ld hl,SONG


	jr CHECK_SCANCODE_FOR_SONG_END
SELECT_1:
	ld hl,SONG
	jr CHECK_SCANCODE_FOR_SONG_END
SELECT_2:
	ld hl,SONG2
	jr CHECK_SCANCODE_FOR_SONG_END
SELECT_3:
	ld hl,SONG3
	jr CHECK_SCANCODE_FOR_SONG_END
SELECT_4:
	ld hl,SONG4
	jr CHECK_SCANCODE_FOR_SONG_END
SELECT_5:
	ld hl,SONG5
	jr CHECK_SCANCODE_FOR_SONG_END
SELECT_6:
	ld hl,SONG6
	jr CHECK_SCANCODE_FOR_SONG_END
SELECT_SPACE:; mute:
	xor a
	ld h,a
	ld l,a
	ld (AYREGS+AmplA),a
	ld (AYREGS+AmplB),hl
	xor a
	ld c,SOUND_REGISTER
	ld hl,AYREGS
LOUT2:
	out (C),a
	ld c,SOUND_DATA
	outi
	ld c,SOUND_REGISTER
	inc a
	cp 13
	jr nz,LOUT2
	out (C),a

	ld hl,(STOP_STR
	call LCD_MESSAGE

SELECT_SPACE_LOOP:
	call DELAY
	jr SELECT_SPACE_LOOP



CHECK_SCANCODE_FOR_SONG_END:
	ld a,0
	ld (RESET_SONG),a;reset input character here
	jp STARTHL;Start player with song in HL
; --- END Check Scancode

; Music tracks:
SONG
	equ $
	incbin "./tunes/through_yeovil.pt3"
SONG2
	equ $
	incbin "./tunes/MmcM_-_Summer_of_Rain.pt3"
SONG3
	equ $
	incbin "./tunes/altitude.pt3"
SONG4
	equ $
	incbin "./tunes/Voxel - Ghostbusters (TSmix) by voxel_triumph.pt3"
SONG5
	equ $
	incbin "./tunes/MmcM_-_Agressive_Attack.pt3"
SONG6
	equ $
	incbin "./tunes/backup_forever.pt3"


BOOTSTRAP:
  ;copy into RAM:
	ld hl,BOOTSTRAP_END ;Code to be moved
	ld de,RAM_DEST ;Destination address
	ld bc,28000;guess how much bytes to copy
	ldir                ;Copy
	jp $8000; JP to RAM where the program has been copied to



; -------------------
; Player Code copied in RAM:
; -------------------
BOOTSTRAP_END:
ORG
	#8000,BOOTSTRAP_END
START_RAM:


	ld a,0
	ld (START+10),a
	ld hl,SONG
	call STARTHL

; The Music player code:
	INCLUDE'player.inc'


RAM_END
	equ $ ;end address to copy into ram
