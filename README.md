# dtZ80 - A simple 8 Bit Computer based on the Z80 CPU

This started as a project during the second Corona lockdown in Germany.
I wanted to design my own 8 Bit computer and decided to use the Z80 CPU.
The first idea was to use a MOS 6502 because a variant of that powers the C64, a computer I used much in my childhood.
The Z80 is easier to source so I used that instead.

I started on breadboards but quickly discovered the limits of that so I soldered some prototypes and finally designed some PCBs with kicad.

The bus is compatible to the Bus of the [RC2014 Z80 computer](https://rc2014.co.uk/), so I can exchange expansion cards.

This documentation now covers the new "Black Edition", a board without the need to use extension cards.


## Tools
* [rasm](https://github.com/mkoloberdin/rasm) is used as the assembler.
* [Visual Studio Code](https://code.visualstudio.com/) is used as an editor and enviroment for assembler
* [Minipro](https://gitlab.com/DavidGriffith/minipro/) is used to flash the EEPROMs, the hardware is a TL866 II PLUS

## Images

![dtZ80 Black Edition](/images/dtZ80-Black_Edition.jpg)


### Address Space
    $00: I/O port 7 segment (A0-A7=0)
    $04: LCD command I/O port (A5=1)
    $05: LCD data I/O port (A5=1,A0=1)
    $40: SIO Data Channel A
    $42: SIO Control Channel A
    $60: CTC Channel 0
    $61: CTC Channel 1
    $62: CTC Channel 2
    $63: CTC Channel 3
    $80: Sound Register
    $81: Sound Data


#### LCD
The black edition uses a 4 line, 20 column LCD Display (2004A V1.1) probably based on the HD44780 Chip [(Datasheet)](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf).
It behaves strangely if we send character by character to it, it uses line 3 after line 1 and the lines 2 and 4 are not usable. We have to manually set the DDRAM address holding the character position according to the current line:

    Line 1: $00 - $13
    Line 2: $40 - $53
    Line 3: $14 - $27
    Line 4: $54 - $67

I assume this is due to backwarts compatibility to 2 line displays.

#### Parallel Interface
The 8 Bit parallel Interface is used to connect a lcd screen mainly. Due to an error while designing the pcb, it has the following pins (GND=Pin 1):

![Parallel Port](/images/parallel-port.png "Parallel Port")

#### Serial Interface
TODO

### CTC Clock Timer Chip
TODO

### Sound
TODO




## Next steps / TODOs

Document the new, integrated "Black Edition"!


### Graphics
Graphics is not finished yet. These are some ideas:
Based on: TMS9918A
Problem: Works only with DRAM for SRAM
Looks like you will need to latch the address bits 8-15 when RAS goes low
Connect (/CAS0 AND /CAS1) to /OE on the SRAM and use one of them for A16 also
Important: Clock 10.738635 Mhz, Type ‎MP107-E‎ for video timing
Use schematics from: https://github.com/jblang/TMS9918A




## Links
* [Bread 80](https://bread80.com/) A Z80 on breadboards
* [RC2014](https://rc2014.co.uk/) Another Z80 project
* [LM80C Color Computer](https://hackaday.io/project/165246-lm80c-color-computer) Another Z80 Computer, interesting because of graphics output
* [Z80 Assembler for dummies](https://www.msx.org/wiki/Z80_Assembler_for_Dummies) Z80 Assembler Guide

## More images
![dtZ80](/images/dtZ80.jpg)
![CPU Card](/images/cpu-board.jpg)