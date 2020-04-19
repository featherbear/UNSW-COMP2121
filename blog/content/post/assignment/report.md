---
title: "Microwave Oven Simulator - Report"
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

Microwave Oven Simulator - Conceptual Design and Development
---

Author: Andrew Wong (z5206677)

# Introduction

This project aims to create a simulated Microwave Oven with an ATMega2560 AVR board.  

A successful implementation of a simulated microwave oven requires the simulation of a turntable, timer, magnetron, operational buttons, a door, and a display.

## State Table

The below table outlines the functionality, and operations that the microwave oven will perform depending on its current state.

|   MODE |Turntable|Countdown|Magnetron| Time | Door  |  LCD |  LED |Brightness|[0]-[9]|[START]|[STOP]|[OPEN]|[CLOSE]| [A] |
|:------:|:-------:|:-------:|:-------:|:----:|:-----:|:----:|:----:|:--------:|:-----:|:-----:|:----:|:----:|:-----:|:---:|
|ENTRY   |         |         |         | SHOW |   C   |  -   |  -   |   FADE   | INPUT | START |RESET |DOOR  |   -   | PWR |
|RUNNING | ROTATE  |  TIMER  | ROTATE  | SHOW |   C   |  -   |  -   |    ON    |   -   |  ADD  |PAUSE |PAUSE -> DOOR|   -   |  -  |
|PAUSED  |         |         |         | SHOW |   C   |  -   |  -   |   FADE   |   -   | START |RESET |DOOR  |   -   |  -   |
|FINISHED|         |         |         |  -   |   C   | DONE |  -   |   FADE   |   -   |   -   |RESET |RESET -> DOOR|   -    |  -  |
|SET PWR |    -    |    -    |    -    | SHOW |   C   | PWR  |  -   |   FADE   | 1/2/3 |   -   |BACK  |DOOR  |   -   |   -   |
|DOOR    |    -    |    -    |    -    | SHOW |   O   |  -   |  ON   |    -     |   -   |   -   |  -   |   -  |   -   |  -  |

## State Operation

