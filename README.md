# LPT Capture
Capture the output from a parallel printer port.

![](PCB/out/LPT_Capture.jpg)
![](LPT_Capture.1.jpg)
![](LPT_Capture.2.jpg)
![](LPT_Capture.3.jpg)
![](LPT_Capture.4.jpg)
![](PCB/out/LPT_Capture.top.jpg)
![](PCB/out/LPT_Capture.bottom.jpg)
![](PCB/out/LPT_Capture.svg)

PCB: [OSHPark](https://oshpark.com/shared_projects/DqbtiuyI), [PCBWAY](https://www.pcbway.com/project/shareproject/LPT_Capture.html)  
BOM: [DigiKey](https://www.digikey.com/short/wqdmr8p4)

The DigiKey cart includes a USB cable just for reference & completeness which you may want to remove.

# Usage
Plug the device directly into the parallel printer port on a vintage computer.  
Connect a modern machine to the mico-usb port.  

The device appears as a usb-serial adapter to the modern machine. Drivers are standard in any modern os or platform.  
Use any serial comm program like PuTTY or TeraTerm or minicom or gnu screen etc to read the COM port.  
It doesn't matter what baud rate you select in the comm program.  

Print to the LPT port on the vintage machine.

Read the data from the COM port on the modern machine.

# Credits
This is a refinement of [LptCap](https://www-user.tu-chemnitz.de/~heha/basteln/PC/LptCap/index.en.htm)

Differences from the original LptCap:  
* Re-drawn in KiCad instead of Eagle
* SSOP chip instead of QFN - easier to hand solder
* 0805 passives instead of 0603 - easier to hand solder
* microusb port instead of miniusb - cables are more common
* mid-mount usb port - plug exactly centered in the opening for less strain on all parts
* Snap-together backshell instead of screws & nuts
* Pullups to VCC (5V) instead of 3V3OUT - LPT signals are 5V
* VBUS & VCC power conditioning per FT245R datasheet
