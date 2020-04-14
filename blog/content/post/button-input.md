---
title: "Button and Key Input"
date: 2020-04-14T22:02:04+10:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

The most basic type of input device is a (binary) switch - It is either pressed or released.  

Hardware devices are able to read this state as either HIGH or LOW... 1 or 0.


# Bouncing and Debouncing

As a switch is mechanical - when pressed, the metallic contacts rub against each other.  
In this process, the contact is created and broken many times.  
As a result, an external interrupt for instance may be triggered multiple times from a single button press.  

Debouncing is the implementation of extra hardware or software that mitigates this issue.

## Hardware Debouncing

We don't do that here (in this course).  

<!-- Capacitor -->

## Software Debouncing

### Counter (Poll)

Wait for `n` time, check if the button is still pressed/released.  

### Timer

Start a timer for `n` time.  
Dismiss any switch press/release event until the timer expires.

# Multiple Switches

A simple way to get `n` different switches is to use `n` switches, each connected to a unique pin on a hardware controller.  

However this can be challenging and expensive, as to fit 101 switches (ie keys on a keyboard), you would need to layout 101 wire traces connected to 101 pins, in a very small space.

# Multiplexing Switches

If switches can be arranged into a two-dimensional array, then the number of required pins can be greatly reduced.  

The number of required pins would be `width + length`.  
For example, 101 switches can be represented with a 10x11 grid, and therefore need only `10 + 11 = 21` pins to represent 101 switches!  

## Ghosting

Ghosting is an issue that occurs as a consequence to using a 2D array.  
Pressing one key may stimulate the circuit in a way such that the controller sees other keys as being pressed when they're in fact not.  

To solve this issue, a diode (an electrical component that allows current to flow in only one way) can added to each switch.

## Hardware Setup

The switches are arranged into the best grid size where the `width + length` is minimal.  
Columns are connected together, and rows are connected together.  
Diodes are placed in line with each switch.  

Each row and column wire is connected to a pin on a controller.

## Software Setup

> Assuming values read as LOW are considered as pressed

One set of the pins (usually the columns) are to be used as OUTPUT pins, and become circuit grounds.  
The other set of pins (usually the rows) are to be used as INPUT_PULLUP pins, and become attached to the VCC.

The demultiplexing works by systematically setting the pin for each column to LOW (one at time), and reading each row pin.  
If a button was pressed, the controller will read a LOW (0) for that row; and it stores the state for that column-row position.  
Buttons that are released will report a HIGH (1)

**Pseudo**  
```pseudo
init:
  for column:
    set column to INPUT // disabled bc grounded
    for row:
      set row to INPUT // disabled bc grounded

read:
  for column:
    column set to OUTPUT; set to LOW - GND
    for row:
      row set to INPUT_PULLUP, digitalRead, then set back to INPUT (GND)
    column set to INPUT

//         5 V
//          |
//          R
//          |
//   ---------------
//  /
//  |
// GND
```