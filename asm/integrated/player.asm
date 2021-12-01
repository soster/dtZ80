;Music Player
;rasm player.asm player && minipro -p "at28c256" -w player.bin -s

;Only works if copied into RAM:
RAM_DEST EQU	$8000

RAMCELL EQU     $f000

; if not 0, then start new song
RESET_SONG EQU $f002





RESET:
  ORG     0
  JP      MAIN

   ; interrupt vector for SIO
   ORG     0ch
   DEFW    RX_CHA_AVAILABLE
   ORG     0Eh
   DEFW    SPEC_RX_CONDITON


  ORG     0100h           ; main code starts at $0100 because of interrupt vector!
MAIN:
  LD	SP,stackpointer
	CALL    SET_CTC         ; configure CTC
  CALL    SET_SIO         ; configure SIO
  LD      A,0             ; set high byte of interrupt vectors to point to page 0
  LD      I,A

  IM      2               ; set int mode 2
  EI                      ; enable interupts

  LD      A,0     ; load initial value into RAM
  LD      (RAMCELL),A
	LD      (RESET_SONG),A

  CALL    A_RTS_OFF        ; remove RTS

  ;Show some numbers:
	LD	A,0
	LD	(ram_counter),A
	LD	A,1              ;Offset for the number to display
	CALL	delay

	CALL LCD_PREPARE
	LD HL, STARTUP_STR
	CALL LCD_MESSAGE


	CALL BOOTSTRAP
	

INCLUDE	'dtz80-lib.inc'
INCLUDE 'sio-ctc-init.inc'

ERROR_STR
	DB 'ERROR',0

STARTUP_STR
  DB '8 Bit Music Player',0

PLAYING_STR
  DB 'PLAYING ',0

STOP_STR
  DB 'STOPPED',0	


RX_CHA_AVAILABLE:
        IN      A,(SIO_DA)      ; read RX character into A

        LD      HL,SCAN_LOOKUP     ; fetch scancode from lookup table
        LD      B,0
        LD      C,A
        ADC     HL,BC
        LD      A,(HL)

				LD  (RESET_SONG),A

       	LD   DE,CHECK_SCANCODE_FOR_SONG ;This will be the address on the stack after the interrupt
       	PUSH DE          ;Put on Stack. Will jump here after RETI

        EI
        RETI

SPEC_RX_CONDITON:
				LD HL, ERROR_STR
				CALL LCD_MESSAGE
				CALL DELAY
        JP      0000h            ; if buffer overrun then restart the program				

; Check for input character in (RESET_SONG) and plays song number
CHECK_SCANCODE_FOR_SONG:
				CALL LCD_PREPARE; delete screen
				LD HL, PLAYING_STR;
				CALL LCD_MESSAGE; "PLAYING "

				LD A,(RESET_SONG); fetch input character
				OUT     (lcd_data),A ;Output the character

				;Check for input number
				CP '1'
				JR Z,SELECT_1
								
				CP '2'
				JR Z,SELECT_2

				CP '3'
				JR Z,SELECT_3

				CP '4'
				JR Z,SELECT_4

				CP '5'
				JR Z,SELECT_5

				CP '6'
				JR Z,SELECT_6

				CP SPACE
				JR Z,SELECT_SPACE
			

				;Default:
				LD HL, SONG


				JR CHECK_SCANCODE_FOR_SONG_END
SELECT_1:
				LD HL, SONG
				JR CHECK_SCANCODE_FOR_SONG_END
SELECT_2:
				LD HL, SONG2
				JR CHECK_SCANCODE_FOR_SONG_END
SELECT_3:
				LD HL, SONG3
				JR CHECK_SCANCODE_FOR_SONG_END
SELECT_4:
				LD HL, SONG4
				JR CHECK_SCANCODE_FOR_SONG_END
SELECT_5:
				LD HL, SONG5
				JR CHECK_SCANCODE_FOR_SONG_END
SELECT_6:
				LD HL, SONG6
				JR CHECK_SCANCODE_FOR_SONG_END
SELECT_SPACE:; mute:
					XOR	A
					LD	H,A
					LD	L,A
					LD	(AYREGS+AmplA),A
					LD	(AYREGS+AmplB),HL
					XOR	A
					LD	C,SOUND_REGISTER
					LD	HL,AYREGS
LOUT2:
					OUT	(C),A
					LD	C,SOUND_DATA
					OUTI
					LD	C,SOUND_REGISTER
					INC	A
					CP	13
					JR	NZ,LOUT2
					OUT	(C),A
					
					LD HL,(STOP_STR
					CALL LCD_MESSAGE

SELECT_SPACE_LOOP:
					CALL DELAY
					JR SELECT_SPACE_LOOP
					

				
CHECK_SCANCODE_FOR_SONG_END:
				LD a,0
				LD (RESET_SONG),A;reset input character here
				JP STARTHL;Start player with song in HL
; --- END Check Scancode

; Music tracks:
SONG EQU	$
	INCBIN	"../tunes/through_yeovil.pt3"
SONG2 EQU $
	INCBIN  "../tunes/MmcM_-_Summer_of_Rain.pt3"
SONG3 EQU $
	INCBIN  "../tunes/altitude.pt3"
SONG4 EQU $
  INCBIN  "../tunes/Voxel - Ghostbusters (TSmix) by voxel_triumph.pt3"
SONG5 EQU $
  INCBIN  "../tunes/MmcM_-_Agressive_Attack.pt3"
SONG6 EQU $
  INCBIN  "../tunes/backup_forever.pt3"


BOOTSTRAP:
  ;copy into RAM:
	LD	HL,BOOTSTRAP_END ;Code to be moved
	LD	DE,RAM_DEST ;Destination address
	LD	BC,28000;guess how much bytes to copy
	LDIR                ;Copy
	JP	#8000; JP to RAM where the program has been copied to



; -------------------
; Player Code copied in RAM:
; -------------------
BOOTSTRAP_END:
ORG
	#8000,BOOTSTRAP_END
START_RAM:


	LD	A,0
	LD	(START+10),A
	LD HL,SONG
	CALL	STARTHL

; The Music player code:
INCLUDE 'player.inc'


RAM_END
	EQU	$ ;end address to copy into ram
