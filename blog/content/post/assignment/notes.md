---
title: "Microwave Oven Simulator - Notes"
description: "Conceptual Design and Development"
date: 2020-03-16T11:57:11+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

# Microwave Oven Simulator - Conceptual Design and Development

# Introduction

* Briefly explain what you trying to achieve
* Briefly explain key points in design and development
* Justify key design decisions you made

# Hardware Design

* How do the pins in the 2560 microcontroller connect to the external component (such as LEDs, LCD, motor etc)?
* Which internal hardware modules (timer0, timer1..., PWM, ADC, UART, I/O ports etc) of the microcontroller did you use? For what  purpose did you use each of them and why?
* What will be the configuration values you would write to corresponding configuration registers of each of those hardware modules? Show any computations if any.
* Which types of memory will you use (program memory, data memory, EEPROM) and for what? How many bytes are required in each type of memory and which data structures reside in which type of memory?

# Software Design

* The high-level diagram that shows the connection between input, data
structures, tasks and outputs (example given in the figure below)
* Which interrupts will you use and for which purpose will you use each?
* Write pseudo code for those interrupts.
* How would you modularise the design into functions and/or macros?
* Write pseudo code for those functions and/or macro.
* Write the pseudo-code for the main function.

---

# Microwave Modes

* Entry Mode
  * Enter in the cooking time
  * Configure the microwave
* Running Mode
  * Magnetron activated
  * Turntable activated
  * Countdown activated
* Paused
  * Activated when STOP pressed while running
  * Activate when OPEN / CLOSE pressed while running
  * START to resume
  * STOP to cancel
  * Microwave is part-way through cooking, but has stopped
* Finished
  * Cooking completed
  * Display "Done" on line 1
  * Display "Remove food" on line 2


# Display (LCD)

* Remaining time (top left) 
* 0 seconds left should not be displayed
* Format: `mm:ss` (leading zero)

* Turntable position (top right)
* Door open closed (bottom right)
* Status text

## Brightness

* Standby screen after 10 seconds.  
* Fade over 500ms when turning off.  
* Reactivate on (any) key press  
* **RUNNING mode** - Always on

# Buttons

## Number Keys (0-9)

* Active only when in **ENTRY mode**
* Time should update as buttons are pressed
* Maximum four digits - other inputs ignored afterwards

## Start Button (*)

* Asterisks `*` key to start
* If no time entered, default to 1 minute
* When in **RUNNING mode**, pressing start will add another minute to the cooking time

## Stop Button (#)

* Hash `#` key to stop
* When in **ENTRY mode**, pressing stop will clear the time
* When in **RUNNING mode**, pressing stop will pause the operation
* When in **PAUSED mode**, pressing stop will cancel the operation

## Open and Close (Push Buttons)

* Left push button - OPEN
* Right push button - CLOSE

* Start as closed
* No keypad input accepted

## Power Level (A)

* Then **1** - 100%
* Then **2** - 50%
* Then **3** - 25%
* Then **#** - Cancel

# Turntable Rotation Emulation

* Display on the top right corner at all times
* Cycle through the characters: `-`, `/`, `|`, `\`
* 3 revolutions per second
  * Each character display every 1/12th of a second

# Magnetron Activity

* Spin the motor at approximately 70 revolutions per second.  

* Power level may differ, which changes the speed of the motor

# Door

* When the door is open - show the top most LED
* Show O/C on the LCD