* The `ENTRY` state waits for the user to enter a time with the numerical keypad (0-9).
  * Pressing [START] will enter the `RUNNING` state
    * There is a maximum of 99 minutes and 59 seconds of continual running operation
    * If no time was entered, the microwave will automatically start a timer for 1 minute (60 seconds)
  * Pressing [A] will enter the `SET PWR` menu mode
    * Pressing [1] will set the magnetron intensity to 100%
    * Pressing [2] will set the magnetron intensity to 75%
    * Pressing [3] will set the magnetron intensity to 50%
    * After [1]/[2]/[3]/[#] is pressed, the microwave will return to the `ENTRY` menu
  * Pressing [STOP] will reset the timer to 0 seconds

* The `RUNNING` state simulates the cooking of the food
  * The turntable is rotated
  * The magnetron is activated
  * The timer is activated
  * Pressing [START] will add another minute (60 seconds) to the timer

* The `PAUSED` state simulates a temporary halt in cooking operation
  * The turntable is stopped
  * The magnetron is deactivated
  * The timer is deactivated
  * Pressing [START] will cause the microwave to resume cooking in the `RUNNING` state
  * Pressing [STOP] will cancel the cooking job, and the microwave will return to the `ENTRY` state

* The `FINISHED` state simulates a finished cooking operation
  * This state occurs when the timer reaches 0
  * The turntable is stopped
  * The magnetron is deactivated
  * The timer is deactivated
  * Pressing [STOP] or [OPEN] will return the microwave to the `ENTRY` state

* When the magnetron is activated, the LED bars will show the intensity of the magnetron

* At all times, pressing [OPEN] will halt all operations
  * The door LED will activate
  * No button input will work until the [CLOSE] button is pressed
    * The door LED will deactivate
    * The microwave will then resume operation
  * If the microwave was in the `RUNNING` state, the state will first change to `PAUSED`
  * If the microwave was in the `FINISHED` state, the state will first change to `ENTRY`

* At all times, if the backlight is dimmed then any button press will wake up the display

* The timer causes a counter to decrement every second
    * Every time the counter decrements, the new time is displayed on the LCD screen (top-left)
    * If the timer reaches zero, the microwave enters the `FINISHED` state

## Decisions

### Backlight

When the backlight is dimmed, any keypad button will reactivate the display - however the keypad function will be dismissed if invalid at the time of press

### Door Open LED

When the microwave door is open, the STROBE LED will be turned on continually

### Input Design

I have decided to implement all buttons to trigger as an interrupt.  
To mitigate switch bouncing - **All buttons will share a single software debouncer** (`timer0`).  
Whilst the OPEN and CLOSE buttons don't _really_ need to be debounced, we'll do it anyway.

# Implementation

## Keypad

The example keypad checking code (Lab 4) executes under the guise that it will be run continually in a loop.  
To migrate this code into an interrupt-based routine, the keypads buttons have been assigned to `Port K` - which also serves as `PCINT23:16`.  

Using `Pin Change Interrupt 2`, keypad presses will trigger the `PCINT2` interrupt

# Setup

## Component-Hardware Map

|Microwave Component|Hardware Device|      Component Port     |    Board/AVR Port   |
|:-----------------:|:-------------:|:-----------------------:|:-------------------:|
|     Turntable     |      LCD      |                         |                     |
|     Countdown     |      LCD      |                         |                     |
|     Magnetron     |     MOTOR     |                         |                     |
|    Power Level    |      LED      | [LED0-LED7] [LED8-LED9] | [PC0-PC7] [PG0-PG1] |
|   Start Button    |       *       |          KEYPAD         |       [PK0-PK7]     |
|    Stop Button    |       #       |          KEYPAD         |       [PK0-PK7]     |
|    Open Button    |  PUSH BUTTON  |           PB1           |      RDX3 (PD1)     |
|   Close Button    |  PUSH BUTTON  |           PB0           |      RDX4 (PD0)     |
|   Power Select    |       A       |          KEYPAD         |       [PK0-PK7]     |
|    Numeric Pad    |    KEYPAD     |          KEYPAD         |       [PK0-PK7]     |
|    Door Light     |    STROBE     |           LED           |         PG2         |
|    Door Status    |      LCD      |                         |                     |
|  Status Message   |      LCD      |                         |                     |

## Button Setup

## Register Usage

|Category|Purpose|Register|
|:------:|:-----:|:------:|
|System|System State|`r0`|
|-|General Temporary|`r17`|
|Input|Input Ready Flag|`r18`|
|Input|Debouncer Temporary|`r19`|

### System State - `r0`

|  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|PWR_0|PWR_1|POWER_CFG|DOOR_OPEN|FINISHED|PAUSED|RUNNING|ENTRY|

* Bits 7-6 define the power level
  * `1|1` - 100% _(default)_
  * `1|0` - 75%
  * `0|1` - 50%
  * `0|0` - _undefined_
* Bits 0-5 define the current mode
 
## Software Implementation

### Define macros

* `StartDebouncer`
  * Set the `r18` register to `0` - Disable button input
  * Set the `TCNT0` register to `0` - Clear the timer
  * Set the `r19` register to `0` - Clear the previous ticks
  * Set the `TIMSK0` register to `0b1` - Enable timer

* `StopDebouncer`
  * Set the `TIMSK0` register to `0b1` - Disable timer
  * Set the `r18` register to `1` - Enable button input

* `StrobeLEDOn`
  * Get the value of the `PORTG` register
  * Bitwise OR the value with `0b100` - Enable G2
  * Store the new value into the `PORTG` register

* `StrobeLEDOff`
  * Get the value of the `PORTG` register
  * Bitwise AND the value with `0b11111011` - Disable G2
  * Store the new value into the `PORTG` register

* `isEntry`
  * Copy `r0` to `r17`
  * Bitwise AND `r17` with `0b1`

* `isRunning`
  * Copy `r0` to `r17`
  * Bitwise AND `r17` with `0b10`

* `isPaused`
  * Copy `r0` to `r17`
  * Bitwise AND `r17` with `0b100`

* `isFinished`
  * Copy `r0` to `r17`
  * Bitwise AND `r17` with `0b1000`

* `isDoorOpen`
  * Copy `r0` to `r17`
  * Bitwise AND `r17` with `0b10000`


### Set up Interrupt Vector Table

|Address|\(r)jmp|
|:-----:|:----:|
|RESET (`0x0000`)|`init`|
|`INT0addr`|`btnClose`|
|`INT1addr`|`btnOpen`|
|`PCINT2addr`|`btnKeypad`|
|`OVF0addr`|`Timer0OVF`|

### [`btnClose`]

* Dismiss if input not ready (`r18 != 1`)
* macro:`StartDebouncer`
* TODO: Logic
* macro:`StrobeLEDOff`
* Return from interrupt

### [`btnOpen`]

* Dismiss if input not ready (`r18 != 1`)
* macro:`StartDebouncer`
* TODO: Logic
* macro:`StrobeLEDOn`
* Return from interrupt

### [`btnKeypad`]

* Dismiss if input not ready (`r18 != 1`)
* macro:`StartDebouncer`
* TODO: Logic
* Return from interrupt

### [`Timer0OVF`]

* Increment register `r19` - Tick count
* Stop debounce if `r19` is 156 (20ms has passed)
* Return from interrupt

_156 ticks calculated by 10^6 microseconds / 128 microseconds per tick * 0.02 seconds (20 milliseconds)_

### [`init`] - Set up devices and ports

* Set up keypad
  * Set `DDRK` register to `0xF0` - K0-K3 for input; K4-K7 for output
  * Set `PCMSK2` register to `0xFF` - Enable PCINT23:16 triggers
  * Set `PCICR` register to `0b100` - Enable PCIE2
* Set up open and close buttons
  * Set `EICRA` register to `0b1010` - Falling edge for INT1 and INT0
  * Set `EIMSK` to `0b11` - Enable INT1 and INT0
* Set up LCD
  * TODO:
* Set up Turntable
  * TODO:
* Set up Magnetron
  * TODO:
* Set up Magnetron level meter (LED Bar)
  * TODO: Use detector? Or just hardcode
  * Set `DDRC` register to `0xFF` - Set all C ports as outputs
  * Set `DDRG` register to `0b11` - Set G0 and G1 as outputs
* Set up Door Open light (Strobe LED)
  * Bitwise OR `DDRG` with `0b100` - Set G2 as an output
* Set up debouncer
  * Set `TCCR0A` register to `0x0`
  * Set `TCCR0B` register to `0b10` - clock as clk_io/8
* Set up program state
  * Use r0
* Enable global interrupts (`sei`)


### [`main`] Main Loop 

* _Idle and wait for interrupts..._


# Improvements

## Modularity

