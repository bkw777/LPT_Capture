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

The hole in the backshell is 11mm. Most cables with oval heads will fit.  
The BOM includes a cable which you can remove if you don't need it.  
For another common example, a [Raspberry Pi cable](https://thepihut.com/collections/raspberry-pi-cables/products/raspberry-pi-micro-usb-cable) fits.

Example usage: https://github.com/bkw777/TPDD_stuff  
(TRS-80 Model 100 has a floppy disk peripheral that uses the serial port, and is much larger than the available ram, and so this raw sector dumping utility has an option to read the entire disk and stream the output to the printer port. LPT_Capture plus any generic serial comm program like PuTTY or minicom can collect that output to a file as though it were a serial connection.)
