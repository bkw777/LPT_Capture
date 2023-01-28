# LPT Capture

![](LPT_Capture.jpg)

![](LPT_Capture.svg)

This is a rendition of [LptCap](https://www-user.tu-chemnitz.de/~heha/basteln/PC/LptCap/index.en.htm)

Differences from the original LptCap:  
* Source in KiCAD instead of Eagle
* SSOP chip instead of QFN
* 0805 passives instead of 0603
* MicroUSB port, mid-mount in cut-out
* Snap-together backshell instead of screws & nuts
* Pullups to VCC instead of 3V3OUT
* VBUS & VCC power conditioning per FT245R datasheet

PCB: [OSHPark](https://oshpark.com/shared_projects/DqbtiuyI), [PCBWAY](https://www.pcbway.com/project/shareproject/LPT_Capture.html)  
BOM: [DigiKey](https://www.digikey.com/short/wqdmr8p4)

The hole in the backshell is 11mm, and the mid-mount usb jack is centered in it, and most cables with oval heads fit.  
The DigiKey BOM cart above includes a cable which you can remove if you don't need it.
For example a [Raspberry Pi cable](https://thepihut.com/collections/raspberry-pi-cables/products/raspberry-pi-micro-usb-cable) fits.

The DB25 is wired to plug directly into a host computer in place of a printer cable.

The FTDI chip provides a virtual usb-serial comm port. Use any comm program like PuTTY or TeraTerm or minicom to etc to read the data. Baud rate doesn't matter.

Example usage: https://github.com/bkw777/TPDD_stuff  
(In that example, TRS-80 Model 100 has only a single serial port, and there is a disk drive that uses the serial port, and there is a sector-dump utility that can read from the disk and write hex out the parallel port.)  
