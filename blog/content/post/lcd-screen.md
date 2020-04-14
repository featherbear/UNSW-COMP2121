---
title: "LCD Screen"
date: 2020-04-14T22:39:45+10:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

The LCD Screen has its own microcontroller (MPU) that manages the low-level manipulation of the LCD panel itself.  
Our job is to use our microcontroller to interface with its microcontroller.

# Instruction Register (IR)

* Display Clear Instruction
* Cursor Shift Instruction
* Display Data RAM Address
* Character Generator RAM Address

# Data Register (DR)

* Data to be read/written to/from the Display Data RAM

---

When the LCD module is busy performing internal operations, the busy flag (DB7 pin) is set to 1.  
No instructions may be written until the flag is set to 0.

# Typical Instructions

Commands follow the followings pins bits: RS R/W DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0

* Clear Display - `0 0 0 0 0 0 0 0 0 1`
* Return Cursor - `0 0 0 0 0 0 0 0 1 _` - Move cursor to start of screen
* Entry Mode Set - `0 0 0 0 0 0 0 1 I/D S` - Sets Increment/Decrement and Shift modes
  * I/D: Increments (I/D = 1) or decrements (ID = 0) the DD RAM address by 1 when a character code is written into or read from the DD RAM.
  * The cursor or blink moves to the right when incremented by +1.
  * The same applies to writing and reading the CG RAM.
  S: Shifts the entire display either to the right or to the left when S = 1; shift to the left when I/D = 1 and to the right when I/D = 0.
* Display Control - `0 0 0 0 0 0 1 D  C B`
  * D - display ON or OFF
  * C - cursor ON or OFF
  * B - cursor blink ON or OFF
* Cursor or Display Shift - `0 0 0 0 0 1 S/C R/L x x`
  * S/C - Shift screen (1), shift cursor (0)
  * R/L - Shift right (1), shift left (1)
* Function Set - `0 0 0 0 1 DL N F x x`
  * DL = 1, 8 –bits; otherwise 4 bits
  * N: Sets the number of lines
    * N = 0 : 1 line display
    * N = 1 : 2 line display
  * F: Sets character font.
    * F = 1 : 5 x 10 dots
    * F = 0 : 5 x 7 dots
* Read Busy Flag and Address - `0 1 BF A A A A A A A`
  * Reads the busy flag (BF) and value of the address counter (AC). BF = 1 indicates that on internal operation is in progress and  the next instruction will not be accepted until BF is set to ‘0’. If the display is written while BF = 1, abnormal operation will occur.
* Write Data to CG or DD RAM - `1 0 D D D D D D D D'
  * Writes binary 8-bit data DDDDDDDD to the CG or DD RAM
  * Writes to CG or DD, depending on the previous command

# Initialisation

It is recommended to initialise the LCD display with software rather than purely relying on its internal reset circuitry.

* Power ON
* Wait for VCC to reach 4.5V
* Wait 15ms
* Function Set - `000011xxxx`
* Wait 4.1ms
* Function Set - `000011xxxx`
* Wait for 100us
* Function Set - `000011xxxx`
* Function Set - `000011NFxx` - Set lines and display font
* Display Off - `0000001000`
* Clear Display - `0000000001`
* Entry Mode Set - `00000001 I/D S`
* Display On - `00000011CB`