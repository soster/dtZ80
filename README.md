# dtZ80 - A simple 8 Bit Computer based on the Z80 CPU

This started as a project during the second Corona lockdown in Germany.
I wanted to design my own 8 Bit computer and decided to use the Z80 CPU.
The first idea was to use a MOS 6502 because a variant of that powers the C64, a computer I used much in my childhood.
The Z80 is easier to source so I used that instead.

I started on breadboards but quickly discovered the limits of that so I soldered some prototypes and finally designed some PCBs with kicad.

The bus is compatible to the Bus of the [RC2014 Z80 computer](https://rc2014.co.uk/), so I can exchange expansion cards (I use the RC2014 soundcard which is great!)


## Tools
* [rasm](https://github.com/mkoloberdin/rasm) is used as the assembler.
* [Visual Studio Code](https://code.visualstudio.com/) is used as an editor and enviroment for assembler
* [Minipro](https://gitlab.com/DavidGriffith/minipro/) is used to flash the EEPROMs, the hardware is a TL866 II PLUS

## Images

![dtZ80](/images/dtZ80.jpg)
![CPU Card](/images/cpu-board.jpg)





### IO Board

#### Address Space
The 74LS138 determines the address space:

    0x00 = 7 Segment display
    0x20 = Parallel Port (LCD Display)
    0x40 = SIO
    0x60 = CTC
    0x80 = PS/2 Keyboard Connector

#### Parallel Interface
The 8 Bit parallel Interface is used to connect a lcd screen mainly. Due to an error while designing the pcb, it has the following pins (GND=Pin 1):

![Parallel Port](/images/parallel-port.png "Parallel Port")

#### Serial Interface
Chip to use: Z84C40, called SIO
http://rc2014.co.uk/wp-content/uploads/2017/06/SIO2.pdf

B/A SelPort B or A Select(input, active High). This pin defines which port isaccessed during a data transfer between the Z80 CPU and the Z80 PIO. ALow level on this pin selects Port A while a High level selects Port B.Often, Address bit A0 from the CPU is used for this selection function.C/D SelControl or Data Select(input, active High). This pin defines the type ofdata transfer to be performed between the CPU and the PIO. A High levelon this pin during a CPU write to the PIO causes the Z80 data bus to beinterpreted as a command for the port selected by the B/A Select line. ALowlevelonthispinmeansthattheZ80databusisbeingusedtotransferdata between the CPU and the PIO. Often, Address bit Al from the CPU isused for this function.


### Sound
We use the RC2014 sound card from here: [RC2014 YM2149](https://github.com/electrified/rc2014-ym2149)

It is jumpered to use this address space:

    0xd0 = Data Port
    0xd8 = Register Port



## Next steps
### Graphics
Based on: TMS9918A
Problem: Works only with DRAM for SRAM
Looks like you will need to latch the address bits 8-15 when RAS goes low
Connect (/CAS0 AND /CAS1) to /OE on the SRAM and use one of them for A16 also
Important: Clock 10.738635 Mhz, Type ‎MP107-E‎ for video timing


## Links
* [Bread 80](https://bread80.com/) A Z80 on breadboards
* [RC2014](https://rc2014.co.uk/) Another Z80 project
* [LM80C Color Computer](https://hackaday.io/project/165246-lm80c-color-computer) Another Z80 Computer, interesting because of graphics output
* [Z80 Assembler for dummies](https://www.msx.org/wiki/Z80_Assembler_for_Dummies) Z80 Assembler Guide
