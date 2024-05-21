# dtZ80 - A simple 8 Bit Computer based on the Z80 CPU

This started as a project during the second Corona lockdown, where I had to much free time.
I wanted to design my own 8 Bit computer and decided to use the Z80 CPU.
The first idea was to use a MOS 6502 because a variant of that powers the C64, a computer I used much in my childhood.
The Z80 is easier to source where I live so I used that instead.

I started on breadboards but quickly discovered the limits of that so I soldered some prototypes and finally designed some PCBs with kicad.

The bus is compatible to the Bus of the [RC2014 Z80 computer](https://rc2014.co.uk/), so I can exchange expansion cards.

This documentation now covers the new "Black Edition" of the dtZ80 (Rev 1), a larger board without the need to use extension cards. Previous prototypes had a common bus board and extension cards for the CPU, RAM etc. All software for the previous prototypes can be found at `asm/prototype` for historical reasons.

The dtZ80 uses a Z80 CPU with clocked with 7.3728 Mhz (which doubles as a clock for serial communication), a Z80 SIO for serial communication, a CTC counter timer, 32kb of RAM and 32kb of ROM and a AY-3-8910A sound chip. It uses a single seven segment display for debugging purposes and a 4 line, 20 characters per line LCD for text output.


## Tools

* [rasm](https://github.com/mkoloberdin/rasm) is used as the assembler.
* [Visual Studio Code](https://code.visualstudio.com/) is used as an editor and enviroment for assembler
* [Minipro](https://gitlab.com/DavidGriffith/minipro/) is used to flash the EEPROMs, the hardware is a TL866 II PLUS
* [ticks](https://github.com/z88dk/z88dk) from the z88dk project is used as an emulator / simulator
* A usb to ttl converter for serial communication (can be switched to 5V levels, only needs TX and RX)

## Images

![dtZ80 Black Edition](/images/dtZ80-Black_Edition.jpg)


### Address Space

Address lines are assigned by a 74LS138 IC (U6) which activates
or deactivates the correct ICs.

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

The serial interface is provided by the Z80 SIO chip (SI0/0). It has two channels, A (J1) and B (J6). The clock is provided by the CTC chip for channel A. If you want to use channel B, you have to connect the clock from the pin CTS from J1 to CTS on J6. Please note that RX and TX are labeled from the point of view of the external device, RX is connected to TX on the SIO and vice versa (this maybe was a stupid decistion).

If you are working with linux and you have a usb to serial converter connected to /dev/ttyUSB0 you can use `screen` to enter serial terminal mode:

    screen /dev/ttyUSB0 19200

To enter serial mode of the dtZ80 simply press enter now.

Screen commands consist of "C-a" or ctrl+a (holding down the control key, and then pressing the 'a' key, then releasing both), to enter the command input mode, then commands may be entered with another key stroke.
To disconnect from the session: Ctrl+a, Ctrl+d, you can then use this to reattach to the session:

    screen -r

To quit screen and close connection: ctrl+a, k.

### CTC Clock Timer Chip

TODO



### PS/2 Keyboard module

For ps/2 keyboard to serial conversion I use a "PS2 Keyboard Driver Serial Port Transmission Module".
 
1. connect TX from the module to TX from J1. The module communicates via serial in 19.200 Baud, 1 Stop bit, no parity.


### Sound

TODO


### Simulator / Emulator

The simulator `ticks` from [https://github.com/z88dk/z88dk](https://github.com/z88dk/z88dk) can be used as a simulator. It provides character output for debugging purposes. Use it like this on assembled binary files:

```
z88dk.z88dk-ticks -iochar 5 bios.bin
```
`-iochar 5` puts out characters just like for the LCD of the dtz80.


## Next steps / TODOs

* Further develop the bios
* Tiny Basic example code: http://cpuville.com/Code/tinybasic2dms_asm.txt
* Document all features


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